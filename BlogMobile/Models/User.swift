//
//  User.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/02.
//

import Foundation

struct User: Codable {
    var name: String
    var account: String

    static var shared = User(name: "Stove iOS 개발자", account: "ios_developer")
}
