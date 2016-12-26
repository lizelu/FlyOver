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
    
    let widthAndHeight: CGFloat = 6
    
    var x: CGFloat = 1
    var y: CGFloat = 1
    var updateViewClosure: UpdateViewsClosure! = nil
    var duration: Double = 0.0005
    var source: DispatchSourceTimer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.config()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addDispatchSourceTimer()
    }
    
    /// 配置当前View的默认属性
    func config() {
        self.x = randomIncrement()
        self.y = randomIncrement()
        self.layer.cornerRadius = widthAndHeight / 2
        self.backgroundColor = UIColor.black
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.frame = CGRect(origin: randomPoint(), size: CGSize(width: widthAndHeight, height: widthAndHeight))
        self.duration = self.randomDuraion()
    }

    /// 设置更新回调
    ///
    /// - Parameter closure: <#closure description#>
    func setUpdateClosure(closure: @escaping UpdateViewsClosure) {
        self.updateViewClosure = closure
    }
    
    /// 随机生成坐标点
    ///
    /// - Returns: <#return value description#>
    func randomPoint() -> CGPoint {
        arc4random_uniform(UInt32(ScreenSize.width))
        return CGPoint(x: Int(arc4random_uniform(UInt32(ScreenSize.width-widthAndHeight))),
                       y: Int(arc4random_uniform(UInt32(ScreenSize.height-widthAndHeight))))
    }
    
    /// 随机生成x或者y的增量
    ///
    /// - Returns: <#return value description#>
    func randomIncrement() -> CGFloat {
        if arc4random() % 2 == 0 {
            return 1
        } else {
            return -1
        }
    }
    
    
    /// 添加Dispatch Source Timer
    func addDispatchSourceTimer() {
        if source == nil {
             source = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: DispatchQueue.main) as? DispatchSource
        }
       
        let timer = UInt64(duration) * NSEC_PER_SEC
        source.scheduleRepeating(deadline: DispatchTime.init(uptimeNanoseconds: UInt64(timer)), interval: DispatchTimeInterval.seconds(Int(duration)), leeway: DispatchTimeInterval.seconds(0))
        source.setEventHandler {
            self.changePoint()
        }
        source.resume()
    }
    
    /// 改变当前View的坐标
    func changePoint() {
        self.backgroundColor = RandomColor.shareInstance()
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
       
        if self.updateViewClosure != nil {
            self.updateViewClosure(self.tag)
        }
    }
    
    /// 随机生成动画时间
    ///
    /// - Returns: <#return value description#>
    func randomDuraion() -> Double {
        return Double(arc4random_uniform(100))/100
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class RandomColor {
    var randomColors = Array<UIColor>()
    var colorCount = 20
    var randomColor: UIColor {
        get {
            let index = Int(arc4random_uniform(1000)) % colorCount
            return randomColors[index]
        }
    }
    private static var color: RandomColor!
    static func shareInstance() -> UIColor {
        if color == nil {
            color = RandomColor()
        }
        return color.randomColor
    }
    
    private init() {
        if randomColors.isEmpty {
            self.addColors()
        }
    }
    
    func addColors() {
        for _ in 0..<colorCount {
            let weight = CGFloat(arc4random_uniform(1000))/1000
            let color = UIColor(hue: weight, saturation: 1, brightness: 1, alpha: 1)
            self.randomColors.append(color)
        }
    }
}
