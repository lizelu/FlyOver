//
//  BackView.swift
//  FlyOver
//
//  Created by Mr.LuDashi on 2016/12/20.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

class BackView: UIView {
    let codeCount = 50
    var codeViews: Array<PointView> = []
    var beziers: Array<UIBezierPath> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        for i in 0..<codeCount {
            let codeView = PointView(frame: CGRect.zero)
            codeView.tag = i
            weak var weak_self = self
                codeView.setUpdateClosure(closure: { (index) in
                    weak_self?.drawLine(index: index)
                })
            
            self.addSubview(codeView)
            self.codeViews.append(codeView)
            self.beziers.append(UIBezierPath())
        }
    }
    
    func areaPoints(index: Int) -> Array<CGPoint> {
        var points = Array<CGPoint>()
        points.append(self.codeViews[index].center)
        for item in self.codeViews {
            let distance = self.countDistance(point1: self.codeViews[index].center,
                                              point2: item.center)
            
            if distance < 100 {
                points.append(item.center)
            }
        }
        return points
    }
    
    func countDistance(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let x = pow(point1.x - point2.x, 2)
        let y = pow(point1.y - point2.y, 2)
        return CGFloat(sqrt(Double(x + y)))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func drawLine(index: Int) {
        DispatchQueue.global().sync {
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
            DispatchQueue.main.async {
                 self.setNeedsDisplay()
            }
        }
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        for j in 0..<self.beziers.count {
            UIColor.black.setStroke()
            self.beziers[j].lineWidth = 1
            self.beziers[j].stroke()
        }
    }

}
