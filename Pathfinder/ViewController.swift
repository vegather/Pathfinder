//
//  ViewController.swift
//  Pathfinder
//
//  Created by Vegard Solheim Theriault on 09/10/15.
//  Copyright © 2015 Vegard Solheim Theriault. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var nodeView: NodeGraphView!
    @IBOutlet weak var mapPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapPicker.dataSource = self
        mapPicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }
    
    fileprivate func updateUI() {
        let nameIndex = mapPicker.selectedRow(inComponent: 0)
        let algorithmIndex = mapPicker.selectedRow(inComponent: 1)
        
        var boardName = ""
        if nameIndex == 0 {
            boardName = "board-1-1"
        } else if nameIndex == 1 {
            boardName = "board-1-2"
        } else if nameIndex == 2 {
            boardName = "board-1-3"
        } else if nameIndex == 3 {
            boardName = "board-1-4"
        } else if nameIndex == 4 {
            boardName = "board-2-1"
        } else if nameIndex == 5 {
            boardName = "board-2-2"
        } else if nameIndex == 6 {
            boardName = "board-2-3"
        } else if nameIndex == 7 {
            boardName = "board-2-4"
        }
        
        
        var algorithm: Algorithm
        if algorithmIndex == 0 {
            algorithm = .aStar
        } else if algorithmIndex == 1 {
            algorithm = .bfs
        } else {
            algorithm = .dijkstra
        }
        
        if let map = MapLoader.loadMapWithName(boardName) {
            var pathfinder = Pathfinder(map: map, algorithm: algorithm)
            if let (path, open, closed) = pathfinder.aStar() {
                nodeView.setData(map, path: path, open: open, closed: closed)
            } else {
                print("Could not find a path")
            }
        }
    }
    
    
    
    
    
    
    // -------------------------------
    // MARK: Picker View Data Source
    // -------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 8
        } else if component == 1 {
            return 3
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            if row == 0 {
                return "Board 1-1"
            } else if row == 1 {
                return "Board 1-2"
            } else if row == 2 {
                return "Board 1-3"
            } else if row == 3 {
                return "Board 1-4"
            } else if row == 4 {
                return "Board 2-1"
            } else if row == 5 {
                return "Board 2-2"
            } else if row == 6 {
                return "Board 2-3"
            } else if row == 7 {
                return "Board 2-4"
            }
        } else if component == 1 {
            if row == 0 {
                return "A*"
            } else if row == 1 {
                return "BFS"
            } else if row == 2 {
                return "Dijkstra's"
            }
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateUI()
    }
}


