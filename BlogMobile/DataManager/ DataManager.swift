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
        
        // User Entity에 들어갈 관리 객체 생성
        let userObject = UserCD(context: mainContext)
        userObject.name = "iOS 개발자"
        userObject.account = "test@gmail.com"
        
        newNotice.user = userObject
        
        // table reload
        noticeList.insert(newNotice, at: 0) // 가장 처음에 입력
        
        saveContext()
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

