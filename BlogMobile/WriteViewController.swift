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
    var originalNoiceTitle: String?
    var originalNoiceContents: String?
    var noticeTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let notice = editTarget {
            insertTitleInNavigation(notice.title)
            tvNotice.text = notice.contents
            originalNoiceTitle = notice.title
            originalNoiceContents = notice.contents
        } else {
            insertTitleInNavigation("제목 없음")
            tvNotice.text = ""
            toolbar.isHidden = true
        }
        tvNotice.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tvNotice.becomeFirstResponder()
        navigationController?.presentationController?.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tvNotice.resignFirstResponder()
        navigationController?.presentationController?.delegate = nil
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
        let alert = UIAlertController(title: "제목을 설정해주세요", message: "20자 이내", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "저장", style: .destructive) { [weak self] (action) in
            self?.insertTitleInNavigation(alert.textFields?[0].text)
            if #available(iOS 13.0, *) { // 제목이 수정 되었을 때,
                self?.isModalInPresentation = self?.originalNoiceTitle != self?.noticeTitle
            }
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
        addAction.isEnabled = (textField.text?.count)! > 0 && (textField.text?.count)! < 15;
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

//MARK: - UITextViewDelegate
extension WriteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let origin = originalNoiceContents, let edited = textView.text, let originTitle = originalNoiceTitle, let editedTitle = noticeTitle {
            if #available(iOS 13.0, *) {
                isModalInPresentation = (origin != edited) || (originTitle != editedTitle)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

//MARK: - UIAdaptivePresentationControllerDelegate
extension WriteViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "알림", message: "편집한 내용을 저장할까요?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action) in
            self?.save(action)
        }
        
        alert.addAction(okAction)
        
        let cancleAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] (action) in
            self?.close(action)
        }
        
        alert.addAction(cancleAction)
        
        present(alert, animated: true, completion: nil)
    }
}
