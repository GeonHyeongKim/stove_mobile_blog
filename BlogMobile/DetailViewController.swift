//
//  DetailViewController.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/03.
//

import UIKit

class DetailViewController: UIViewController, DetailInputTableDelegate {
    
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
        
        // 본인인만 수정가능
        if notice?.user?.account != User.shared.account {
            self.navigationItem.rightBarButtonItem = nil
        }
        updateCommentList(index) // 댓글에 해당하는 값만 넣기
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
            cell.textLabel?.text = notice?.user?.name
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailComentTableViewCell", for: indexPath)
            cell.textLabel?.text = commentList?[indexPath.row - 4].name
            cell.detailTextLabel?.text = commentList?[indexPath.row - 4].comment
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
