//
//  ListTableViewController.swift
//  Todo
//
//  Created by Muhannad Alnemer on 2/22/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import UIKit
import MobileCoreServices
import CloudKit
import CoreData

class ListTableViewController: UICollectionViewController {
    
    // MARK: Variables
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "yoda"))
    var cellId = "cell"
    let refresher : UIRefreshControl = {
        let r = UIRefreshControl()
        r.tintColor = .tertiaryLabel
        return r
    }()
//    var listModel : ListModel!
    var listModel : ListCollectionModel!
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
//            let sectionLayoutKind = SectionLayoutKind(rawValue: sectionIndex)!
//            let columns = sectionLayoutKind.columnCount
            let columns = 2

            // The `group` auto-calculates the actual item width to make the requested number of `columns` fit,
            // so this `widthDimension` will be ignored.
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom:5, trailing: 5)

            let groupHeight = columns == 1 ?
                NSCollectionLayoutDimension.absolute(44) : NSCollectionLayoutDimension.fractionalWidth(0.2)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            return section
        }
        return layout
    }

    
    // MARK: ViewController life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemGray6
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        listModel = ListCollectionModel(tableView: collectionView, vc: self)
//        refreshControl?.addTarget(self, action: #selector(retrieveData), for: .valueChanged)
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showImage(false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = self.view.backgroundColor
        self.navigationController?.navigationBar.titleTextAttributes      = [.foregroundColor: UIColor.secondaryLabel]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.secondaryLabel]
        self.navigationController?.navigationBar.tintColor = .secondaryLabel
        self.collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showImage(true)
    }


    
    // MARK: Helpers

    fileprivate func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "plus.circle.fill"), style: .done, target: self, action: #selector(addList))
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "خربشة"
        self.view.backgroundColor = .systemGray6
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(imageView)
        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
    
    
    @objc func addList()  {
         let alert = UIAlertController(title: "Add a list", message: nil , preferredStyle: .alert)
         alert.addTextField {$0.placeholder = "Clean the dishes"}
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            let name = alert.textFields![0].text!
            let color = SystemColors.systemRandom().rawValue
            DataManager.saveList(name: name, color: color)
         }))
         alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
         self.present(alert, animated: true, completion: nil)
    }
    @objc public func presentColorChange(_ vc: UIAlertController){
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - TableViewDelegate
// TODO: complete drag and drop

extension ListTableViewController: UICollectionViewDelegateFlowLayout{
//    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let placeName = array[indexPath.row]
//        let itemProvider = NSItemProvider(object: placeName)
//        return [UIDragItem(itemProvider: itemProvider)]
//    }
//
//    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
//           return session.canLoadObjects(ofClass: String.self)
//       }
//
//       /**
//            A drop proposal from a table view includes two items: a drop operation,
//            typically .move or .copy; and an intent, which declares the action the
//            table view will take upon receiving the items. (A drop proposal from a
//            custom view does includes only a drop operation, not an intent.)
//       */
//       func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
//           // The .move operation is available only for dragging within a single app.
//           if tableView.hasActiveDrag {
//               if session.items.count > 1 {
//                   return UITableViewDropProposal(operation: .cancel)
//               } else {
//                   return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
//               }
//           } else {
//               return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
//           }
//       }
//
//       /**
//            This delegate method is the only opportunity for accessing and loading
//            the data representations offered in the drag item. The drop coordinator
//            supports accessing the dropped items, updating the table view, and specifying
//            optional animations. Local drags with one item go through the existing
//            `tableView(_:moveRowAt:to:)` method on the data source.
//       */
//       func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
//           let destinationIndexPath: IndexPath
//
//           if let indexPath = coordinator.destinationIndexPath {
//               destinationIndexPath = indexPath
//           } else {
//               // Get last index path of table view.
//               let section = tableView.numberOfSections - 1
//               let row = tableView.numberOfRows(inSection: section)
//               destinationIndexPath = IndexPath(row: row, section: section)
//           }
//
//
//        coordinator.session.loadObjects(ofClass: List.self){ items in
//               // Consume drag items.
//               let stringItems = items as! [List]
//
//               var indexPaths = [IndexPath]()
//               for (index, item) in stringItems.enumerated() {
//                   let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
//                self.array.insert(item, at: indexPath.row)
//                   indexPaths.append(indexPath)
//               }
//
//               tableView.insertRows(at: indexPaths, with: .automatic)
//           }
//       }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let selectedItemIdentifier = self.datasource.itemIdentifier(for: indexPath) else {print("error");return}
//        guard let cell = tableView.cellForRow(at: indexPath) as? ListTableViewCell else {return}
//        tableView.deselectRow(at: indexPath, animated: true)
//        let root = TodoViewController()
//        root.list = cell.list
//        self.navigationController?.pushViewController(root, animated: true)
//    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ListCollectionViewCell else {return}
        UIView.animate(withDuration: 0.14, delay: 0, options: .curveEaseIn, animations: {
            cell.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
        }) { (_) in
            UIView.animate(withDuration: 0.14, delay: 0, options: .curveEaseIn, animations: {
                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            }){ (_) in
                let root = TodoViewController()
                root.list = cell.list
                self.navigationController?.pushViewController(root, animated: true)
            }
        }
    }
    
}

// MARK: - Profile Image Handlers
extension ListTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }
    
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()

        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()

        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()

        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)

        imageView.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    /// Show or hide the image from NavBar while going to next screen or back to initial screen
    ///
    /// - Parameter show: show or hide the image from NavBar
    private func showImage(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.imageView.alpha = show ? 1.0 : 0.0
        }
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView

        // Your action
        print("Settings")
    }

    
}

extension ListTableViewController: CellDelegate{
    func changeColor(vc: UIAlertController) {
        self.present(vc, animated: true, completion: nil)
    }
}
