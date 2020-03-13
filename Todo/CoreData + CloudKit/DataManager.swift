//
//  DataManager.swift
//  Todo
//
//  Created by Muhannad Alnemer on 3/12/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import Foundation
import CloudKit
import CoreData

class DataManager {
    static let shared = DataManager()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    static var managedContext : NSManagedObjectContext {
        let context = DataManager.shared.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    
    // MARK: - Core Data Saving support

    func saveContext (_ completion: @escaping () -> Void ) {
         
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension DataManager{
    static func saveList(name: String?, color:String? = "red") {
        let product = List(context: managedContext)
        product.name = name
        product.color = color
        product.todoList = []
        DataManager.shared.saveContext{}
    }
    static func saveTodo(text: String, status: Int64, list:List){
        let product = Todo(context: managedContext)
        product.text = text
        product.status = status
        product.listRefrence = list
        DataManager.shared.saveContext{}
    }
}
