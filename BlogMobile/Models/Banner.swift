//
//  Banner.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/04.
//

import Foundation

struct Banner {
    var text: String
    var imageName: String
    
    init(text: String, imageName: String) {
        self.text = text
        self.imageName = imageName
    }
    
    static var dummyBannerList = [
        Banner(text: "1", imageName: "coffee"),
        Banner(text: "1", imageName: "coffee"),
        Banner(text: "1", imageName: "coffee"),
        Banner(text: "1", imageName: "coffee"),
        Banner(text: "1", imageName: "coffee"),
        Banner(text: "1", imageName: "coffee")
    ]
}
