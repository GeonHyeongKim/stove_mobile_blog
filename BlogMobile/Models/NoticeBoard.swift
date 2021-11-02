//
//  NoticeBoard.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/02.
//

import Foundation

struct NoticeBoard: Codable {
    var user: User
    var contents: String
    var insertDate: Date
//    var comment: String
    
    init(contents: String) {
        user = User(name: "Stove iOS 개발자", account: "ios_developer")
        self.contents = contents
        insertDate = Date()
    }
    
    static var dummyNoticeBoardList = [
        NoticeBoard(contents: "Blog1 ☎️"),
        NoticeBoard(contents: "Blog1 🪙")
    ]
}
