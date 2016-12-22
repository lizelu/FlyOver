//
//  BackView.swift
//  FlyOver
//
//  Created by Mr.LuDashi on 2016/12/20.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

class BackView: UIView {
    let codeCount = 1
    let range: CGFloat = 80
    var codeViews: Array<PointView> = []
    var beziers: Array<UIBezierPath> = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.addSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 添加点
    func addSubViews() {
        for i in 0..<codeCount {
            self.addCodeView(tag: i, center: nil)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.codeViews.count < 80 {
            for touche: UITouch in touches {
                let center = touche.location(in: superview)
                self.addCodeView(tag: self.codeViews.count, center: center)
            }
        }
    }

    /// 添加节点
    ///
    /// - Parameters:
    ///   - tag: 添加节点的Tag
    ///   - center: 添加节点的center，如果为nil的话，则随机生成
    func addCodeView(tag: Int, center: CGPoint?) {
        self.beziers.append(UIBezierPath())
        let codeView = PointView(frame: CGRect.zero)
        codeView.tag = tag
        if let centerPoint = center {
            codeView.center = centerPoint
        }
        weak var weak_self = self
        codeView.setUpdateClosure(closure: { (index) in
            weak_self?.drawLine(index: index)
        })
        
        self.addSubview(codeView)
        self.codeViews.append(codeView)
    }
    
    /// 画线
    ///
    /// - Parameter index: 当前划线点的索引
    func drawLine(index: Int) {
        let points: Array<CGPoint> = self.areaPoints(index: index)
        var graph: Array<Array<Bool>>! = Array<Array<Bool>>(repeating: Array<Bool>(repeating: false, count: points.count), count: points.count)
        
        let bezier = self.beziers[index]
        bezier.removeAllPoints()
        for i in 0..<points.count {
            for j in 0..<points.count {
                if i != j && !graph[i][j] {
                    bezier.move(to: points[i])
                    bezier.addLine(to: points[j])
                    graph[i][j] = true
                    graph[j][i] = true
                }
            }
        }
        self.setNeedsDisplay()
    }
    
    /// 计算在改点区域内的可连线的点
    ///
    /// - Parameter index: 当前移动的点
    /// - Returns: 返回在规定范围内的点数组
    func areaPoints(index: Int) -> Array<CGPoint> {
        var points = Array<CGPoint>()
        points.append(self.codeViews[index].center)
        for item in self.codeViews {
            let distance = self.countDistance(point1: self.codeViews[index].center,
                                              point2: item.center)
            if distance < self.range {
                points.append(item.center)
            }
        }
        return points
    }
    
    /// 计算两点之间的距离
    ///
    /// - Parameters:
    ///   - point1: 点1
    ///   - point2: 点2
    /// - Returns: 返回两点之间的距离
    func countDistance(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let x = pow(point1.x - point2.x, 2)
        let y = pow(point1.y - point2.y, 2)
        return CGFloat(sqrt(Double(x + y)))
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        for j in 0..<self.beziers.count {
            let weight = CGFloat(arc4random_uniform(1000))/1000
            let color = UIColor(hue: weight, saturation: 1, brightness: 1, alpha: 1)
            color.setStroke()
            self.beziers[j].lineWidth = 0.3
            self.beziers[j].stroke()
        }
    }
}
