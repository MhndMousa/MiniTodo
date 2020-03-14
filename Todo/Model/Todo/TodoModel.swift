//
//  List.swift
//  TodoCoreData
//
//  Created by Muhannad Alnemer on 3/12/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import UIKit
import CoreData

class TodoModel: NSObject {
    
    var datasource:TodoDataSource?
    static var fetchedResultsController = NSFetchedResultsController<Todo>()
    typealias TodoSnapshot = NSDiffableDataSourceSnapshot<TodoStatus, Todo>
    var list: List!
    
    init(tableView: UITableView,list:List) {
        super.init()
        self.list = list
        setFetchedResultsController()
        fetchData()
        setDataSource(tableView)
        applySnapshotChanges()
    }
    
    func setFetchedResultsController() {
        let fetch = NSFetchRequest<Todo>(entityName: "Todo")
        fetch.predicate = NSPredicate(format: "listRefrence = %@", list)
        fetch.sortDescriptors = [NSSortDescriptor(key: "text", ascending: false)]
        TodoModel.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: DataManager.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        TodoModel.fetchedResultsController.delegate = self
    }
    
    func fetchData() {
        do {
            try TodoModel.fetchedResultsController.performFetch()
            applySnapshotChanges()
        } catch {
            print("Error fetching products")
        }
    }
    fileprivate func setDataSource(_ tableView: UITableView) {
        datasource = TodoDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, todo) -> TodoTableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoTableViewCell
            cell.todo = todo
            return cell
        })
    }
    func applySnapshotChanges(_ array :[Todo]? = TodoModel.fetchedResultsController.fetchedObjects) {
        var snapshot = TodoSnapshot()
        snapshot.appendSections(TodoStatus.allCases)
        snapshot.appendItems(array ?? [],  toSection: .unfinished)
        datasource?.apply(snapshot, animatingDifferences: true)
    }
    
}

extension TodoModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        applySnapshotChanges()
    }
}
