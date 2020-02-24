//
//  ListTableViewController.swift
//  Todo
//
//  Created by Muhannad Alnemer on 2/22/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import UIKit
import MobileCoreServices

class ListTableViewCell: UITableViewCell {
    
}

/// WARNING: Change these constants according to your project's design
struct Const {
    /// Image height/width for Large NavBar state
    static let ImageSizeForLargeState: CGFloat = 40
    /// Margin from right anchor of safe area to right anchor of Image
    static let ImageRightMargin: CGFloat = 16
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    static let ImageBottomMarginForLargeState: CGFloat = 12
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
    static let ImageBottomMarginForSmallState: CGFloat = 6
    /// Image height/width for Small NavBar state
    static let ImageSizeForSmallState: CGFloat = 32
    /// Height of NavBar for Small state. Usually it's just 44
    static let NavBarHeightSmallState: CGFloat = 44
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
    static let NavBarHeightLargeState: CGFloat = 96.5
}

class ListTableViewController: UITableViewController {
    
    
    
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
    
    
    
    typealias ListSnapShot = NSDiffableDataSourceSnapshot<ListSection,List>
    var datasource : ListDataSource!
    var array = [List]()
    var cellId = "cell"
    
    @objc func addList()  {
           
         // Note to self not to forget how DispatchGroup works
         // Number of entries in the stack determain how long the dispatch will hold
         
         // Using Dispatch Group to wait for user input then append it to the list
         let disptach = DispatchGroup()
         disptach.enter()    // Increments the counter
         
         let todo = List()
         let alert = UIAlertController(title: "Add Todo", message: nil , preferredStyle: .alert)
         alert.addTextField {$0.placeholder = "Clean the dishes"}
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            todo.name = alert.textFields![0].text!
            todo.color = Color(color: SystemColors.random())
            disptach.leave() // Leave for every entry
         }))
         alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
             
         self.present(alert, animated: true, completion: nil)

         // Will trigger once number of .enter() = number of .leave()
         disptach.notify(queue: .main) {
            self.array.append(todo)
            self.applySnapshotChanges(self.array)
         }
    }
    fileprivate func applySnapshotChanges(_ array: [List]) {
        var snapshot = ListSnapShot()
        snapshot.appendSections(ListSection.allCases)
        snapshot.appendItems(array,toSection: .main)
        //       snapshot.appendItems(finished,  toSection: .finished)
        datasource.apply(snapshot, animatingDifferences: true)
    }
    

    let imageView = UIImageView(image: #imageLiteral(resourceName: "yoda"))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.frame, style: .insetGrouped)
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: cellId)
        self.navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "plus.circle.fill"), style: .done, target: self, action: #selector(addList))

        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "خربشة"
        self.view.backgroundColor = .systemGray6
//        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
    
        
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
        
        for _ in 0...3{
            array.append(List(name: "adf", color: Color(color: SystemColors.random())))
        }
        
        
        
        datasource = ListDataSource(tableView: self.tableView, cellProvider: { (tableView, indexPath, list) -> ListTableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! ListTableViewCell
            cell.textLabel?.text = String(self.array[indexPath.row].name)
            cell.textLabel?.textColor = .systemGray6
            cell.backgroundColor = self.array[indexPath.row].color.color
            return cell
        })
        
        applySnapshotChanges(array)
        
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showImage(false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.barTintColor = self.view.backgroundColor
        showImage(true)
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
extension ListTableViewController: UITableViewDropDelegate,UITableViewDragDelegate{
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let placeName = array[indexPath.row]
        let itemProvider = NSItemProvider(object: placeName)
        return [UIDragItem(itemProvider: itemProvider)]
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
           return session.canLoadObjects(ofClass: String.self)
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
        
        
        coordinator.session.loadObjects(ofClass: List.self){ items in
               // Consume drag items.
               let stringItems = items as! [List]
               
               var indexPaths = [IndexPath]()
               for (index, item) in stringItems.enumerated() {
                   let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                self.array.insert(item, at: indexPath.row)
                   indexPaths.append(indexPath)
               }

               tableView.insertRows(at: indexPaths, with: .automatic)
           }
       }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedItemIdentifier = self.datasource.itemIdentifier(for: indexPath) else {print("error");return}
        guard let cell = tableView.cellForRow(at: indexPath) as? ListTableViewCell else {return}
        tableView.deselectRow(at: indexPath, animated: true)
        
        let root = ViewController()
        root.view.backgroundColor = cell.backgroundColor
        root.title = cell.textLabel?.text
        root.previousColor = self.view.backgroundColor
        
        
        self.navigationController?.pushViewController(root, animated: true)
    }
    
}

enum ListSection : Int,CaseIterable {
    case main
    var description: String{
        return "main"
    }
}

//extension NSString :Codable{}

class Color:Codable{

    private var _green: CGFloat = 0.0
    private var _blue:  CGFloat = 0.0
    private var _red:   CGFloat = 0.0
    private var alpha:  CGFloat = 0.0
    

    init(color:UIColor) {
        color.getRed(&_red, green: &_green, blue: &_blue, alpha: &alpha)
    }

    var color:UIColor{
        get{
            return UIColor(red: _red, green: _green, blue: _blue, alpha: alpha)
        }
        set{
            newValue.getRed(&_red, green:&_green, blue: &_blue, alpha:&alpha)
        }
    }

    var cgColor:CGColor{
        get{
            return color.cgColor
        }
        set{
            UIColor(cgColor: newValue).getRed(&_red, green:&_green, blue: &_blue, alpha:&alpha)
        }
    }
}

extension Color{
    static func random() -> UIColor{
        return UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1)
    }
}
class List: NSObject,Codable, NSItemProviderReading, NSItemProviderWriting {
    var name: String!
    var color : Color!
    override init() {
        self.name = ""
        self.color = Color(color: UIColor.white)
    }
    init(name: String, color: Color){
        self.name = name
        self.color = color
    }
      static var writableTypeIdentifiersForItemProvider: [String]{
          return [(kUTTypeData) as String]
      }
      func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
          
          
          let progress = Progress(totalUnitCount: 100)
          // 5
          
          do {
              let encoder = JSONEncoder()
              encoder.outputFormatting = .prettyPrinted
              let data = try encoder.encode(self)
              let json = String(data: data, encoding: String.Encoding.utf8)
              progress.completedUnitCount = 100
              completionHandler(data, nil)
          } catch {
       
              completionHandler(nil, error)
          }
          
          return progress
      }

      // 1
      static var readableTypeIdentifiersForItemProvider: [String] {
              return [(kUTTypeData) as String]
          }
      // 2
          static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
              let decoder = JSONDecoder()
              do {
                  let myJSON = try decoder.decode(Self.self, from: data)
                  return myJSON
              } catch {
                  fatalError("Err")
              }
              
          }
      
      
    
    
}

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
                var snapshot = self.snapshot()
                snapshot.deleteItems([identifierToDelete])
                apply(snapshot)
            }
        }
    }
}

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(systemName: "xmark")! as UIImage
    let uncheckedImage = UIImage(systemName: "doc")! as UIImage

    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }

    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }

    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
