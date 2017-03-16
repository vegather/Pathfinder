//
//  Pathfinder.swift
//  A Star Pathfinding
//
//  Created by Vegard Solheim Theriault on 08/10/15.
//  Copyright © 2015 Vegard Solheim Theriault. All rights reserved.
//

import Foundation

enum Algorithm: CustomStringConvertible {
    case aStar
    case bfs
    case dijkstra
    
    var description: String {
        switch self {
        case .aStar:
            return "A*"
        case .bfs:
            return "BFS"
        case .dijkstra:
            return "Dijkstra's"
        }
    }
}

struct Pathfinder {
    let map: NodeMap
    var open = [Node]()     // OPEN ← ∅
    var closed = [Node]()   // CLOSED ← ∅;
    let algorithm: Algorithm
    
    init(map: NodeMap, algorithm: Algorithm) {
        self.map = map
        self.algorithm = algorithm
    }
    
    mutating func aStar() -> (path: [Node], open: [Node], closed: [Node])? {
        
        defer { reset() }
        
        // Initial setup
        
        // Generate the initial node, n0, for the start state.
        let start = map.startNode
        
        // g(n0) ← 0
        start.g = 0
        
        // Calculate h(n0)
        start.h = calculateH(start)
        
        // f(n0) ← g(n0) + h(n0) happens implicitly
        
        // Push n0 onto OPEN
        open.append(start)
        
        // Agenda loop
        while true { // Will finish when we have either found the endNode, or the open list is empty
            
            // If OPEN = ∅ return FAIL
            // X ← pop(OPEN)
            guard let currentNode = popOpen() else {
                // The open list is empty, and we've failed to find a solution
                print("Failed to produce a path for map: \n\(map)")
                return nil
            }
            
            // push(X,CLOSED)
            closed.append(currentNode)
//            explored.append(currentNode)
            
            // If X is a solution, return (X, SUCCEED)
            if currentNode == map.endNode {
                // Succsessfully found the end node
                let path = getPathFromStartTo(currentNode)
//                let exploredNodesWithoutPath = getExploredNodesWithoutPath(path, allExplored: explored)
                
                return (path, open, getClosedNodesWithoutPath(path, allClosed: closed))
            }
            
            // SUCC ← generate-all-successors(X)
            let successors = getSuccessorNodes(currentNode)
            
            // For each S ∈ SUCC do:
            for var successor in successors {
                
                // If node S* has previously been created, and if state(S*) = state(S), then S ← S*
                for node in open {
                    if node == successor {
                        successor = node
                        break
                    }
                }
                
                for node in closed {
                    if node == successor {
                        successor = node
                        break
                    }
                }
                
                // push(S,kids(X))
                currentNode.children.append(successor)
                
                
                // If not(S ∈ OPEN) and not(S ∈ CLOSED)
                if open.contains(successor) == false && closed.contains(successor) == false {
                    // attach-and-eval(S,X)
                    attachAndEval(child: successor, parent: currentNode)
                    
                    // insert(S,OPEN) ;; OPEN is sorted by ascending f value.
                    insertIntoOpen(successor)
                }
                    
                // else if g(X) + arc-cost(X,S) < g(S) then (found cheaper path to S):
                else if let currentNodeG = currentNode.g, let successorG = successor.g, currentNodeG + successor.cost < successorG
                {
                    // attach-and-eval(S,X)
                    attachAndEval(child: successor, parent: currentNode)
                    
                    // If S ∈ CLOSED then propagate-path-improvements(S)
                    if closed.contains(successor) {
                        propagatePathImprovements(successor)
                    }
                }
            }
        }
        
    }
    
    
    
    
    
    // -------------------------------
    // MARK: Private Helpers
    // -------------------------------
    
    // Returns all adjacent nodes that or not the nodes parent
    fileprivate func getSuccessorNodes(_ node: Node) -> [Node] {
        let x = node.coordinate.x
        let y = node.coordinate.y
        
        var successors = [Node]()
        
        // An .Obstacle is more significant than any weight. Should not 
        // be possible to go through no matter what. It's therefore
        // not considered a successor.
        
        if let top = map.getNode(Coordinate(x: x, y: y - 1)) {
            if let parent = node.parent, top == parent { }
            else if top.nodeCategory != .obstacle {
                successors.append(top)
            }
        }
        
        if let right = map.getNode(Coordinate(x: x + 1, y: y)) {
            if let parent = node.parent, right == parent {}
            else if right.nodeCategory != .obstacle  {
                successors.append(right)
            }
        }
        
        if let bottom = map.getNode(Coordinate(x: x, y: y + 1)) {
            if let parent = node.parent, bottom == parent { }
            else if bottom.nodeCategory != .obstacle  {
                successors.append(bottom)
            }
        }
        
        if let left = map.getNode(Coordinate(x: x - 1, y: y)) {
            if let parent = node.parent, left == parent { }
            else if left.nodeCategory != .obstacle  {
                successors.append(left)
            }
        }
        
        return successors
    }
    
    // Returns and removes the first node of open, if there was one
    fileprivate mutating func popOpen() -> Node? {
        if open.count > 0 {
            return open.remove(at: 0)
        } else {
            // The open list is empty, and the algorithm is done
            return nil
        }
    }
    
    // Will insert a node to the correct index in open
    fileprivate mutating func insertIntoOpen(_ node: Node) {
        
        switch algorithm {
        case .aStar:
            var index = 0
            
            for nIndex in 0..<(open.count) {
                let n = open[nIndex]
                
                if let nF = n.f, let nodeF = node.f, nF >= nodeF {
                    break
                } else {
                    index += 1
                }
            }
            
            open.insert(node, at: index)
        case .bfs:
            open.append(node)
        case .dijkstra:
            var index = 0
            
            for nIndex in 0..<(open.count) {
                let n = open[nIndex]
                
                if let nG = n.g, let nodeG = node.g, nG >= nodeG {
                    break
                } else {
                    index += 1
                }
            }
            
            open.insert(node, at: index)
        }
        
    }
    
    // Will return the path with the startNode as index 0, and destination as the last node
    fileprivate func getPathFromStartTo(_ destination: Node) -> [Node] {
        var currentNode = destination
        var path = [currentNode]
        
        if currentNode == map.startNode {
            return path
        }
        
        while currentNode != map.startNode {
            if let parent = currentNode.parent {
                currentNode = parent
                path.insert(currentNode, at: 0)
            } else {
                return path
            }
        }
        
        return path
    }
    
    // Gets the nodes that were explored, but are not part of the path
    fileprivate func getClosedNodesWithoutPath(_ path: [Node], allClosed: [Node]) -> [Node] {
        var output = [Node]()
        
        for closedNode in allClosed {
            if path.contains(closedNode) == false {
                output.append(closedNode)
            }
        }
        
        return output
    }
    
    fileprivate func attachAndEval(child: Node, parent: Node) {
        guard let parentG = parent.g else {
            print("The parent does not have a g value")
            return
        }
        
        child.parent = parent
        child.g = parentG + child.cost
        child.h = calculateH(child)
    }
    
    // Recursively improve g improvements
    fileprivate func propagatePathImprovements(_ parent: Node) {
        guard let parentG = parent.g else { return }
        
        for child in parent.children {
            guard let childG = child.g else { continue }
            if parentG + child.cost < childG {
                child.parent = parent
                child.g = parentG + child.cost
                propagatePathImprovements(child)
            }
        }
    }
    
    fileprivate func calculateH(_ node: Node) -> Int32 {
        return Int32(abs(node.coordinate.x - map.endNode.coordinate.x)) + Int32(abs(node.coordinate.y - map.endNode.coordinate.y))
    }
    
    // Prepare in case we want to calculate aStar again with the same map
    fileprivate mutating func reset() {
        open = [Node]()
        closed = [Node]()
    }
}
