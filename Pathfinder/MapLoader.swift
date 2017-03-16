//
//  MapLoader.swift
//  A Star Pathfinding
//
//  Created by Vegard Solheim Theriault on 08/10/15.
//  Copyright © 2015 Vegard Solheim Theriault. All rights reserved.
//

import Foundation

struct MapLoader {
    static func loadMapWithName(_ mapName: String) -> NodeMap? {
        guard let mapPath = Bundle.main.path(forResource: "boards/\(mapName)", ofType: "txt") else { return nil }
        let mapString: String
        do {
            mapString = try String(contentsOfFile:mapPath, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
        
        return NodeMap(mapAsString: mapString.components(separatedBy: "\n"))
    }
}
