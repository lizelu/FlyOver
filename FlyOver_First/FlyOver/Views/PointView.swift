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
        self.configCurrentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 配置当前View的配置项
    func configCurrentView() {
        self.layer.cornerRadius = self.widthAndHeight/2
        self.layer.borderWidth = 0.1
        self.layer.borderColor = UIColor.black.cgColor
        self.backgroundColor = randomColor()
        self.frame = CGRect(origin: randomPoint(),
                            size: CGSize(width: widthAndHeight, height: widthAndHeight))
    }

    /// 设置更新UI回调
    ///
    /// - Parameter closure:
    func setUpdateClosure(closure: @escaping UpdateViewsClosure) {
        self.updateViewClosure = closure
    }
    
    /// 随机生成坐标点
    ///
    /// - Returns: 返回随机生成的坐标点
    func randomPoint() -> CGPoint {
        return CGPoint(x: Int(arc4random_uniform(UInt32(ScreenSize.width-widthAndHeight))),
                       y: Int(arc4random_uniform(UInt32(ScreenSize.height-widthAndHeight))))
    }
    
    /// 触摸移动事件
    ///
    /// - Parameters:
    ///   - touches:
    ///   - event: 
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touche: UITouch in touches {
            self.center = touche.location(in: superview)
            
            if (self.updateViewClosure != nil) {
                self.backgroundColor = randomColor()
                self.updateViewClosure(self.tag)
            }
        }
    }
}
