//
//  NodeGraphView.swift
//  a3
//
//  Created by Vegard Solheim Theriault on 09/10/15.
//  Copyright © 2015 Vegard Solheim Theriault. All rights reserved.
//

import UIKit

class NodeGraphView: UIView {

    private var graph: NodeMap?
    private var path: [Node]?
    private var open: [Node]?
    private var closed: [Node]?
    
    func setData(graph: NodeMap, path: [Node], open: [Node], closed: [Node]) {
        self.graph = graph
        self.path = path
        self.open = open
        self.closed = closed
        
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        if let graph = graph {
            let nodeSize = rectToDrawIn.width / CGFloat(graph.mapWidth)
            
            UIColor.blackColor().setStroke()
            
            // Draw the tiles
            for row in 0..<(graph.mapHeight) {
                for col in 0..<(graph.mapWidth) {
                    guard let currentNode = graph.getNode(Coordinate(x: col, y: row)) else { continue }
                    
                    let nodeRect = CGRect(
                        x: rectToDrawIn.origin.x + (nodeSize * CGFloat(col)),
                        y: rectToDrawIn.origin.y + (nodeSize * CGFloat(row)),
                        width: nodeSize,
                        height: nodeSize)
                    
                    
                    let nodePath = UIBezierPath(rect: nodeRect)
                    colorForNodeCategory(currentNode.nodeCategory).setFill()
                    nodePath.lineWidth = 1.0
                    
                    nodePath.fill()
                    nodePath.stroke()
                }
            }
            
            // Draw the path
            if let path = path {
                let bezierPath = UIBezierPath()
                
                let firstNode = path[0]
                let firstX = rectToDrawIn.origin.x + (CGFloat(firstNode.coordinate.x) * nodeSize) + (nodeSize / 2)
                let firstY = rectToDrawIn.origin.y + (CGFloat(firstNode.coordinate.y) * nodeSize) + (nodeSize / 2)
                bezierPath.moveToPoint(CGPoint(x: firstX, y: firstY))
                
                for i in 1..<(path.count) {
                    let currentNode = path[i]
                    
                    let x = rectToDrawIn.origin.x + (CGFloat(currentNode.coordinate.x) * nodeSize) + (nodeSize / 2)
                    let y = rectToDrawIn.origin.y + (CGFloat(currentNode.coordinate.y) * nodeSize) + (nodeSize / 2)
                    bezierPath.addLineToPoint(CGPoint(x: x, y: y))
                }
                
                bezierPath.lineWidth = nodeSize * 0.3
                bezierPath.stroke()
            }
            
            
            // Draw open nodes
            if let open = open {
                let circleSize = nodeSize / 4
                for i in 0..<(open.count) {
                    let currentNode = open[i]
                    
                    let circleRect = CGRect(
                        x: rectToDrawIn.origin.x + (nodeSize * CGFloat(currentNode.coordinate.x)) + (nodeSize / 2) - (circleSize / 2),
                        y: rectToDrawIn.origin.y + (nodeSize * CGFloat(currentNode.coordinate.y)) + (nodeSize / 2) - (circleSize / 2),
                        width: circleSize,
                        height: circleSize)
                    
                    let bezierPath = UIBezierPath(ovalInRect: circleRect)
                    UIColor.blackColor().setFill()
                    bezierPath.fill()
                }
            }
            
            
            // Draw closed nodes
            if let closed = closed {
                let crossInset = nodeSize * 0.3
                for i in 0..<(closed.count) {
                    let currentNode = closed[i]
                    
                    let top    = rectToDrawIn.origin.y + (nodeSize * CGFloat(currentNode.coordinate.y)) + crossInset
                    let bottom = rectToDrawIn.origin.y + (nodeSize * CGFloat(currentNode.coordinate.y)) + nodeSize - crossInset
                    let left   = rectToDrawIn.origin.x + (nodeSize * CGFloat(currentNode.coordinate.x)) + crossInset
                    let right  = rectToDrawIn.origin.x + (nodeSize * CGFloat(currentNode.coordinate.x)) + nodeSize - crossInset
                    
                    let topLeft = CGPoint(x: left, y: top)
                    let topRight = CGPoint(x: right, y: top)
                    let bottomLeft = CGPoint(x: left, y: bottom)
                    let bottomRight = CGPoint(x: right, y: bottom)
                    
                    let bezierPath = UIBezierPath()
                    bezierPath.moveToPoint(topLeft)
                    bezierPath.addLineToPoint(bottomRight)
                    bezierPath.moveToPoint(topRight)
                    bezierPath.addLineToPoint(bottomLeft)
                    
                    bezierPath.lineWidth = nodeSize * 0.1
                    UIColor.blackColor().setStroke()
                    bezierPath.stroke()
                }
            }
        }
    }
    
    

    
    // -------------------------------
    // MARK: Private Helpers
    // -------------------------------
    
    private var rectToDrawIn: CGRect {
        let mapRatio = CGFloat(graph!.mapWidth) / CGFloat(graph!.mapHeight)
        let viewRatio = bounds.width / bounds.height
        
        if mapRatio < viewRatio {
            // The map is wider than the view
            // The height is equal
            print("Equal heights")
            let mapHeight = bounds.height - 10 // Didn't quite fit
            let mapWidth = mapHeight * mapRatio
            
            return CGRect(
                x: (bounds.width - mapWidth) / 2,
                y: 1,
                width: mapWidth,
                height: mapHeight - 2)
        } else {
            // The map is taller than the view
            // The width is equal
            print("Equal widths")
            let mapWidth = bounds.width
            let mapHeight = mapWidth / mapRatio
            
            return CGRect(
                x: 1,
                y: (bounds.height - mapHeight) / 2,
                width: mapWidth - 2,
                height: mapHeight)
        }
    }
    
    private func colorForNodeCategory(category: NodeCategory) -> UIColor {
        switch category {
        case .Start:
            return UIColor.yellowColor()
        case .End:
            return UIColor.redColor()
        case .Grasslands:
            return UIColor(red: 132.0/255.0, green: 253.0/255.0, blue: 133.0/255.0, alpha: 1.0)
        case .Forests:
            return UIColor(red: 15.0/255.0, green: 126.0/255.0, blue: 18.0/255.0, alpha: 1.0)
        case .Roads:
            return UIColor(red: 190.0/255.0, green: 127.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        case .Mountains:
            return UIColor(red: 166.0/255.0, green: 166.0/255.0, blue: 166.0/255.0, alpha: 1.0)
        case .Water:
            return UIColor(red: 78.0/255.0, green: 84.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        case .Empty:
            return UIColor.whiteColor()
        case .Obstacle:
            return UIColor(white: 128.0/255.0, alpha: 1.0)
        }
    }
}
