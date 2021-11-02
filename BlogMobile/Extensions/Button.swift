//
//  UIViewController+Button.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/02.
//

import UIKit

extension UIButton {
    @objc func insertTitleInNavigation(_ title: String?) {
        self.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
//        self.setTitle("Button", for: .normal)
        self.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
    }
    
    @objc func clickOnButton() {
        
    }
}
