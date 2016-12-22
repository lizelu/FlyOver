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
    var x: CGFloat = 1
    var y: CGFloat = 1
    let widthAndHeight: CGFloat = 10
    var updateViewClosure: UpdateViewsClosure! = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.x = randomIncrement()
        self.y = randomIncrement()
        self.layer.cornerRadius = widthAndHeight/2
        self.backgroundColor = UIColor.blue
        self.layer.borderWidth = 0.1
        self.layer.borderColor = UIColor.white.cgColor
        self.frame = CGRect(origin: randomPoint(), size: CGSize(width: widthAndHeight, height: widthAndHeight))
    }
    
    override func layoutSubviews() {
        self.changePoint()
    }
    
    func setUpdateClosure(closure: @escaping UpdateViewsClosure) {
        self.updateViewClosure = closure
    }
    
    func randomPoint() -> CGPoint {
        arc4random_uniform(UInt32(ScreenSize.width))
        return CGPoint(x: Int(arc4random_uniform(UInt32(ScreenSize.width-widthAndHeight))),
                       y: Int(arc4random_uniform(UInt32(ScreenSize.height-widthAndHeight))))
    }
    
    func randomIncrement() -> CGFloat {
        if arc4random() % 2 == 0 {
            return 1
        } else {
            return -1
        }
    }
    
    func changePoint() {
        UIView.animate(withDuration: 0.0001, animations: {
            var currentPoint = self.frame.origin
            
            if currentPoint.x > ScreenSize.width-self.widthAndHeight || currentPoint.x < 0 {
                self.x = -self.x
            }
            
            if currentPoint.y > ScreenSize.height-self.widthAndHeight || currentPoint.y < 0 {
                self.y = -self.y
            }

            currentPoint.x += self.x
            currentPoint.y += self.y
            self.frame.origin = currentPoint
        }, completion: { (bool) in
            self.backgroundColor = randomColor()
            if self.updateViewClosure != nil {
                self.updateViewClosure(self.tag)
            }
            self.changePoint()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
