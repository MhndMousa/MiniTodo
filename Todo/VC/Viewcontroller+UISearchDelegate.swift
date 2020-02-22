//
//  Viewcontroller+UISearchDelegate.swift
//  Todo
//
//  Created by Muhannad Alnemer on 2/20/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//
import UIKit
import Foundation

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filteredArray = searchText.isEmpty ? self.todoList.list : self.todoList.list.filter { $0.string.contains(searchText)}
        applySnapshotChanges(filteredArray)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedItemIdentifier = self.datasource.itemIdentifier(for: indexPath) else {print("error");return}
        guard let cell = tableView.cellForRow(at: indexPath) as? TableViewCell else {return}
        
        cell.changeAttributedText(string: selectedItemIdentifier.string, status: selectedItemIdentifier.status.opposite)

        applySnapshotChanges(todoList.list)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
