//
//  NoticeBoardTableViewController.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/02.
//

import UIKit

class NoticeBoardTableViewController: UITableViewController {
    
    let formatter: DateFormatter = { // Closures를 활용
        let format = DateFormatter()
        format.dateStyle = .long
        format.timeStyle = .short
        format.dateFormat = "MM-dd HH:mm"
        format.locale = Locale(identifier: "Ko_kr") // 한글표시
        return format
    }()
    
    var token: NSObjectProtocol? // 메모리 낭비를 줄임
    
    deinit { // 소멸자에서 해제
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 100
        
        // Observers
        token = NotificationCenter.default.addObserver(forName: NoticeViewController.newNoticeDidInsert, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // data 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            if let vc = segue.destination as? DetailViewController {
                vc.notice = NoticeBoard.dummyNoticeBoardList[indexPath.row]
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NoticeBoard.dummyNoticeBoardList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeBoardListTableViewCell", for: indexPath) as! NoticeBoardListTableViewCell

        // Configure the cell...
        let target = NoticeBoard.dummyNoticeBoardList[indexPath.row]
        cell.lblTitle.text = target.title
        cell.lblDate.text = formatter.string(for: target.insertDate)
        cell.lblUser.text = target.user.name
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
