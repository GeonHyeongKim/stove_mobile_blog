//
//  NoticeViewController.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/02.
//

import UIKit

class NoticeViewController: UIViewController {

    @IBOutlet weak var tvNotice: UITextView!
    var editTarget: NoticeBoard?
    var originalNoiceContents: String?
    var noticeTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        insertTitleInNavigation("제목")
        if let notice = editTarget {
            insertTitleInNavigation(notice.title)
            tvNotice.text = notice.contents
            originalNoiceContents = notice.contents
        } else {
            insertTitleInNavigation("")
            tvNotice.text = ""
        }
    }
    
    func insertTitleInNavigation(_ title: String?) {
        noticeTitle = title
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(clickOnTitleButton), for: .touchUpInside)
        navigationItem.titleView = button
    }
    
    @objc func clickOnTitleButton() {
        let alert = UIAlertController(title: "제목을 설정해주세요", message: "10자 이내", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "저장", style: .destructive) { [weak self] (action) in
            self?.insertTitleInNavigation(alert.textFields?[0].text)
        }
        okAction.isEnabled = false
        
        alert.addAction(okAction)
        alert.addTextField{ [self](textField) in
            textField.placeholder = noticeTitle
            textField.addTarget(self, action: #selector(alertTextFieldDidChange), for: .editingChanged)
        }
        let cancleAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] (action) in
            self?.insertTitleInNavigation(self?.noticeTitle)
        }
        alert.addAction(cancleAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func alertTextFieldDidChange(){
        let alertController:UIAlertController = self.presentedViewController as! UIAlertController;
        let textField :UITextField  = alertController.textFields![0];
        let addAction: UIAlertAction = alertController.actions[0];
        addAction.isEnabled = (textField.text?.count)! > 0 && (textField.text?.count)! < 10;
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let contents = tvNotice.text, contents.count > 0 else {  // 글이 입력되지 않았을 경우
            alert(message: "글을 입력해주세요")
            return
        }
        
        guard let title = noticeTitle, title.count > 0 else {  // 제목이 입력되지 않았을 경우
            alert(message: "제목을 입력해주세요")
            return
        }
                
        // 메모가 입력되었을 경우
        if var target = editTarget { // 편집
            target.contents = contents
            target.insertDate = Date()
            NotificationCenter.default.post(name: NoticeViewController.noticeDidChange, object: nil)
        } else { // 새 메모
            NotificationCenter.default.post(name: NoticeViewController.newNoticeDidInsert, object: nil)
        }

        dismiss(animated: true, completion: nil)
    }
}

//MARK: - 새 글이 발생시 List update
extension NoticeViewController {
    static let newNoticeDidInsert = Notification.Name(rawValue: "newNoticeDidInsert")
    static let noticeDidChange = Notification.Name(rawValue: "noticeDidChange")
}
