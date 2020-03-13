//
//  ListTableViewCell.swift
//  Todo
//
//  Created by Muhannad Alnemer on 3/12/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    var list: List!
    init(name: String, textColor: UIColor, backgroundColor: UIColor,list: List){
        super.init(style: .default, reuseIdentifier: "cell")
        self.textLabel?.text = name
        self.textLabel?.textColor = textColor
        self.backgroundColor = backgroundColor
        self.list = list
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
