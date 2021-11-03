//
//  NoticeViewController.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/02.
//

import UIKit

class WriteViewController: UIViewController {

    @IBOutlet weak var tvNotice: UITextView!
    @IBOutlet weak var toolbar: UIToolbar!
    var editTarget: NoticeCD?
    var originalNoiceContents: String?
    var noticeTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let notice = editTarget {
            insertTitleInNavigation(notice.title)
            tvNotice.text = notice.contents
            originalNoiceContents = notice.contents
        } else {
            insertTitleInNavigation("제목 없음")
            tvNotice.text = ""
            toolbar.isHidden = true
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
        if let target = editTarget { // 편집
            target.title = title
            target.contents = contents
            target.insertDate = Date()
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: WriteViewController.noticeDidChange, object: nil)
        } else { // 새 메모
            DataManager.shared.addNewNotice(title, contents)
            NotificationCenter.default.post(name: WriteViewController.newNoticeDidInsert, object: nil)
        }

        dismiss(animated: true, completion: nil)
    }
    @IBAction func deleteNotice(_ sender: Any) {
        let alert = UIAlertController(title: "알림", message: "삭제 확인", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] (action) in
            DataManager.shared.deleteNotice(self?.editTarget)
            self?.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: WriteViewController.noticeDidDelete, object: nil)
        }
        
        alert.addAction(okAction)
        
        let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancleAction)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - 글에 변동이 있을시 List update
extension WriteViewController {
    static let newNoticeDidInsert = Notification.Name(rawValue: "newNoticeDidInsert")
    static let noticeDidChange = Notification.Name(rawValue: "noticeDidChange")
    static let noticeDidDelete = Notification.Name(rawValue: "noticeDidDelete")
}
