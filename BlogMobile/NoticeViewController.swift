//
//  NoticeViewController.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/02.
//

import UIKit

class NoticeViewController: UIViewController {

    @IBOutlet weak var tvNotice: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let notice = tvNotice.text, notice.count > 0 else {  // 글이 입력되지 않았을 경우
            alert(message: "글을 입력해주세요")
            return
        }
        
        guard let title = navigationItem.title, title.count > 0 else {  // 제목이 입력되지 않았을 경우
            alert(message: "제목을 입력해주세요")
            return
        }
        
        let newNotice = NoticeBoard(title: title, contents: notice)
        NoticeBoard.dummyNoticeBoardList.append(newNotice)
        
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
