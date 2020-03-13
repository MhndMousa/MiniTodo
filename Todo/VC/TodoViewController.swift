//
//  ViewController.swift
//  Todo
//
//  Created by Muhannad Alnemer on 2/20/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import UIKit
import CloudKit

class TodoViewController: UIViewController{
    
    
    let cellId = "cell"
    var todoModel: TodoModel!
    var searchController = UISearchController(searchResultsController: nil)
    var tableView: UITableView!
    var list : List!{
        didSet{
            view.backgroundColor = SystemColors(rawValue: self.list.color!)?.color
            title = self.list.name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = self.view.backgroundColor
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        todoModel = TodoModel(tableView:self.tableView,list:self.list)
        configureNavigationBar()
    }

    
    
    // MARK: Helpers

    fileprivate func configureToolbar(){
        let backgroundSwitcherItem = UIBarButtonItem(customView: UISegmentedControl(items: ["Finished","Unfiinished"]))
        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            backgroundSwitcherItem,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]
    }
    
    func configureNavigationBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["Unfinished","Finished","Both"]
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "خربشة"
        
        let addItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle")!, style: .plain, target: self, action:  #selector(addTodo))
        let searchItem =  UIBarButtonItem(image: UIImage(systemName: "magnifyingglass.circle.fill"), style: .plain, target: self, action: #selector(toggleSearch))
        let settingItem = UIBarButtonItem(image: UIImage(systemName: "pencil.tip.crop.circle")!,style: .plain, target: self, action: #selector(changeColor))
        
        self.navigationItem.rightBarButtonItems = [addItem,settingItem]
    }
    
    
    fileprivate func configureTable() {
        self.tableView = UITableView(frame: view.frame, style: .grouped)
        self.tableView.separatorColor = .clear
        self.tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: cellId)
        self.tableView.dragInteractionEnabled = true
//        self.tableView.dragDelegate = self
//        self.tableView.dropDelegate = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        self.view = self.tableView
    }
    
    
    func promtTodo(){
        
        let alert = UIAlertController(title: "Add Todo", message: nil , preferredStyle: .alert)
        alert.addTextField {$0.placeholder = "Clean the dishes"}
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            let text  = alert.textFields![0].text!
            let status : Int64 = 0
            DataManager.saveTodo(text: text, status: status, list: self.list)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
        
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
        
        var alert : UIAlertController
        
        #if targetEnvironment(macCatalyst)
        alert  = UIAlertController(title: "Change Color" , message: nil, preferredStyle: .alert)
        #endif
        
        #if !targetEnvironment(macCatalyst)
        alert  = UIAlertController(title: "Change Color" , message: nil, preferredStyle: .actionSheet)
        #endif
        
        SystemColors.allCases.forEach { (color) in
            alert.addAction(UIAlertAction(title: color.rawValue.capitalized, style: .default, handler: { (_) in
                self.view.backgroundColor = color.color
                self.list.color = color.rawValue
                self.navigationController?.navigationBar.barTintColor = color.color
                DataManager.shared.saveContext{}
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}




