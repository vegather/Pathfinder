//
//  MapLoader.swift
//  A Star Pathfinding
//
//  Created by Vegard Solheim Theriault on 08/10/15.
//  Copyright © 2015 Vegard Solheim Theriault. All rights reserved.
//

import Foundation

struct MapLoader {
    static func loadMapWithName(mapName: String) -> NodeMap? {
        guard let mapPath = NSBundle.mainBundle().pathForResource("boards/\(mapName)", ofType: "txt") else { return nil }
        let mapString: String
        do {
            mapString = try String(contentsOfFile:mapPath, encoding: NSUTF8StringEncoding)
        } catch {
            return nil
        }
        
        return NodeMap(mapAsString: mapString.componentsSeparatedByString("\n"))
    }
}