//
//  DetailViewController.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/03.
//

import UIKit

class DetailViewController: UIViewController, DetailInputTableDelegate, DetailDeleteCommentTableDelegate {
    
    @IBOutlet weak var tvNotice: UITableView!
    
    var indexNotice: Int?
    var notice: NoticeCD?
    var commentList: [CommentCD]?
    
    let formatter: DateFormatter = { // Closures를 활용
        let format = DateFormatter()
        format.dateStyle = .long
        format.timeStyle = .short
        format.dateFormat = "MM-dd HH:mm"
        format.locale = Locale(identifier: "Ko_kr") // 한글표시
        return format
    }()
    
    // 메모리 낭비를 줄임
    var didChangeToken: NSObjectProtocol?
    var didDeleteToken: NSObjectProtocol?
    
    deinit { // 소멸자에서 해제
        if let token = didChangeToken {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = didDeleteToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let index = indexNotice else {
            return
        }
        indexNotice = index
        
        didChangeToken = NotificationCenter.default.addObserver(forName: WriteViewController.noticeDidChange, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            self?.tvNotice.reloadData()
        })
        
        didDeleteToken = NotificationCenter.default.addObserver(forName: WriteViewController.noticeDidDelete, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            self?.navigationController?.popViewController(animated: true)
        })
        
        updateCommentList(index) // 댓글에 해당하는 값만 넣기
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 본인만 수정가능
        guard let account = notice?.user?.account! else {
            tvNotice.reloadData()
            return
        }
        if account != User.shared.account {
            self.navigationItem.setRightBarButton(nil, animated: true)
        } else {
            let rightButton = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(editNotice))
            self.navigationItem.rightBarButtonItem = rightButton
        }
        
        print(account)
        print(User.shared.account)
        tvNotice.reloadData()
    }
    
    // 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? WriteViewController {
            vc.editTarget = notice
        }
    }
    
    func updateCommentList(_ index: Int) {
        commentList = notice?.userComment?.allObjects as? [CommentCD]
        commentList?.sort{$0.insertDate! < $1.insertDate!}
    }
    
    func deleteComment(cell: DetailComentTableViewCell, index: Int) {
        let deleteCommentCD = commentList?.remove(at: index - 4)
        DataManager.shared.deleteComment(deleteCommentCD)
        tvNotice.reloadData()
    }
    
    @objc func editNotice() {
        self.performSegue(withIdentifier: "editSegue", sender: self)
    }
    
}

//MARK: - TableVeiw DataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = commentList?.count else {
            return 4
        }
        return 4 + count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailNoticeTitleTableViewCell", for: indexPath)
            cell.textLabel?.text = notice?.title
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailNoticeUserTableViewCell", for: indexPath)
            cell.textLabel?.text = "\(notice?.user?.name ?? "")\n(\(notice?.user?.account ?? ""))"
            cell.detailTextLabel?.text = formatter.string(from: notice?.insertDate ?? Date())
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailNoticeContentsTableViewCell", for: indexPath)
            cell.textLabel?.text = notice?.contents
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailInputTableViewCell", for: indexPath) as! DetailInputTableViewCell
            cell.delegate = self
            return cell
        case 4...:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailComentTableViewCell", for: indexPath) as! DetailComentTableViewCell
            let target = (commentList?[indexPath.row - 4])! as CommentCD
            cell.lblUser.text = "\(target.name ?? "")(\(target.account ?? ""))"
            cell.lblComent?.text = target.comment
            cell.btnDelete.tag = indexPath.row
            cell.delegate = self
            
            if User.shared.account != target.account { // 본인이 아닐경우
                cell.btnDelete.isHidden = true
            }
            return cell
        default:
            fatalError()
        }
    }
}

//MARK: - UITextFieldDelegate

extension DetailViewController: UITextFieldDelegate {
    func didReturn(cell: DetailInputTableViewCell, string: String?) {
        guard let index = indexNotice else {
            return
        }
        self.notice = DataManager.shared.addComment(index, string)
        updateCommentList(index)
        tvNotice.reloadData()
    }
}
