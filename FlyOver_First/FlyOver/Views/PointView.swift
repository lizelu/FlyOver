//
//  PointView.swift
//  FlyOver
//
//  Created by Mr.LuDashi on 2016/12/16.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit
let ScreenSize = UIScreen.main.bounds.size
let ScreenBounds = UIScreen.main.bounds
typealias UpdateViewsClosure = (Int) -> Void

func randomColor() -> UIColor {
    let weight = CGFloat(arc4random_uniform(1000))/1000
    return UIColor(hue: weight, saturation: 1, brightness: 1, alpha: 1)
}

class PointView: UIView {
    let widthAndHeight: CGFloat = 40
    var updateViewClosure: UpdateViewsClosure! = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = self.widthAndHeight/2
        self.layer.borderWidth = 0.1
        self.layer.borderColor = UIColor.black.cgColor
        self.backgroundColor = randomColor()
        self.frame = CGRect(origin: randomPoint(), size: CGSize(width: widthAndHeight, height: widthAndHeight))
    }

    func setUpdateClosure(closure: @escaping UpdateViewsClosure) {
        self.updateViewClosure = closure
    }
    
    func randomPoint() -> CGPoint {
        return CGPoint(x: Int(arc4random_uniform(UInt32(ScreenSize.width-widthAndHeight))),
                       y: Int(arc4random_uniform(UInt32(ScreenSize.height-widthAndHeight))))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touche: UITouch in touches {
            self.frame.origin = touche.location(in: superview)
            if (self.updateViewClosure != nil) {
                self.backgroundColor = randomColor()
                self.updateViewClosure(self.tag)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
