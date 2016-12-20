//
//  BackView.swift
//  FlyOver
//
//  Created by Mr.LuDashi on 2016/12/20.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

class BackView: UIView {
    let codeCount = 10
    var codeViews: Array<PointView> = []
    var beziers: Array<UIBezierPath> = []
    var graph: Array<Array<Bool>> = []
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
        }
        self.graph = Array<Array<Bool>>(repeating: Array<Bool>(repeating: false, count: self.codeCount), count: self.codeCount)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.drawLine()
        
    }
    
    func drawLine(index: Int) {
        DispatchQueue.global().sync {
            let bezier: UIBezierPath = self.beziers[index]
            bezier.removeAllPoints()
            self.graph[index] = Array<Bool>(repeating: false, count: self.codeCount)
            for i in 0..<self.graph.count {
                self.graph[i][index] = false
            }
            self.addPoint(bezier: bezier, index: index)
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }
    
    func drawLine() {
        for i in 0..<self.codeViews.count {
            let bezier: UIBezierPath = UIBezierPath()
            bezier.move(to: self.codeViews[i].center)
            self.addPoint(bezier: bezier, index: i)
            self.beziers.append(bezier)
        }
        self.setNeedsDisplay()
    }
    
    func addPoint(bezier: UIBezierPath, index: Int) {
        bezier.move(to: self.codeViews[index].center)
        var preIndex = 0
        for j in 0..<self.codeViews.count {
            if index != j && !self.graph[index][j] {
                bezier.addLine(to: self.codeViews[j].center)
                self.graph[preIndex][j] = true
                self.graph[j][preIndex] = true
                preIndex = j
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        for bezier in self.beziers {
            UIColor.black.setStroke()
            bezier.lineWidth = 1
            bezier.stroke()
        }
    }

}
