//: Playground - noun: a place where people can play

import UIKit

enum FieldState: String {
    case empty = ""
    case x = "X"
    case y = "Y"
}

enum GameError: Error {
    case moveNotAllowedError
    case signInvalid
}

class Game {
    
    // MARK: - Properties
    let boardSize: Int
    var board: Board?
    var lastState = FieldState.empty
    
    // MARK: - Initializer
    init(boardSize: Int) {
        self.boardSize = boardSize
        
        self.board = Board(size: boardSize)
    }
    
    // MARK: - Public API
    func processInput(_ input: String?) -> String {
        // Example: X,0,2
        guard let input = input else { return "Value not valid" }
        
        let components = input.components(separatedBy: ",")
        let sign = components[0]
        let row = Int(components[1])!
        let column = Int(components[2])!
        
        return move(sign: sign, row: row, column: column)
    }
    
    func hasSomeoneWon() -> FieldState {
        if checkStateWon(.x) { return .x }
        if checkStateWon(.y) { return .y }
        
        return .empty
    }
    
    // MARK: - Private API
    func move(sign: String, row: Int, column: Int) -> String {
        guard isMoveAllowed(row: row, column: column) else { return "Move is not allowed" }
        guard let state = FieldState(rawValue: sign) else { return "You can only have X and Y" }
        guard areCoordinatesValid(row: row, column: column) else { return "Coordinates not valid" }
        guard lastState != state else { return "It's not your turn now" }
        
        board?.fields[row][column] = state
        lastState = state
        
        // Check for win!
        let winner = hasSomeoneWon()
        if winner != .empty {
            return "Winner of the game is \(winner.rawValue)"
        }
        
        return "Move played at position: \(row),\(column) with \(sign)"
    }
    
    private func isMoveAllowed(row: Int, column: Int) -> Bool {
        guard let board = board else { return false }
        
        return board.fields[row][column] == .empty // otherwise, someone already played that move
    }
    
    private func checkColumnWin(_ column: Int, forState state: FieldState) -> Bool {
        for i in 0..<boardSize {
            if board?.fields[i][column] != state {
                return false
            }
        }
        
        return true
    }
    
    private func checkRowWin(_ row: Int, forState state: FieldState) -> Bool {
        for i in 0..<boardSize {
            if board?.fields[row][i] != state {
                return false
            }
        }
        
        return true
    }
    
    private func checkDiagonalWin(_ row: Int, forState state: FieldState) -> Bool {
        for i in 0..<boardSize {
            for j in 0..<boardSize {
                if board?.fields[i][j] != state {
                    return false
                }
            }
        }
        
        return true
    }
    
    private func checkStateWon(_ state: FieldState) -> Bool {
        for i in 0..<boardSize {
            if checkRowWin(i, forState: state) { return true }
            if checkColumnWin(i, forState: state) { return true }
            if checkDiagonalWin(i, forState: state) { return true }
        }
        
        return false
    }
    
    private func areCoordinatesValid(row: Int, column: Int) -> Bool {
        if row >= boardSize || column >= boardSize {
            return false
        }
        
        return true
    }
    
}

class Board {
    
    // MARK: - Properties
    let size: Int
    var fields = [[FieldState]]()
    
    // MARK: - Initializer
    init(size: Int) {
        self.size = size
        
        for i in 0..<size {
            for j in 0..<size {
                fields[i][j] = .empty
            }
        }
    }
    
}

func main() {
    print("Enter board size:")
    
    if let size = readLine(), let boardSize = Int(size) {
        let game = Game(boardSize: boardSize)

        while game.hasSomeoneWon() != .empty {
            print("Enter your next move:")
            game.processInput(readLine())
        }
    }
}

//main()
