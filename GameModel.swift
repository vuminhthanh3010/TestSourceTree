import Foundation

enum GameDifficulty {
    case easy    // 3x3 grid
    case medium  // 4x4 grid
    case hard    // 5x5 grid
    
    var gridSize: Int {
        switch self {
        case .easy: return 3
        case .medium: return 4
        case .hard: return 5
        }
    }
    
    var memoryTime: TimeInterval {
        switch self {
        case .easy: return 5.0
        case .medium: return 4.0
        case .hard: return 3.0
        }
    }
    
    var displayName: String {
        switch self {
        case .easy: return "Easy (3x3)"
        case .medium: return "Medium (4x4)"
        case .hard: return "Hard (5x5)"
        }
    }
}

enum GameMode {
    case casual    // Can retry wrong tiles
    case challenge // Game over on wrong tile
    
    var displayName: String {
        switch self {
        case .casual: return "Casual Mode"
        case .challenge: return "Challenge Mode"
        }
    }
}

struct GameTile {
    let number: Int
    let position: Int
    var isRevealed: Bool = false
    var isCompleted: Bool = false
}

class GameModel {
    private(set) var tiles: [GameTile] = []
    private(set) var gridSize: Int = 3
    private(set) var currentNumber: Int = 1
    private(set) var totalNumbers: Int = 9
    private(set) var score: Int = 0
    private(set) var mistakes: Int = 0
    private(set) var gameStartTime: Date?
    private(set) var isGameActive: Bool = false
    private(set) var isMemoryPhase: Bool = false
    
    let difficulty: GameDifficulty
    let mode: GameMode
    
    init(difficulty: GameDifficulty, mode: GameMode) {
        self.difficulty = difficulty
        self.mode = mode
        self.gridSize = difficulty.gridSize
        self.totalNumbers = gridSize * gridSize
        setupGame()
    }
    
    private func setupGame() {
        // Create shuffled numbers from 1 to totalNumbers
        var numbers = Array(1...totalNumbers)
        numbers.shuffle()
        
        tiles = numbers.enumerated().map { index, number in
            GameTile(number: number, position: index)
        }
        
        currentNumber = 1
        score = 0
        mistakes = 0
        isGameActive = false
        isMemoryPhase = false
    }
    
    func startMemoryPhase() {
        isMemoryPhase = true
        for i in 0..<tiles.count {
            tiles[i].isRevealed = true
        }
    }
    
    func startGamePhase() {
        isMemoryPhase = false
        isGameActive = true
        gameStartTime = Date()
        
        for i in 0..<tiles.count {
            tiles[i].isRevealed = false
        }
    }
    
    func selectTile(at position: Int) -> TileSelectionResult {
        guard isGameActive && !isMemoryPhase else { return .invalid }
        guard position < tiles.count else { return .invalid }
        
        let tile = tiles[position]
        
        if tile.number == currentNumber {
            // Correct tile selected
            tiles[position].isRevealed = true
            tiles[position].isCompleted = true
            currentNumber += 1
            
            // Calculate score bonus
            let timeBonus = max(0, 1000 - Int(Date().timeIntervalSince(gameStartTime ?? Date())))
            let mistakesPenalty = mistakes * 50
            score += max(100, 200 - mistakesPenalty + timeBonus)
            
            if currentNumber > totalNumbers {
                // Game completed
                isGameActive = false
                return .gameCompleted
            }
            
            return .correct
        } else {
            // Wrong tile selected
            mistakes += 1
            
            if mode == .challenge {
                // Game over in challenge mode
                isGameActive = false
                return .gameOver
            } else {
                // In casual mode, show the tile briefly then hide it
                tiles[position].isRevealed = true
                return .wrong
            }
        }
    }
    
    func hideTile(at position: Int) {
        guard position < tiles.count else { return }
        if !tiles[position].isCompleted {
            tiles[position].isRevealed = false
        }
    }
    
    func getElapsedTime() -> TimeInterval {
        guard let startTime = gameStartTime else { return 0 }
        return Date().timeIntervalSince(startTime)
    }
    
    func resetGame() {
        setupGame()
    }
    
    func getTileAt(position: Int) -> GameTile? {
        guard position < tiles.count else { return nil }
        return tiles[position]
    }
    
    var isGameCompleted: Bool {
        return currentNumber > totalNumbers
    }
}

enum TileSelectionResult {
    case correct
    case wrong
    case gameOver
    case gameCompleted
    case invalid
}