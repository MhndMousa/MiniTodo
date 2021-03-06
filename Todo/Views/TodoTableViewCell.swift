//
//  TableViewCell.swift
//  Todo
//
//  Created by Muhannad Alnemer on 2/20/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell,TickDelegate {
    func buttonTicked() {
        if let superview = self.superview as? UITableView{
//            changeAttributedText(string: todo.text!, status: TodoStatus(rawValue: !)

            todo.status = (todo.status + 1) % 2
            superview.reloadData()
        }
    }
    

    var todo : Todo!{
        didSet{
            print(self.todo.text, " Was added")
            backgroundColor = .clear
            label.attributedText = makeAttributedText(string: todo.text!, status: TodoStatus(rawValue: todo!.status)!)
            checkBox.isClicked = self.todo.status == 1
            
        }
    }
    var checkBox = CircleShadowButton()
    let label = UILabel()
    var delegate: TickDelegate!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(checkBox)
        contentView.addSubview(label)
        
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25).isActive = true
//        label.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        checkBox.delegate = self
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.trailingAnchor.constraint(equalTo: label.leadingAnchor,constant: -25).isActive = true
        checkBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 25).isActive = true
        checkBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 20).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant:  20).isActive = true
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func makeAttributedText(string:String, status: TodoStatus) -> NSAttributedString{
        switch status{
            
        case .finished:
           let attributes = [NSAttributedString.Key.strokeColor :      UIColor.darkGray,
                             NSAttributedString.Key.foregroundColor:   UIColor.systemGray2,
                             NSAttributedString.Key.font:              UIFont.preferredFont(forTextStyle: .caption1)]
           let text = NSMutableAttributedString(string: string, attributes: attributes)
           text.addAttribute(NSAttributedString.Key.strikethroughStyle,value: 2, range:NSMakeRange(0, string.count))
           return text
        case .unfinished:
            let attributes = [NSAttributedString.Key.foregroundColor:   UIColor.white,
                              NSAttributedString.Key.font:              UIFont.preferredFont(forTextStyle: .caption1)]
            let text = NSMutableAttributedString(string: string, attributes: attributes)
            text.removeAttribute(NSAttributedString.Key.strikethroughStyle,range: NSMakeRange(0, string.count))
            return text
        }
    }
    func changeAttributedText(string:String, status: TodoStatus){
        label.attributedText = makeAttributedText(string: string, status: status)
        todo.status = status.rawValue
        DataManager.shared.saveContext {}
    }
    func changeAccessoryTypeIfNeeded() {
        accessoryType = todo.status == 1 ? .checkmark : .none
    }
    


}
