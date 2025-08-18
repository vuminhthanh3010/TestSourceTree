import UIKit

class GameViewController: UIViewController {
    
    private var gameModel: GameModel
    private var gameBoard: GameBoardView!
    private let topInfoContainer = UIView()
    private let scoreLabel = UILabel()
    private let nextNumberLabel = UILabel()
    private let mistakesLabel = UILabel()
    private let timerLabel = UILabel()
    private let backButton = UIButton(type: .system)
    private let instructionLabel = UILabel()
    private let memoryTimerLabel = UILabel()
    
    private var gameTimer: Timer?
    private var memoryTimer: Timer?
    private var memoryTimeRemaining: TimeInterval = 0
    
    init(difficulty: GameDifficulty, mode: GameMode) {
        self.gameModel = GameModel(difficulty: difficulty, mode: mode)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        startMemoryPhase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GradientHelper.applyGradient(to: view, type: .gameScreen)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        GradientHelper.updateGradientFrame(in: view)
    }
    
    deinit {
        gameTimer?.invalidate()
        memoryTimer?.invalidate()
    }
    
    private func setupUI() {
        // Top Info Container
        topInfoContainer.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        topInfoContainer.layer.cornerRadius = 15
        topInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topInfoContainer)
        
        // Back Button
        backButton.setTitle("← Back", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        backButton.setTitleColor(.white, for: .normal)
        backButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        backButton.layer.cornerRadius = 15
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
        
        // Score Label
        scoreLabel.text = "Score: 0"
        scoreLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        scoreLabel.textColor = .white
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        topInfoContainer.addSubview(scoreLabel)
        
        // Next Number Label
        nextNumberLabel.text = "Next: 1"
        nextNumberLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nextNumberLabel.textColor = .white
        nextNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        topInfoContainer.addSubview(nextNumberLabel)
        
        // Mistakes Label
        mistakesLabel.text = "Mistakes: 0"
        mistakesLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        mistakesLabel.textColor = .white
        mistakesLabel.translatesAutoresizingMaskIntoConstraints = false
        topInfoContainer.addSubview(mistakesLabel)
        
        // Timer Label
        timerLabel.text = "Time: 00:00"
        timerLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        timerLabel.textColor = .white
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        topInfoContainer.addSubview(timerLabel)
        
        // Instruction Label
        instructionLabel.text = "Memorize the numbers!"
        instructionLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        instructionLabel.textColor = .white
        instructionLabel.textAlignment = .center
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instructionLabel)
        
        // Memory Timer Label
        memoryTimerLabel.text = ""
        memoryTimerLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        memoryTimerLabel.textColor = UIColor.yellow
        memoryTimerLabel.textAlignment = .center
        memoryTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(memoryTimerLabel)
        
        // Game Board
        gameBoard = GameBoardView(gameModel: gameModel)
        gameBoard.delegate = self
        gameBoard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameBoard)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Back Button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 80),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Top Info Container
            topInfoContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            topInfoContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topInfoContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            topInfoContainer.heightAnchor.constraint(equalToConstant: 80),
            
            // Score Label
            scoreLabel.topAnchor.constraint(equalTo: topInfoContainer.topAnchor, constant: 15),
            scoreLabel.leadingAnchor.constraint(equalTo: topInfoContainer.leadingAnchor, constant: 20),
            
            // Next Number Label
            nextNumberLabel.topAnchor.constraint(equalTo: topInfoContainer.topAnchor, constant: 15),
            nextNumberLabel.trailingAnchor.constraint(equalTo: topInfoContainer.trailingAnchor, constant: -20),
            
            // Mistakes Label
            mistakesLabel.bottomAnchor.constraint(equalTo: topInfoContainer.bottomAnchor, constant: -15),
            mistakesLabel.leadingAnchor.constraint(equalTo: topInfoContainer.leadingAnchor, constant: 20),
            
            // Timer Label
            timerLabel.bottomAnchor.constraint(equalTo: topInfoContainer.bottomAnchor, constant: -15),
            timerLabel.trailingAnchor.constraint(equalTo: topInfoContainer.trailingAnchor, constant: -20),
            
            // Instruction Label
            instructionLabel.topAnchor.constraint(equalTo: topInfoContainer.bottomAnchor, constant: 20),
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Memory Timer Label
            memoryTimerLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 10),
            memoryTimerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Game Board
            gameBoard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameBoard.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            gameBoard.widthAnchor.constraint(equalToConstant: 300),
            gameBoard.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func startMemoryPhase() {
        gameModel.startMemoryPhase()
        gameBoard.updateDisplay()
        
        memoryTimeRemaining = gameModel.difficulty.memoryTime
        memoryTimerLabel.text = "\(Int(memoryTimeRemaining))"
        
        memoryTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateMemoryTimer()
        }
    }
    
    private func updateMemoryTimer() {
        memoryTimeRemaining -= 1.0
        
        if memoryTimeRemaining <= 0 {
            memoryTimer?.invalidate()
            memoryTimer = nil
            startGamePhase()
        } else {
            memoryTimerLabel.text = "\(Int(memoryTimeRemaining))"
        }
    }
    
    private func startGamePhase() {
        gameModel.startGamePhase()
        gameBoard.updateDisplay()
        
        instructionLabel.text = "Tap numbers in order: 1, 2, 3..."
        memoryTimerLabel.text = ""
        
        updateUI()
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    private func updateTimer() {
        let elapsed = gameModel.getElapsedTime()
        let minutes = Int(elapsed) / 60
        let seconds = Int(elapsed) % 60
        timerLabel.text = String(format: "Time: %02d:%02d", minutes, seconds)
    }
    
    private func updateUI() {
        scoreLabel.text = "Score: \(gameModel.score)"
        nextNumberLabel.text = "Next: \(gameModel.currentNumber)"
        mistakesLabel.text = "Mistakes: \(gameModel.mistakes)"
    }
    
    private func showGameResult(isWin: Bool) {
        gameTimer?.invalidate()
        gameTimer = nil
        
        let alertTitle = isWin ? "Congratulations!" : "Game Over"
        let alertMessage = isWin ? 
            "You completed the puzzle!\nScore: \(gameModel.score)\nTime: \(formatTime(gameModel.getElapsedTime()))\nMistakes: \(gameModel.mistakes)" :
            "Better luck next time!\nScore: \(gameModel.score)\nMistakes: \(gameModel.mistakes)"
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Play Again", style: .default) { [weak self] _ in
            self?.resetGame()
        })
        
        alert.addAction(UIAlertAction(title: "Main Menu", style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
        
        // Save stats
        if isWin {
            saveGameStats()
        }
    }
    
    private func saveGameStats() {
        let currentBestScore = UserDefaults.standard.integer(forKey: "bestScore")
        if gameModel.score > currentBestScore {
            UserDefaults.standard.set(gameModel.score, forKey: "bestScore")
        }
        
        let gamesPlayed = UserDefaults.standard.integer(forKey: "gamesPlayed")
        UserDefaults.standard.set(gamesPlayed + 1, forKey: "gamesPlayed")
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func resetGame() {
        gameTimer?.invalidate()
        memoryTimer?.invalidate()
        gameTimer = nil
        memoryTimer = nil
        
        gameModel.resetGame()
        gameBoard.updateDisplay()
        updateUI()
        
        instructionLabel.text = "Memorize the numbers!"
        startMemoryPhase()
    }
    
    @objc private func backButtonTapped() {
        gameTimer?.invalidate()
        memoryTimer?.invalidate()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - GameBoardViewDelegate
extension GameViewController: GameBoardViewDelegate {
    func didSelectTile(at position: Int) {
        let result = gameModel.selectTile(at: position)
        
        switch result {
        case .correct:
            updateUI()
            gameBoard.animateCorrectSelection(at: position)
            gameBoard.updateDisplay()
            
        case .wrong:
            updateUI()
            gameBoard.animateWrongSelection(at: position)
            
            // Hide the wrong tile after a brief delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.gameModel.hideTile(at: position)
                self?.gameBoard.updateDisplay()
            }
            
        case .gameOver:
            gameBoard.updateDisplay()
            showGameResult(isWin: false)
            
        case .gameCompleted:
            gameBoard.updateDisplay()
            showGameResult(isWin: true)
            
        case .invalid:
            break
        }
    }
}