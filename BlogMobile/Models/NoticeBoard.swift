//
//  NoticeBoard.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/02.
//

import Foundation

struct NoticeBoard: Codable {
    let user: User
    let contents: String
    let comment: String
}
