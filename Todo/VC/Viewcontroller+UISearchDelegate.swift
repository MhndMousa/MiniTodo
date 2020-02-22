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
        let filteredArray = searchText.isEmpty ? self.array.placeNames : self.array.placeNames.filter { $0.string.contains(searchText)}
        
        var snapshot = TodoSnapshot()
        snapshot.appendSections([.unfinished])
        snapshot.appendItems(filteredArray)
        datasource.apply(snapshot)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedItemIdentifier = self.datasource.itemIdentifier(for: indexPath) as? Todo else {print("error");return}
        guard let cell = tableView.cellForRow(at: indexPath) as? TableViewCell else {return}
        
        cell.changeAttributedText(string: selectedItemIdentifier.string, status: selectedItemIdentifier.status.opposite)
//        
//        switch selectedItemIdentifier.status {
//        case .finished:
//            let attributes = [NSAttributedString.Key.foregroundColor:   UIColor.label]
//            let text = NSMutableAttributedString(string: selectedItemIdentifier.string, attributes: attributes)
//            text.removeAttribute(NSAttributedString.Key.strikethroughStyle,range: NSMakeRange(0, selectedItemIdentifier.string.count))
//            selectedItemIdentifier.status = .unfinished
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//            tableView.cellForRow(at: indexPath)?.textLabel?.text = text.string
//            
//        case .unfinished:
//            let attributes = [NSAttributedString.Key.strokeColor :      UIColor.darkGray,
//                              NSAttributedString.Key.foregroundColor:   UIColor.lightGray]
//            let text = NSMutableAttributedString(string: selectedItemIdentifier.string, attributes: attributes)
//            text.addAttribute(NSAttributedString.Key.strikethroughStyle,value: 2,range: NSMakeRange(0, selectedItemIdentifier.string.count))
//            selectedItemIdentifier.status = .finished
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//            tableView.cellForRow(at: indexPath)?.textLabel?.text = text.string
//        }

        let finished =      self.array.placeNames.filter({$0.status == .finished})
        let unfinished =    self.array.placeNames.filter({$0.status == .unfinished})

        var snapshot = TodoSnapshot()
        snapshot.appendSections(TodoStatus.allCases)
        snapshot.appendItems(unfinished,toSection: .unfinished)
        snapshot.appendItems(finished,  toSection: .finished)
        datasource.apply(snapshot, animatingDifferences: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
