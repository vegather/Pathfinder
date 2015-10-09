# Pathfinder

## Description

This is simply an implementation I wrote in Swift 2 for a school project of the three pathfinding algorithms: A*, Breadth First Search, and Dijkstra's. The difference between the three is in how they sort the list of "open" nodes, and can be seen in the `func insertIntoOpen(node: Node)` function in Pathfinder.swift.

The app works by loading in two types of text files: some with simply a maze (with the prefix board-1-...), and some with landscape where different tiles have different costs. The costs are shown below.


### Costs For the Landscape Maps

- Water: 100
- Mountains: 50
- Forests: 10
- Grasslands: 5
- Roads: 1
- Start and End: 1

As for the mazes (boards 1-x.txt), the obstacles are specially taken care of to be inpenetrable. See the `func getSuccessorNodes(node: Node) -> [Node]` function in Pathfinder.swift.


## Demo

