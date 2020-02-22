//
//  ViewController.swift
//  Todo
//
//  Created by Muhannad Alnemer on 2/20/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import UIKit


class ViewController: UITableViewController{
    typealias TodoDataSource = UITableViewDiffableDataSource<TodoStatus, Todo>
    typealias TodoSnapshot = NSDiffableDataSourceSnapshot<TodoStatus, Todo>
    let cellId = "cell"
    var datasource :  TodoDataSource!
    var array = TodoList()
    
    fileprivate func configureDataSource() {
        datasource =  DataSource(tableView: self.tableView) { (tableView, indexPath, todo) -> TableViewCell? in
            let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! TableViewCell
            cell.todo = todo
            return cell
        }
    }
    
   
    
    
    fileprivate func populateArray() {
        for i in 1...6
        {
            array.addItem(Todo(string: String(i), status: .unfinished), at: 0)
        }

        array.addItem(Todo(string: String(90), status: .finished), at: 0)
    }
    
    fileprivate func applySnapshot() {
        let  finished  = self.array.placeNames.filter({$0.status == .finished})
        let unfinished = self.array.placeNames.filter({$0.status == .unfinished})
        
        var snapshot = TodoSnapshot()
        snapshot.appendSections(TodoStatus.allCases)
        snapshot.appendItems(unfinished,toSection: .unfinished)
        snapshot.appendItems(finished,  toSection: .finished)
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.frame, style: .insetGrouped)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.tableFooterView = UIView()
        
        populateArray()
        configureDataSource()
        applySnapshot()
        configureNavigationItem()
    }
    func configureNavigationItem() {
        let editingItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action:  #selector(toggleEditing))
        let searchItem =  UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(toggleSearch))
        
        navigationItem.rightBarButtonItems = [editingItem]
        navigationItem.leftBarButtonItems = [searchItem]
    }
    
    @objc
    func toggleEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        configureNavigationItem()
    }

    var isSearching = false
    @objc
    func toggleSearch() {
        isSearching = !isSearching
        if isSearching{
            let a = UISearchBar()
            navigationItem.titleView = a
            a.delegate = self
        }
        else{
            navigationItem.title = "Something"
        }
    }
}


