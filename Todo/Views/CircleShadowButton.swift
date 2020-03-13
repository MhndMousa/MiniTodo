//
//  CircleShadowButton.swift
//  Todo
//
//  Created by Muhannad Alnemer on 2/23/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import UIKit

protocol TickDelegate {
    func buttonTicked()
}
class CircleShadowButton: UIButton {
    
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    var delegate : TickDelegate!
    
    
//     Only override draw() if you perform custom drawing.
//     An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.cornerRadius = 0.5 * bounds.size.width // add the round corners in proportion to the button size
        clipsToBounds = true
        
        blur.frame = bounds
        blur.isUserInteractionEnabled = false //This allows touches to forward to the button.
        blur.clipsToBounds = true
        insertSubview(blur, at: 0)
        addTarget(self, action: #selector(clicked), for: .touchUpInside)
    }

    @objc func clicked(){
        delegate.buttonTicked()
        isClicked.toggle()
    }
    var isClicked: Bool = false{
        didSet{
            self.isClicked ? setImage(UIImage(systemName: "checkmark.circle.fill")!, for: .normal) : setImage(nil, for: .normal)
        }
    }
    
}
