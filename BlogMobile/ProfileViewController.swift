//
//  ProfileViewController.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/04.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfAccount: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        tfName.delegate = self
        tfAccount.delegate = self
        tfName.text = User.shared.name
        tfAccount.text = User.shared.account
    }
    
    @IBAction func save(_ sender: Any) {
        if tfName.text == nil || tfName.text == "" || tfAccount.text == nil || tfAccount.text == "" {
            alert(message: "변경하고자 하는 내용을 입력해주세요.")
            return
        }
        
        view.endEditing(true)
        
        if let name = tfName.text {
            User.shared.name = name
        }
        
        if let account = tfAccount.text {
            User.shared.account = account
        }
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfName {
            tfAccount.becomeFirstResponder()
        } else {
            tfAccount.resignFirstResponder()
        }
        return true
    }
}
