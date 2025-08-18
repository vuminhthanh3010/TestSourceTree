import UIKit

class MainMenuViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let playButton = UIButton(type: .system)
    private let settingsButton = UIButton(type: .system)
    private let difficultySegmentedControl = UISegmentedControl(items: ["Easy", "Medium", "Hard"])
    private let modeSegmentedControl = UISegmentedControl(items: ["Casual", "Challenge"])
    private let statsContainerView = UIView()
    private let bestScoreLabel = UILabel()
    private let gamesPlayedLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadUserStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GradientHelper.applyGradient(to: view, type: .mainMenu)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        GradientHelper.updateGradientFrame(in: view)
    }
    
    private func setupUI() {
        // Title Label
        titleLabel.text = "Number Flip"
        titleLabel.font = UIFont.systemFont(ofSize: 42, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Subtitle Label
        subtitleLabel.text = "Memory • Logic • Speed"
        subtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)
        
        // Difficulty Selection
        difficultySegmentedControl.selectedSegmentIndex = 0
        difficultySegmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        difficultySegmentedControl.selectedSegmentTintColor = .white
        difficultySegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        difficultySegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        difficultySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(difficultySegmentedControl)
        
        // Mode Selection
        modeSegmentedControl.selectedSegmentIndex = 0
        modeSegmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        modeSegmentedControl.selectedSegmentTintColor = .white
        modeSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        modeSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        modeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modeSegmentedControl)
        
        // Play Button
        playButton.setTitle("Start Game", for: .normal)
        playButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        playButton.setTitleColor(.white, for: .normal)
        playButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        playButton.layer.cornerRadius = 25
        playButton.layer.borderWidth = 2
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        view.addSubview(playButton)
        
        // Settings Button
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        settingsButton.setTitleColor(.white, for: .normal)
        settingsButton.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        settingsButton.layer.cornerRadius = 20
        settingsButton.layer.borderWidth = 1
        settingsButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        view.addSubview(settingsButton)
        
        // Stats Container
        statsContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        statsContainerView.layer.cornerRadius = 15
        statsContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statsContainerView)
        
        // Best Score Label
        bestScoreLabel.text = "Best Score: 0"
        bestScoreLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        bestScoreLabel.textColor = .white
        bestScoreLabel.textAlignment = .center
        bestScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        statsContainerView.addSubview(bestScoreLabel)
        
        // Games Played Label
        gamesPlayedLabel.text = "Games Played: 0"
        gamesPlayedLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        gamesPlayedLabel.textColor = .white
        gamesPlayedLabel.textAlignment = .center
        gamesPlayedLabel.translatesAutoresizingMaskIntoConstraints = false
        statsContainerView.addSubview(gamesPlayedLabel)
        
        // Add button animations
        addButtonAnimations()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            
            // Subtitle
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            // Difficulty Selection
            difficultySegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            difficultySegmentedControl.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50),
            difficultySegmentedControl.widthAnchor.constraint(equalToConstant: 280),
            difficultySegmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            // Mode Selection
            modeSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modeSegmentedControl.topAnchor.constraint(equalTo: difficultySegmentedControl.bottomAnchor, constant: 20),
            modeSegmentedControl.widthAnchor.constraint(equalToConstant: 280),
            modeSegmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            // Stats Container
            statsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statsContainerView.topAnchor.constraint(equalTo: modeSegmentedControl.bottomAnchor, constant: 30),
            statsContainerView.widthAnchor.constraint(equalToConstant: 280),
            statsContainerView.heightAnchor.constraint(equalToConstant: 80),
            
            // Best Score
            bestScoreLabel.centerXAnchor.constraint(equalTo: statsContainerView.centerXAnchor),
            bestScoreLabel.topAnchor.constraint(equalTo: statsContainerView.topAnchor, constant: 15),
            
            // Games Played
            gamesPlayedLabel.centerXAnchor.constraint(equalTo: statsContainerView.centerXAnchor),
            gamesPlayedLabel.topAnchor.constraint(equalTo: bestScoreLabel.bottomAnchor, constant: 10),
            
            // Play Button
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: statsContainerView.bottomAnchor, constant: 40),
            playButton.widthAnchor.constraint(equalToConstant: 200),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Settings Button
            settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20),
            settingsButton.widthAnchor.constraint(equalToConstant: 150),
            settingsButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func addButtonAnimations() {
        [playButton, settingsButton].forEach { button in
            button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
            button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        }
    }
    
    @objc private func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform.identity
        }
    }
    
    @objc private func playButtonTapped() {
        let difficulty: GameDifficulty
        switch difficultySegmentedControl.selectedSegmentIndex {
        case 0: difficulty = .easy
        case 1: difficulty = .medium
        case 2: difficulty = .hard
        default: difficulty = .easy
        }
        
        let mode: GameMode = modeSegmentedControl.selectedSegmentIndex == 0 ? .casual : .challenge
        
        let gameViewController = GameViewController(difficulty: difficulty, mode: mode)
        navigationController?.pushViewController(gameViewController, animated: true)
    }
    
    @objc private func settingsButtonTapped() {
        let settingsViewController = SettingsViewController()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    private func loadUserStats() {
        let bestScore = UserDefaults.standard.integer(forKey: "bestScore")
        let gamesPlayed = UserDefaults.standard.integer(forKey: "gamesPlayed")
        
        bestScoreLabel.text = "Best Score: \(bestScore)"
        gamesPlayedLabel.text = "Games Played: \(gamesPlayed)"
    }
}