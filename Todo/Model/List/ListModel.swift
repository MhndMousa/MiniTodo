//
//  ListModel.swift
//  Todo
//
//  Created by Muhannad Alnemer on 3/12/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import UIKit
import CoreData

class ListModel: NSObject {

    var datasource:ListDataSource?
    static var fetchedResultsController = NSFetchedResultsController<List>()
    typealias ListSnapShot = NSDiffableDataSourceSnapshot<ListSection,List>
    
    init(tableView: UITableView) {
        super.init()
        setFetchedResultsController()
        fetchData()
        setDataSource(tableView)
        applySnapshotChanges()
    }
    
    func setFetchedResultsController() {
        let fetch = NSFetchRequest<List>(entityName: "List")
        fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        ListModel.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: DataManager.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        ListModel.fetchedResultsController.delegate = self
    }
    
    func fetchData() {
        do {
            try ListModel.fetchedResultsController.performFetch()
            applySnapshotChanges()
        } catch {
            print("Error fetching products")
        }
    }
    
    fileprivate func setDataSource(_ tableView: UITableView) {
        datasource = ListDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, list) -> UITableViewCell? in
            return ListTableViewCell(name: list.name!,
                                     textColor: .systemGray6,
                                     backgroundColor: SystemColors(rawValue: list.color!)!.color,
                                     list: list)
        })
    }
    
    fileprivate func applySnapshotChanges() {
        var snapshot = ListSnapShot()
        snapshot.appendSections([.main])
        snapshot.appendItems(ListModel.fetchedResultsController.fetchedObjects ?? [], toSection: .main)
        datasource?.apply(snapshot, animatingDifferences: true)
    }

}

extension ListModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        applySnapshotChanges()
    }
}

class ListCollectionModel: NSObject {

    var datasource:ListCollectionDataSource?
    static var fetchedResultsController = NSFetchedResultsController<List>()
    typealias ListSnapShot = NSDiffableDataSourceSnapshot<ListSection,List>
    
    init(tableView: UICollectionView,vc: ListTableViewController) {
        super.init()
        setFetchedResultsController()
        fetchData()
        setDataSource(tableView, vc)
        applySnapshotChanges()
    }
    
    func setFetchedResultsController() {
        let fetch = NSFetchRequest<List>(entityName: "List")
        fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        ListModel.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: DataManager.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        ListModel.fetchedResultsController.delegate = self
    }
    
    func fetchData() {
        do {
            try ListModel.fetchedResultsController.performFetch()
            applySnapshotChanges()
        } catch {
            print("Error fetching products")
        }
    }
    
    fileprivate func setDataSource(_ tableView: UICollectionView, _ vc: ListTableViewController) {
        datasource = ListCollectionDataSource(collectionView: tableView, cellProvider: { (collectionView, indexPath, list) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ListCollectionViewCell
            cell.list = list
            cell.delegate = vc
            return cell
        })
    }
    
    fileprivate func applySnapshotChanges() {
        var snapshot = ListSnapShot()
        snapshot.appendSections([.main])
        snapshot.appendItems(ListModel.fetchedResultsController.fetchedObjects ?? [], toSection: .main)
        datasource?.apply(snapshot, animatingDifferences: true)
    }

}

extension ListCollectionModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        applySnapshotChanges()
    }
}
