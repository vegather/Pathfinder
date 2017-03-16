//
//  NodeType.swift
//  A Star Pathfinding
//
//  Created by Vegard Solheim Theriault on 08/10/15.
//  Copyright © 2015 Vegard Solheim Theriault. All rights reserved.
//

import Foundation




// -------------------------------
// MARK: Coordinate
// -------------------------------

// A coordinate struct specifying grid position for the nodes
struct Coordinate: Equatable {
    let x: Int
    let y: Int
}

// Equatable implementation for Coordinate
func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}





// -------------------------------
// MARK: Node Category
// -------------------------------

// Specifies what type a certain node is
enum NodeCategory {
    case start
    case end
    
    // Subproblem A.1
    case empty
    case obstacle
    
    // Subproblem A.2
    case water
    case mountains
    case forests
    case grasslands
    case roads
}




// -------------------------------
// MARK: Node
// -------------------------------

// Using class here to make it a reference type that uses pointers,
// as opposed to value types (structs and enums) that are copied.
// This class encapsulates everything of value about a node.
// It's CustomStringConvertible to make it printable
class Node: CustomStringConvertible, Equatable {
    var children =  [Node]()
    var parent:     Node?
    var g:          Int32?   // Has to be Int32 to support the INT_MAX in cost
    var h:          Int32?   // Has to be Int32 to support the INT_MAX in cost
    var f:          Int32? { // Has to be Int32 to support the INT_MAX in cost
        // Does f calculations implicitly
        if let h = h, let g = g { return h + g }
        else { return nil }
    }
    
    let coordinate:   Coordinate
    let nodeCategory: NodeCategory
    
    init(coordinate: Coordinate, category: NodeCategory) {
        self.coordinate = coordinate
        self.nodeCategory = category
    }
    
    // Represents the cost from some node TO this node
    var cost: Int32 {
        switch nodeCategory {
        case .start, .end, .roads, .empty:
            return 1
        case .obstacle:
            return -1
        case .water:
            return 100
        case .mountains:
            return 50
        case .forests:
            return 10
        case .grasslands:
            return 5
        }
    }
    
    // CustomStringConvertible
    var description: String {
        switch nodeCategory {
        case .start:
            return "A"
        case .end:
            return "B"
        case .empty:
            return "."
        case .obstacle:
            return "#"
        case .water:
            return "w"
        case .mountains:
            return "m"
        case .forests:
            return "f"
        case .grasslands:
            return "g"
        case .roads:
            return "r"
        }
    }
}

// Equatable implementation for Node
// Only checks if the coordinates, and the category are the same, as we will update the node over time, i.e attach-and-eval
func ==(lhs: Node, rhs: Node) -> Bool {
    return lhs.nodeCategory == rhs.nodeCategory && lhs.coordinate == rhs.coordinate
}






// -------------------------------
// MARK: Node Graph
// -------------------------------

// Encapsulates the node graph. Provides convenience APIs to get nodes, and change them.
// Is CustomStringConvertible to be able to print it
// The origin the coordinate space is the upper left
struct NodeMap: CustomStringConvertible {
    let startNode: Node
    let endNode: Node
    
    fileprivate var nodes = [[Node]]()
    
    init(mapAsString: [String]) {
        var start: Node?
        var end: Node?
        
        for row in 0..<(mapAsString.count) {
            let rowString = mapAsString[row]
            if rowString.characters.count == 0 { continue }
            var currentRow = [Node]()
            
            for col in 0..<(rowString.characters.count) {
                let character = rowString.characters[rowString.characters.index(rowString.startIndex, offsetBy: col)]
                
                let currentNode: Node
                
                switch character {
                case "A":
                    currentNode = Node(coordinate: Coordinate(x: col, y: row), category: .start)
                    start = currentNode
                case "B":
                    currentNode = Node(coordinate: Coordinate(x: col, y: row), category: .end)
                    end = currentNode
                case ".":
                    currentNode = Node(coordinate: Coordinate(x: col, y: row), category: .empty)
                case "#":
                    currentNode = Node(coordinate: Coordinate(x: col, y: row), category: .obstacle)
                case "w":
                    currentNode = Node(coordinate: Coordinate(x: col, y: row), category: .water)
                case "m":
                    currentNode = Node(coordinate: Coordinate(x: col, y: row), category: .mountains)
                case "f":
                    currentNode = Node(coordinate: Coordinate(x: col, y: row), category: .forests)
                case "g":
                    currentNode = Node(coordinate: Coordinate(x: col, y: row), category: .grasslands)
                case "r":
                    currentNode = Node(coordinate: Coordinate(x: col, y: row), category: .roads)
                default:
                    print("\(character) is not a valid part of a map")
                    fatalError()
                }
                
                currentRow.append(currentNode)
            }
            nodes.append(currentRow)
        }
        
        if let start = start, let end = end {
            startNode = start
            endNode = end
        } else {
            print("Could not find both start and end")
            fatalError()
        }
    }
    
    func getNode(_ coordinate: Coordinate) -> Node? {
        if coordinate.x >= 0 && coordinate.x < mapWidth &&
           coordinate.y >= 0 && coordinate.y < mapHeight
        {
            return nodes[coordinate.y][coordinate.x]
        } else {
            return nil
        }
    }
    
    mutating func updateNodeAtCoordinate(_ coordinate: Coordinate, newNode: Node) {
        nodes[coordinate.y][coordinate.x] = newNode
    }
    
    var mapHeight: Int {
        return nodes.count
    }
    
    var mapWidth: Int {
        if nodes.count == 0 { return 0 }
        return nodes[0].count
    }
    
    // CustomStringConvertible
    var description: String {
        var output = ""
        
        for row in nodes {
            for col in row {
                output += "\(col)"
            }
            output += "\n"
        }
        
        return output
    }
}
