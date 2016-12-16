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
    let widthAndHeight: CGFloat = 50
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blue
        self.frame = CGRect(origin: CGPoint(x: 200, y: 200), size: CGSize(width: widthAndHeight, height: widthAndHeight))
    }
    
    func changePoint() {
        UIView.animate(withDuration: 0.000001, animations: {
            var currentPoint = self.frame.origin
            
            if currentPoint.x >= self.screenSize.width-self.widthAndHeight || currentPoint.x <= 0 {
                self.x = -self.x
            }
            
            if currentPoint.y >= self.screenSize.height-self.widthAndHeight || currentPoint.y <= 0 {
                self.y = -self.y
            }
            
            
            
            currentPoint.x += self.x
            currentPoint.y += self.y
            self.frame.origin = currentPoint
            self.layoutIfNeeded()

        }, completion: { (bool) in
            self.changePoint()
        })
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
