//
//  CheckBox.swift
//  Todo
//
//  Created by Muhannad Alnemer on 3/4/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import UIKit
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
