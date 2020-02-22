//
//  Viewcontroller+UISearchDelegate.swift
//  Todo
//
//  Created by Muhannad Alnemer on 2/20/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//
import UIKit
import Foundation

extension ViewController: UISearchBarDelegate,UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let filteredArray = searchBar.text!.isEmpty ? self.todoList.list : self.todoList.list.filter { $0.string.contains(searchBar.text!)}
        applySnapshotChanges(filteredArray)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filteredArray = searchText.isEmpty ? self.todoList.list : self.todoList.list.filter { $0.string.contains(searchText)}
        applySnapshotChanges(filteredArray)
    }
    
}
