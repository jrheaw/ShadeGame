//
//  ShadeButtonGame.swift
//  ShadeButtonTheGame
//
//  Created by Jacob Wittenauer on 3/10/16.
//  Copyright © 2016 Jacob Wittenauer. All rights reserved.
//

import Foundation

enum ButtonState: String {
    case GREY, YELLOW, DARKYELLOW, SHADE, DARKGREY
}
struct StartButton {
    var row: Int?
    var column: Int?
    var state: ButtonState = .GREY
}
class ShadeButtonGame {
    var gameGrid: [[ButtonState]] = [[]]
    var solutionCoords: [(row:Int, column:Int)] = []
    var startingButtons: [StartButton] = []
    
    var numColumns: Int?
    var numRows: Int?
    
    init(level: Int) {
        loadLevel(level)
    }
    
    func loadLevel(level: Int) {
        if let levelsFilePath = NSBundle.mainBundle().pathForResource("levels", ofType: "txt") {
            if let levelsContents = try? String(contentsOfFile: levelsFilePath, usedEncoding: nil) {
                let lines = levelsContents.componentsSeparatedByString("\n")
                let levelIndex = 3 * (level - 1)
                
                //load first text line of level which contains level number and grid size
                if lines.indices.contains(levelIndex) {
                    let levelLine = lines[levelIndex]
                    let levelAndSize = levelLine.componentsSeparatedByString(":")
                    
                    let gridSizes = getXYFromString(levelAndSize[1])
                    numColumns = gridSizes.row //in this case it's a count
                    numRows = gridSizes.column
                    
                    //load second text line of level which contains the solution
                    let solutionLine = lines[levelIndex + 1]
                    let solutionCoordsStringArray = solutionLine.componentsSeparatedByString(":")
                    for coordString in solutionCoordsStringArray {
                        solutionCoords.append(getXYFromString(coordString))
                    }
                    
                    //load third text line of level which contains the starting lights and colors
                    let startingLine = lines[levelIndex + 2]
                    let startingCoordsStringArray = startingLine.componentsSeparatedByString(":")
                    for coordColorString in startingCoordsStringArray {
                        let coordColorArray = coordColorString.componentsSeparatedByString(",")
                        var startButton = StartButton()
                        startButton.row = Int(coordColorArray[0])
                        startButton.column = Int(coordColorArray[1])
                        switch(coordColorArray[2]) {
                        case "Y":
                            if solutionContains(solutionCoords, v: (startButton.row!, startButton.column!)) {
                                startButton.state = .DARKYELLOW
                            } else {
                                startButton.state = .YELLOW
                            }
                        default:
                            startButton.state = .GREY
                        }
                        startingButtons.append(startButton)
                    }
                } else {
                    numColumns = 5
                    numRows = 5
                    for _ in 1...10 {
                        solutionCoords.append((row: Int(arc4random_uniform(UInt32(5))), column: Int(arc4random_uniform(UInt32(5)))))
                    }
                    for _ in 1...10 {
                        var startButton = StartButton()
                        startButton.row = Int(arc4random_uniform(UInt32(5)))
                        startButton.column = Int(arc4random_uniform(UInt32(5)))
                        if solutionContains(solutionCoords, v: (startButton.row!, startButton.column!)) {
                            startButton.state = .DARKYELLOW
                        } else {
                            startButton.state = .YELLOW
                        }
                        startingButtons.append(startButton)
                    }
                }
            }
            setUpGameGrid()
        }
    }
    
    func setUpGameGrid() {
        let buttonRow = [ButtonState] (count: numColumns!, repeatedValue: .GREY)
        gameGrid = [[ButtonState]] (count: numRows!, repeatedValue: buttonRow)
        for solutionCoord in solutionCoords {
            gameGrid[solutionCoord.row][solutionCoord.column] = .DARKGREY
        }
        for startButton in startingButtons {
            gameGrid[startButton.row!][startButton.column!] = startButton.state
        }
    }
    
    //Returns a tuple of ints from a string consisting of two comma separated integers
    func getXYFromString(commaSeparatedIntegers: String) -> (row: Int, column: Int) {
        let stringArray = commaSeparatedIntegers.componentsSeparatedByString(",")
        let x = Int(stringArray[0])
        let y = Int(stringArray[1])
        return (x!, y!)
    }
    
    
    func getRandom() -> Int {
        return Int(arc4random_uniform(5))
    }
    
    func getButtonStateAtPosition(row: Int, _ col: Int) -> ButtonState {
        return gameGrid[row][col]
    }
    
    func hasWon() -> Bool {
        for solutionCoord in solutionCoords {
            if gameGrid[solutionCoord.row][solutionCoord.column] != .DARKGREY {
                return false
            }
        }
        return true
    }
    
    func buttonPressedAtLocation(row row: Int, col: Int) {
        print("buttonPressedAtLocation \(row) \(col)")
        if isInGrid(row, col) {
            switch gameGrid[row][col] {
            case .DARKGREY:
                grayPressedAt(row, col)
            case .GREY:
                grayPressedAt(row, col)
            case .YELLOW:
                yellowPressedAt(row, col)
            case .DARKYELLOW:
                yellowPressedAt(row, col)
            case .SHADE:
                print("shade")
            }
        }
    }
    
    func grayPressedAt(row: Int, _ col: Int) {
        changeTop(row, col, buttonState: .YELLOW)
        changeRight(row, col, buttonState: .YELLOW)
        changeBottom(row, col, buttonState: .YELLOW)
        changeLeft(row, col, buttonState: .YELLOW)
        changeButtonStateAtLocation(row, col, buttonState: .YELLOW)
    }
    
    func yellowPressedAt(row: Int, _ col: Int) {
        changeTop(row, col, buttonState: .GREY)
        changeRight(row, col, buttonState: .GREY)
        changeBottom(row, col, buttonState: .GREY)
        changeLeft(row, col, buttonState: .GREY)
        changeButtonStateAtLocation(row, col, buttonState: .YELLOW)
    }
    
    func changeTop(row: Int, _ col: Int, buttonState: ButtonState) {
        changeButtonStateAtLocation(row - 1, col, buttonState: buttonState)
    }
    
    func changeRight(row: Int, _ col: Int, buttonState: ButtonState) {
        changeButtonStateAtLocation(row, col + 1, buttonState: buttonState)
    }
    
    func changeBottom(row: Int, _ col: Int, buttonState: ButtonState) {
        changeButtonStateAtLocation(row + 1, col, buttonState: buttonState)
    }
    
    func changeLeft(row: Int, _ col: Int, buttonState: ButtonState) {
        changeButtonStateAtLocation(row, col - 1, buttonState: buttonState)
    }
    
    private func changeButtonStateAtLocation(row: Int, _ col: Int, buttonState: ButtonState) {
        if isInGrid(row, col) {
            switch gameGrid[row][col] {
            case .DARKGREY:
                gameGrid[row][col] = .DARKYELLOW
            case .GREY:
                gameGrid[row][col] = .YELLOW
            case .YELLOW:
                gameGrid[row][col] = .GREY
            case .DARKYELLOW:
                gameGrid[row][col] = .DARKGREY
            case .SHADE:
                print("shade")
            }
        }
    }
    
    func solutionContains(a:[(row: Int, column: Int)], v:(Int,Int)) -> Bool {
        let (c1, c2) = v
        for (v1, v2) in a { if v1 == c1 && v2 == c2 { return true } }
        return false
    }
    
    private func isInGrid(row: Int, _ col: Int) -> Bool {
        let isInGrid = gameGrid.indices.contains(row) && gameGrid[0].indices.contains(col)
        return isInGrid
    }
}