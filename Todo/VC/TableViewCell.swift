//
//  TableViewCell.swift
//  Todo
//
//  Created by Muhannad Alnemer on 2/20/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    var todo : Todo!{
        didSet{
            print(self.todo.string, " Was added")
//            changeAccessoryTypeIfNeeded()
            textLabel?.textAlignment = .center
            textLabel?.attributedText = makeAttributedText(string: todo.string, status: todo.status)
            
        }
    }


    func makeAttributedText(string:String, status: TodoStatus) -> NSAttributedString{
        switch status{
            
        case .finished:
           let attributes = [NSAttributedString.Key.strokeColor :      UIColor.darkGray,
                             NSAttributedString.Key.foregroundColor:   UIColor.lightGray]
           let text = NSMutableAttributedString(string: string, attributes: attributes)
           text.addAttribute(NSAttributedString.Key.strikethroughStyle,value: 2, range:NSMakeRange(0, string.count))
           return text
        case .unfinished:
            let attributes = [NSAttributedString.Key.foregroundColor:   UIColor.label]
            let text = NSMutableAttributedString(string: string, attributes: attributes)
            text.removeAttribute(NSAttributedString.Key.strikethroughStyle,range: NSMakeRange(0, string.count))
            return text
        }
    }
    func changeAttributedText(string:String, status: TodoStatus){
        textLabel?.attributedText = makeAttributedText(string: string, status: status)
        todo.status = status
//        changeAccessoryTypeIfNeeded()
    }
    func changeAccessoryTypeIfNeeded() {
        accessoryType = todo.status == .finished ? .checkmark : .none
    }
    


}
