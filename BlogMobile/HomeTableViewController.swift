//
//  HomeTableViewController.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/04.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    @IBOutlet var tvHome: UITableView!
    
    let formatter: DateFormatter = { // Closures를 활용
        let format = DateFormatter()
        format.dateStyle = .long
        format.timeStyle = .short
        format.dateFormat = "MM-dd HH:mm"
        format.locale = Locale(identifier: "Ko_kr") // 한글표시
        return format
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DataManager.shared.fetchNotice()
        tableView.reloadData()
    }
    
    // data 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController {
            guard let target = DataManager.shared.noticeList.first else {
                return
            }
            let notice = target
            notice.views += 1   // 조회수 증가
            DataManager.shared.saveContext()
            vc.notice = target
            vc.indexNotice = 0
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeTitleTableViewCell", for: indexPath)
            cell.textLabel?.text = "안녕하세요!!\n\(User.shared.name)님 반갑습니다."
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeSelectTableViewCell", for: indexPath)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeBannerTableViewCell", for: indexPath) as! HomeBannerTableViewCell
            cell.cvBanner.reloadData()
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeNoticeTitleTableViewCell", for: indexPath)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "noticeBoardListTableViewCell", for: indexPath) as! NoticeBoardListTableViewCell
            
            // Configure the cell...
            guard let target = DataManager.shared.noticeList.first else {
                cell.lblTitle.text = "새 소식이 없습니다."
                cell.lblDate.isHidden = true
                cell.lblUser.isHidden = true
                cell.lblViews.isHidden = true
                return cell
            }
            
            cell.lblDate.isHidden = false
            cell.lblUser.isHidden = false
            cell.lblViews.isHidden = false
            cell.lblTitle.text = target.title
            cell.lblDate.text = formatter.string(for: target.insertDate)
            cell.lblUser.text = target.user?.name
            guard let cntComment = DataManager.shared.noticeList[0].userComment?.allObjects.count else {
                cell.lblViews.text = "👀 \(target.views) 💬 0"
                return cell
            }
            cell.lblViews.text = "👀 \(target.views) 💬 \(cntComment)"
            return cell
        default:
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 100
        }
        return UITableView.automaticDimension
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
