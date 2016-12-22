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
class PointView: UIView {
    
    let widthAndHeight: CGFloat = 40
    var updateViewClosure: UpdateViewsClosure! = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = self.widthAndHeight/2
        self.backgroundColor = UIColor.blue
        self.frame = CGRect(origin: randomPoint(), size: CGSize(width: widthAndHeight, height: widthAndHeight))
    }

    func setUpdateClosure(closure: @escaping UpdateViewsClosure) {
        self.updateViewClosure = closure
    }
    
    func randomPoint() -> CGPoint {
        arc4random_uniform(UInt32(ScreenSize.width))
        return CGPoint(x: Int(arc4random_uniform(UInt32(ScreenSize.width-widthAndHeight))),
                       y: Int(arc4random_uniform(UInt32(ScreenSize.height-widthAndHeight))))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touche: UITouch in touches {
            print(touche.location(in: superview))
            self.frame.origin = touche.location(in: superview)
            if (self.updateViewClosure != nil) {
                self.updateViewClosure(self.tag)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
