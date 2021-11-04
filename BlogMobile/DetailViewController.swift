//
//  DetailViewController.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/03.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tvNotice: UITableView!
    var notice: NoticeCD?

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

        didChangeToken = NotificationCenter.default.addObserver(forName: WriteViewController.noticeDidChange, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            self?.tvNotice.reloadData()
        })
        
        didDeleteToken = NotificationCenter.default.addObserver(forName: WriteViewController.noticeDidDelete, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            self?.navigationController?.popViewController(animated: true)
        })
    }
    
    // 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? WriteViewController {
            vc.editTarget = notice
        }
    }

}

//MARK: - TableVeiw DataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tvNotice {
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tvNotice {
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
            default:
                fatalError()
            }
        }
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
        default:
            fatalError()
        }
    }
}
