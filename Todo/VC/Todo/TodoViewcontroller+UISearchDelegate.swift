//
//  Viewcontroller+UISearchDelegate.swift
//  Todo
//
//  Created by Muhannad Alnemer on 2/20/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//
import UIKit
import Foundation

extension TodoViewController: UISearchBarDelegate,UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let index = searchController.searchBar.selectedScopeButtonIndex // [Both, Unfinished, Finished]
        
        guard let list = TodoModel.fetchedResultsController.fetchedObjects else {return}
         
        let filteredArray = list.filter {
            ($0.text?.lowercased().contains(searchBar.text!.lowercased()))! &&
            ($0.status+1 == index || index == 0)    //  $0.status[0] = Both  -- $0.status[1] = Unfinished -- $0.status[2] = Finsihed
        }
        self.todoModel.applySnapshotChanges(filteredArray)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        guard let list = self.list.todoList else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.todoModel.applySnapshotChanges()
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let list = TodoModel.fetchedResultsController.fetchedObjects else {return}
        let filteredArray = searchText.isEmpty ? list  : list.filter { $0.text!.contains(searchText)}
        self.todoModel.applySnapshotChanges(filteredArray)
    }
    
}
