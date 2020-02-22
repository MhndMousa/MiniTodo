//
//  ViewController+DargDropDelegate.swift
//  Todo
//
//  Created by Muhannad Alnemer on 2/20/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: UITableViewDropDelegate,UITableViewDragDelegate{
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return array.dragItems(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
           return array.canHandle(session)
       }

       /**
            A drop proposal from a table view includes two items: a drop operation,
            typically .move or .copy; and an intent, which declares the action the
            table view will take upon receiving the items. (A drop proposal from a
            custom view does includes only a drop operation, not an intent.)
       */
       func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
           // The .move operation is available only for dragging within a single app.
           if tableView.hasActiveDrag {
               if session.items.count > 1 {
                   return UITableViewDropProposal(operation: .cancel)
               } else {
                   return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
               }
           } else {
               return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
           }
       }
       
       /**
            This delegate method is the only opportunity for accessing and loading
            the data representations offered in the drag item. The drop coordinator
            supports accessing the dropped items, updating the table view, and specifying
            optional animations. Local drags with one item go through the existing
            `tableView(_:moveRowAt:to:)` method on the data source.
       */
       func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
           let destinationIndexPath: IndexPath
           
           if let indexPath = coordinator.destinationIndexPath {
               destinationIndexPath = indexPath
           } else {
               // Get last index path of table view.
               let section = tableView.numberOfSections - 1
               let row = tableView.numberOfRows(inSection: section)
               destinationIndexPath = IndexPath(row: row, section: section)
           }
        
        
        coordinator.session.loadObjects(ofClass: Todo.self){ items in
               // Consume drag items.
               let stringItems = items as! [Todo]
               
               var indexPaths = [IndexPath]()
               for (index, item) in stringItems.enumerated() {
                   let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                   self.array.addItem(item, at: indexPath.row)
                   indexPaths.append(indexPath)
               }

               tableView.insertRows(at: indexPaths, with: .automatic)
           }
       }
  
}
