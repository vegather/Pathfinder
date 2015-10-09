//
//  PathfinderTests.swift
//  PathfinderTests
//
//  Created by Vegard Solheim Theriault on 09/10/15.
//  Copyright © 2015 Vegard Solheim Theriault. All rights reserved.
//

import XCTest
@testable import Pathfinder

class PathfinderTests: XCTestCase {
    
    private let algorithmToTest = Algorithm.BFS
    
    func testBoard_1_1() { measureBlock { self.testBoardWithName("board-1-1", algorithm: self.algorithmToTest) } }
    
    func testBoard_1_2() { measureBlock { self.testBoardWithName("board-1-2", algorithm: self.algorithmToTest) } }
    
    func testBoard_1_3() { measureBlock { self.testBoardWithName("board-1-3", algorithm: self.algorithmToTest) } }
    
    func testBoard_1_4() { measureBlock { self.testBoardWithName("board-1-4", algorithm: self.algorithmToTest) } }
    
    func testBoard_2_1() { measureBlock { self.testBoardWithName("board-2-1", algorithm: self.algorithmToTest) } }
    
    func testBoard_2_2() { measureBlock { self.testBoardWithName("board-2-2", algorithm: self.algorithmToTest) } }
    
    func testBoard_2_3() { measureBlock { self.testBoardWithName("board-2-3", algorithm: self.algorithmToTest) } }
    
    func testBoard_2_4() { measureBlock { self.testBoardWithName("board-2-4", algorithm: self.algorithmToTest) } }
    
    
    
    
    private func testBoardWithName(name: String, algorithm: Algorithm) {
        if let map = MapLoader.loadMapWithName(name) {
            var pathfinder = Pathfinder(map: map, algorithm: algorithm)
            let _ = pathfinder.aStar()
        }
    }
    
    private func getPathString(path: [Node]) -> String {
        var pathString = ""
        for node in path {
            pathString += "(\(node.coordinate.x),\(node.coordinate.y)), "
        }
        
        return pathString
    }
}
