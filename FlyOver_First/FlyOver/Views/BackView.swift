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
    var graph: Array<Array<Bool>>!
    var beziers: Array<UIBezierPath> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        for i in 0..<codeCount {
            let codeView = PointView(frame: CGRect.zero)
            codeView.tag = i
            weak var weak_self = self
            codeView.setUpdateClosure(closure: { (index) in
               weak_self?.drawLine()
            })
            
            self.addSubview(codeView)
            self.codeViews.append(codeView)
            self.beziers.append(UIBezierPath())
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.drawLine()
        
    }
    
    func drawLine() {
        self.initGraph()
        for i in 0..<self.codeViews.count {
            self.beziers[i].removeAllPoints()
            self.addPoint(index: i)
        }
        self.setNeedsDisplay()
    }
    
    func initGraph() {
        if self.graph == nil {
            self.graph = Array<Array<Bool>>(repeating: Array<Bool>(repeating: false, count: self.codeCount), count: self.codeCount)
        } else {
            for i in 0..<self.graph.count {
                for j in 0..<self.graph.count {
                    self.graph[i][j] = false
                    self.graph[j][i] = false
                }
            }
        }
    }
    
    func addPoint(index: Int) {
        for j in 0..<self.codeViews.count {
            if index != j && !self.graph[index][j] {
                self.beziers[index].move(to: self.codeViews[index].center)
                self.beziers[index].addLine(to: self.codeViews[j].center)
                self.graph[index][j] = true
                self.graph[j][index] = true
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
            randomColor().setStroke()
            self.beziers[j].lineWidth = 1
            self.beziers[j].stroke()
        }
    }

}
