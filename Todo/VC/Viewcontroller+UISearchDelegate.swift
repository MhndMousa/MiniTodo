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
        let index = searchController.searchBar.selectedScopeButtonIndex
        
        guard let list = self.list.todoList else {return}
        let filteredArray = list.filter {
            $0.text.lowercased().contains(searchBar.text!.lowercased()) &&
            ($0.status.rawValue == index || index == 2)
            
        }
        applySnapshotChanges(filteredArray)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let list = self.list.todoList else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.applySnapshotChanges(list)
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let list = self.list.todoList else {return}
        let filteredArray = searchText.isEmpty ? list : list.filter { $0.text.contains(searchText)}
        applySnapshotChanges(filteredArray)
    }
    
}
