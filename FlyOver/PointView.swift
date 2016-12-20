//
//  PointView.swift
//  FlyOver
//
//  Created by Mr.LuDashi on 2016/12/16.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

class PointView: UIView {
    let screenSize = UIScreen.main.bounds.size
    var x: CGFloat = 1
    var y: CGFloat = 1
    let widthAndHeight: CGFloat = 5
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.x = randomIncrement()
        self.y = randomIncrement()
        self.layer.cornerRadius = 2.5
        self.backgroundColor = UIColor.blue
        self.frame = CGRect(origin: randomPoint(), size: CGSize(width: widthAndHeight, height: widthAndHeight))
    }
    
    override func layoutSubviews() {
        self.changePoint()
    }
    
    func randomPoint() -> CGPoint {
        arc4random_uniform(UInt32(screenSize.width))
        return CGPoint(x: Int(arc4random_uniform(UInt32(screenSize.width-widthAndHeight))),
                       y: Int(arc4random_uniform(UInt32(screenSize.height-widthAndHeight))))
    }
    
    func randomIncrement() -> CGFloat {
        if arc4random() % 2 == 0 {
            return 1
        } else {
            return -1
        }
    }
    
    func changePoint() {
        UIView.animate(withDuration: 0.005, animations: {
            var currentPoint = self.frame.origin
            
            if currentPoint.x > self.screenSize.width-self.widthAndHeight || currentPoint.x < 0 {
                self.x = -self.x
            }
            
            if currentPoint.y > self.screenSize.height-self.widthAndHeight || currentPoint.y < 0 {
                self.y = -self.y
            }

            currentPoint.x += self.x
            currentPoint.y += self.y
            self.frame.origin = currentPoint

        }, completion: { (bool) in
            self.changePoint()
        })
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
