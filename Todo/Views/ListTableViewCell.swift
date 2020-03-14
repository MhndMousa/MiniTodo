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

protocol CellDelegate {
    func changeColor(vc: UIAlertController)
}
class ListCollectionViewCell: UICollectionViewCell {
    var delegate: CellDelegate?
    let elipses = UIButton()
    
    
    var textLabel: UILabel = {
       let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 22,weight: .semibold)
        l.numberOfLines = 0
        return l
    }()
    
    var list: List!{
        didSet{
            self.textLabel.text = list.name
            self.textLabel.textColor = .systemGray6
            self.backgroundColor = list.uiColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.systemFill.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 1
        layer.shadowRadius = 10

        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant:10).isActive = true
        
        // TODO: look for a way to have this work
        addSubview(elipses)
        elipses.translatesAutoresizingMaskIntoConstraints = false
        elipses.bottomAnchor.constraint(equalTo:bottomAnchor, constant: -10).isActive = true
        elipses.rightAnchor.constraint(equalTo: rightAnchor,  constant: -10).isActive = true
        elipses.widthAnchor.constraint(equalToConstant:  23).isActive = true
        elipses.heightAnchor.constraint(equalToConstant: 23).isActive = true
        elipses.setBackgroundImage(UIImage(systemName: "ellipsis.circle.fill"), for: .normal)
        elipses.addTarget(self, action: #selector(editList), for: .touchUpInside)
        elipses.tintColor = .systemGray6
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if #available(iOS 13.0, *) {
                let hover = UIHoverGestureRecognizer(target: self, action: #selector(self.hovering(_:)))
                self.addGestureRecognizer(hover)
            }
        }
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(iOS 13.0, *)
    @objc func hovering(_ recognizer: UIHoverGestureRecognizer) {
        // 4. upon hover we change color.
        switch recognizer.state {
        case .began:
            self.superview?.bringSubviewToFront(self)
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(scaleX: 1.04, y: 1.04)
            }
        case .ended:
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        default:
            backgroundColor = list.uiColor
        }
    }
    @objc
    func editList(){
        var alert : UIAlertController
        #if targetEnvironment(macCatalyst)
        alert  = UIAlertController(title: "Edit list" , message: nil, preferredStyle: .alert)
        #endif
        
        #if !targetEnvironment(macCatalyst)
        alert  = UIAlertController(title: "Change Color" , message: nil, preferredStyle: .actionSheet)
        #endif
        alert.addAction(UIAlertAction(title: "Delete List", style: .destructive, handler: { (_) in
            DataManager.managedContext.delete(self.list)
            DataManager.shared.saveContext{}
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        delegate?.changeColor(vc: alert)
    }
}

extension List{
    var uiColor : UIColor{
        guard self.color != nil else{return .white}
        return SystemColors(rawValue: self.color!)!.color
    }
}
