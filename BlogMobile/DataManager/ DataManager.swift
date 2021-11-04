//
//   DataManager.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/03.
//

import Foundation

import CoreData

class DataManager {
    static let shared = DataManager()
    private init() {
        
    }
    // Context : Core Data를 관리
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    var noticeList = [NoticeCD]()
    
    // 메모리에서 데이터 읽어오기
    func fetchNotice() {
        let requestNote: NSFetchRequest<NoticeCD> = NoticeCD.fetchRequest()
        
        // 정렬
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false) // 내림차순
        requestNote.sortDescriptors = [sortByDateDesc]
        
        do {
            noticeList = try mainContext.fetch(requestNote)
        } catch {
             print(error)
        }
    }
    
    // 새로운 Notice 생성
    func addNewNotice(_ title: String?, _ contents: String?) {
        let newNotice = NoticeCD(context: mainContext)
        newNotice.title = title
        newNotice.contents = contents
        newNotice.insertDate = Date()
        newNotice.views = 0
        
        // User Entity에 들어갈 관리 객체 생성
        let userObject = UserCD(context: mainContext)
        userObject.name = User.shared.name
        userObject.account = User.shared.account
        
        newNotice.user = userObject
        
        // table reload
        noticeList.insert(newNotice, at: 0) // 가장 처음에 입력
        
        saveContext()
    }
    
    // 새로운 Comment 생성
    func addComment(_ index: Int, _ comment: String?) -> NoticeCD {
        let commentObject = CommentCD(context: mainContext)
        commentObject.comment = comment
        commentObject.name = User.shared.name
        commentObject.account = User.shared.account
        commentObject.noticeNum = Int32(index)
        commentObject.insertDate = Date()
                
        noticeList[index].mutableSetValue(forKey: "userComment").addObjects(from: [commentObject])
        saveContext()
        return noticeList[index]
    }
    
    // 삭제 기능
    func deleteNotice(_ notice: NoticeCD?) {
        if let notice = notice {    // 실제로 notice가 전달될때만 실행
            mainContext.delete(notice)
            saveContext()
        }
    }
    
    // 댓글 삭제 기능
    func deleteComment(_ comment: CommentCD?) {
        if let comment = comment {    // 실제로 comment가 전달될때만 실행
            mainContext.delete(comment)
            saveContext()
        }
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BlogMobile")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

