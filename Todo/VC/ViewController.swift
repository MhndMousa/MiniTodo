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
    var todoList = TodoList()
    var searchController = UISearchController(searchResultsController: nil)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        populateArray()
        configureDataSource()
        applySnapshot()
        configureNavigationBar()
    }

    
    
    // MARK: Helpers

    
    func configureNavigationBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Notes"
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:  #selector(addTodo))
        let searchItem =  UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(toggleSearch))
        let settingItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(changeColor))
        self.navigationItem.rightBarButtonItems = [settingItem]
        self.navigationItem.leftBarButtonItems = [addItem, searchItem]
    }
    
    
    fileprivate func configureTable() {
        self.tableView = UITableView(frame: view.frame, style: .insetGrouped)
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: cellId)
        self.tableView.dragInteractionEnabled = true
        self.tableView.dragDelegate = self
        self.tableView.dropDelegate = self
        self.tableView.tableFooterView = UIView()
    }
    
    
    // Configure data source and fill resuable cells
    fileprivate func configureDataSource() {
        datasource =  DataSource(tableView: self.tableView) { (tableView, indexPath, todo) -> TableViewCell? in
            let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! TableViewCell
            cell.todo = todo
            return cell
        }
    }
     
     // #TODO: Add core data integration
     fileprivate func populateArray() {
         for i in 1...6
         {
             todoList.addItem(Todo(string: String(i), status: .unfinished), at: 0)
         }
         todoList.addItem(Todo(string: String(90), status: .finished), at: 0)
     }
     
     // Initial snapshot
     fileprivate func applySnapshot() {
        applySnapshotChanges(self.todoList.list)
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
     }
    
    func applySnapshotChanges(_ array: [Todo]) {
         let finished =      array.filter({$0.status == .finished})
         let unfinished =    array.filter({$0.status == .unfinished})
         
         var snapshot = TodoSnapshot()
         snapshot.appendSections(TodoStatus.allCases)
         snapshot.appendItems(unfinished,toSection: .unfinished)
         snapshot.appendItems(finished,  toSection: .finished)
         datasource.apply(snapshot, animatingDifferences: true)
     }
    
    func promtTodo(){
        
        // Note to self not to forget how DispatchGroup works
        // Number of entries in the stack determain how long the dispatch will hold
        
        // Using Dispatch Group to wait for user input then append it to the list
        let disptach = DispatchGroup()
        disptach.enter()    // Increments the counter
        
        let todo = Todo()
        let alert = UIAlertController(title: "Add Todo", message: nil , preferredStyle: .alert)
        alert.addTextField {$0.placeholder = "Clean the dishes"}
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            todo.string = alert.textFields![0].text!
            todo.status = .unfinished
            disptach.leave() // Leave for every entry
        }))
        
        self.present(alert, animated: true, completion: nil)

        // Will trigger once number of .enter() = number of .leave()
        disptach.notify(queue: .main) {
            self.todoList.appendItem(todo)
            self.applySnapshotChanges(self.todoList.list)
        }
        
    }
    

    // MARK: Handlers
    

    @objc
    func toggleEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    @objc
    func addTodo() {
        promtTodo()
    }
    
    @objc
    func toggleSearch() {
        self.searchController.searchBar.searchTextField.becomeFirstResponder()
    }
    @objc
    func changeColor(){
        let alert = UIAlertController(title: "Change Color" , message: nil, preferredStyle: .actionSheet)
        
        SystemColors.allCases.forEach { (color) in
            alert.addAction(UIAlertAction(title: color.rawValue, style: .default, handler: { (_) in
                UserDefaults.standard.setColor(color: color.color, forKey: "tintColor")
                self.navigationController?.view.tintColor = color.color
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
}




