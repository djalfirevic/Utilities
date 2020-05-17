//: Algorithms

import Foundation

// Insertion Sort
func insertionSort(_ list: [Int]) -> [Int] {
	var j = 0
	var key = 0
	var temp = 0
	var array = list
	
	for i in 1..<list.count {
		key = array[i]
		j = i - 1
		
		while j >= 0 && key < array[j] {
			temp = array[j]
			array[j] = array[j + 1]
			array[j + 1] = temp
			j -= 1
		}
	}
	
	return array
}

insertionSort([2, 8, 5, 9, 7, 3])

// Fibonacci
func fibonacci(n: Int) -> Int {
	var result = [0, 1]
	
	for i in 2...n {
		let a = result[i - 1]
		let b = result[i - 2]
		result.append(a + b)
	}
	
	return result[n]
}

func fibonacciRecursion(n: Int) -> Int {
	if n < 2 {
		return n
	}
	
	return fibonacciRecursion(n: n - 1) + fibonacciRecursion(n: n - 2)
}

fibonacci(n: 5)
fibonacciRecursion(n: 6)

// There is a forum that has a limit of K characters per entry. In this task your job is to implement an algorithm for cropping messages that are too long.
public func solution(_ message: inout String, _ K: Int) -> String {
    if !isNumberValid(K) && !isMessageValid(message) {
        return ""
    }

    if message.hasPrefix(" ") {
        return ""
    }
    
    if K >= message.count {
        return message
    }
    
    let currentCharacter = message[message.index(message.startIndex, offsetBy: K)]
    
    if currentCharacter == " " {
        return String(message.prefix(K))
    }
    
    let characterIndex = message.index(message.startIndex, offsetBy: K-1)
    
    for i in 0..<K {
        let character = message[message.index(characterIndex, offsetBy: -i)]
        if character == " " {
            return String(message.prefix(K-1-i)).trimmingCharacters(in: .whitespaces)
        }
    }
    
    return ""
}

func isNumberValid(_ number: Int) -> Bool {
    if number >= 1 && number <= 500 {
        return true
    }
    
    return false
}

func isMessageValid(_ message: String) -> Bool {
    if message.count > 0 && message.count <= 500 {
        return true
    }
    
    return false
}

// Calculate the amount of money to pay based on logs of phone calls.
// Your monthly phone bill has arrived and it's unexpectedly large.
public func solution(_ S: String) -> Int {
    let logs = bills.components(separatedBy: "\n")
    var bills = [Bill]()
    var result = [String:Int]()
    
    for log in logs {
        bills.append(Bill(log: log))
    }
    
    for bill in bills {
        if let price = result[bill.number] {
            result[bill.number] = price + bill.price
        } else {
            result[bill.number] = bill.price
        }
        
        print("BILL: \(bill.description) : \(bill.price)")
    }
    
    print(result)
    let sortedResult = result.sorted { $0.1 < $1.1 }
    print(sortedResult)
    
    if let firstBill = sortedResult.first {
        return firstBill.value
    }
    
    return 0
}

var bills = """
00:01:07,400-234-090
00:05:01,701-080-080
00:05:00,400-234-090
"""

solution(bills)

struct Bill: CustomStringConvertible, Equatable {
    var log: String
    var hours = 0
    var minutes = 0
    var seconds = 0
    var number = ""
    var totalNumberOfSeconds: Int {
        return hours * 60 * 60 + minutes * 60 + seconds
    }
    var price: Int {
        if totalNumberOfSeconds < 5 * 60 {
            return totalNumberOfSeconds * 3
        }
        
        return minutes * 150 + (seconds > 0 ? 150 : 0)
    }
    
    init(log: String) {
        self.log = log
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        // Duration
        if let durationString = log.components(separatedBy: ",").first {
            // 00:01:07
            if let date = dateFormatter.date(from: durationString) {
                let calendar = Calendar.current
                self.hours = calendar.component(.hour, from: date)
                self.minutes = calendar.component(.minute, from: date)
                self.seconds = calendar.component(.second, from: date)
            }
            
        }
        
        // Number
        if let number = log.components(separatedBy: ",").last {
            // 400-234-090
            self.number = number
        }
    }
    
    var description: String {
        return "\(number) - H:\(hours),M:\(minutes),S:\(seconds)"
    }
    
    static func == (lhs: Bill, rhs: Bill) -> Bool {
        return lhs.number == rhs.number
    }
    
}

// Tic Tac Toe
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
