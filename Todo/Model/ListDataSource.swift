//
//  ListDataSource.swift
//  Todo
//
//  Created by Muhannad Alnemer on 3/4/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import UIKit
import CloudKit

class ListDataSource : UITableViewDiffableDataSource<ListSection, List>{
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ListSection(rawValue: section)?.description
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let sourceIdentifier = itemIdentifier(for: sourceIndexPath) else { return }
        guard sourceIndexPath != destinationIndexPath else { return }
        let destinationIdentifier = itemIdentifier(for: destinationIndexPath)
        
        var snapshot = self.snapshot()

        if let destinationIdentifier = destinationIdentifier {
            if let sourceIndex = snapshot.indexOfItem(sourceIdentifier),
               let destinationIndex = snapshot.indexOfItem(destinationIdentifier) {
                let isAfter = destinationIndex > sourceIndex &&
                    snapshot.sectionIdentifier(containingItem: sourceIdentifier) ==
                    snapshot.sectionIdentifier(containingItem: destinationIdentifier)
                snapshot.deleteItems([sourceIdentifier])
                if isAfter {
                    snapshot.insertItems([sourceIdentifier], afterItem: destinationIdentifier)
                } else {
                    snapshot.insertItems([sourceIdentifier], beforeItem: destinationIdentifier)
                }
            }
        } else {
            let destinationSectionIdentifier = snapshot.sectionIdentifiers[destinationIndexPath.section]
            snapshot.deleteItems([sourceIdentifier])
            snapshot.appendItems([sourceIdentifier], toSection: destinationSectionIdentifier)
        }
        apply(snapshot, animatingDifferences: false)
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            if let identifierToDelete = itemIdentifier(for: indexPath) {
                CKContainer.default().privateCloudDatabase.delete(withRecordID: identifierToDelete.id) { (_, _) in
                    print("Deleted")
                }
               
//                 Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("Lists").document(identifierToDelete.uid!).updateData(["visible":false]) { (error) in
//                    var snapshot = self.snapshot()
//                    snapshot.deleteItems([identifierToDelete])
//                    self.apply(snapshot)
//                }
                
            }
        }
    }
}

