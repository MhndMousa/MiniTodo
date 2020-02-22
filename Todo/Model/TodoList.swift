//
//  TodoList.swift
//  Todo
//
//  Created by Muhannad Alnemer on 2/20/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import Foundation
import UIKit


struct TodoList : Hashable {
    private(set) var list = [Todo]()
    /// The traditional method for rearranging rows in a table view.
    mutating func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        
        let place = list[sourceIndex]
        list.remove(at: sourceIndex)
        list.insert(place, at: destinationIndex)
    }
    
    /// The method for adding a new item to the table view's data model.
    mutating func addItem(_ place: Todo, at index: Int) {
        list.insert(place, at: index)
    }
    mutating func changeStatus(to status: TodoStatus, index: Int){
        list[index].status = status
    }
    
    
    /**
           A helper function that serves as an interface to the data model,
           called by the implementation of the `tableView(_ canHandle:)` method.
      */
      func canHandle(_ session: UIDropSession) -> Bool {
          return session.canLoadObjects(ofClass: Todo.self)
      }
      
      /**
           A helper function that serves as an interface to the data mode, called
           by the `tableView(_:itemsForBeginning:at:)` method.
      */
        func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
            let placeName = list[indexPath.row]
            let itemProvider = NSItemProvider(object: placeName)
            return [UIDragItem(itemProvider: itemProvider)]
      }
}

