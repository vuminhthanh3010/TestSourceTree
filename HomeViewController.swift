import UIKit

class HomeViewController: BaseViewController {
    
    // MARK: - Header Section
    private let headerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#1E3A8A")
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "🎨 COLOR MASTER"
        label.font = UIFont.systemFont(ofSize: 28, weight: .black)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome back, Guest!"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let streakLabel: UILabel = {
        let label = UILabel()
        label.text = "🔥 5 Day Streak"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(hex: "#FFA726")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Status Cards
    private let statusStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let weatherCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#E3F2FD")
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let weatherInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "☀️\nPerfect Day\nfor Colors!"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(hex: "#1976D2")
        label.textAlignment = .center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tipCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F3E5F5")
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let gameTipLabel: UILabel = {
        let label = UILabel()
        label.text = "💡\nDaily Tip\nMix primaries!"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(hex: "#7B1FA2")
        label.textAlignment = .center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scoreCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#E8F5E8")
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "🏆\nBest Score\n1,250"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(hex: "#2E7D32")
        label.textAlignment = .center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Interactive Color Palette
    private let paletteContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let paletteStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Main Action Button
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🎮 START PLAYING", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = UIColor(hex: "#4CAF50")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor(hex: "#4CAF50").cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Secondary Actions Grid
    private let actionsGridView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tutorialButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📚\nTutorial", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = UIColor(hex: "#2196F3")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let leaderboardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🏆\nLeaderboard", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = UIColor(hex: "#FF9800")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("⚙️\nSettings", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = UIColor(hex: "#9C27B0")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let achievementsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🎖️\nAchievements", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = UIColor(hex: "#E91E63")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Animated Elements
    private var colorPaletteBubbles: [UIView] = []
    private var pulseTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupActions()
        createInteractivePalette()
        updateWeatherInfo()
        startAnimations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pulseTimer?.invalidate()
    }
    
    private func setupView() {
        title = ""
        navigationItem.hidesBackButton = true
        view.backgroundColor = UIColor(hex: "#F8F9FA")
        
        // Add header
        view.addSubview(headerContainerView)
        headerContainerView.addSubview(titleLabel)
        headerContainerView.addSubview(playerNameLabel)
        headerContainerView.addSubview(streakLabel)
        
        // Add status cards
        view.addSubview(statusStackView)
        statusStackView.addArrangedSubview(weatherCard)
        statusStackView.addArrangedSubview(tipCard)
        statusStackView.addArrangedSubview(scoreCard)
        
        weatherCard.addSubview(weatherInfoLabel)
        tipCard.addSubview(gameTipLabel)
        scoreCard.addSubview(scoreLabel)
        
        // Add palette
        view.addSubview(paletteContainerView)
        paletteContainerView.addSubview(paletteStackView)
        
        // Add main button
        view.addSubview(playButton)
        
        // Add actions grid
        view.addSubview(actionsGridView)
        actionsGridView.addSubview(tutorialButton)
        actionsGridView.addSubview(leaderboardButton)
        actionsGridView.addSubview(settingsButton)
        actionsGridView.addSubview(achievementsButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Header
            headerContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainerView.heightAnchor.constraint(equalToConstant: 140),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: headerContainerView.centerXAnchor),
            
            playerNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            playerNameLabel.centerXAnchor.constraint(equalTo: headerContainerView.centerXAnchor),
            
            streakLabel.topAnchor.constraint(equalTo: playerNameLabel.bottomAnchor, constant: 5),
            streakLabel.centerXAnchor.constraint(equalTo: headerContainerView.centerXAnchor),
            
            // Status Cards
            statusStackView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: 20),
            statusStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statusStackView.heightAnchor.constraint(equalToConstant: 80),
            
            weatherInfoLabel.centerXAnchor.constraint(equalTo: weatherCard.centerXAnchor),
            weatherInfoLabel.centerYAnchor.constraint(equalTo: weatherCard.centerYAnchor),
            
            gameTipLabel.centerXAnchor.constraint(equalTo: tipCard.centerXAnchor),
            gameTipLabel.centerYAnchor.constraint(equalTo: tipCard.centerYAnchor),
            
            scoreLabel.centerXAnchor.constraint(equalTo: scoreCard.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: scoreCard.centerYAnchor),
            
            // Palette
            paletteContainerView.topAnchor.constraint(equalTo: statusStackView.bottomAnchor, constant: 25),
            paletteContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            paletteContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            paletteContainerView.heightAnchor.constraint(equalToConstant: 80),
            
            paletteStackView.centerXAnchor.constraint(equalTo: paletteContainerView.centerXAnchor),
            paletteStackView.centerYAnchor.constraint(equalTo: paletteContainerView.centerYAnchor),
            paletteStackView.leadingAnchor.constraint(greaterThanOrEqualTo: paletteContainerView.leadingAnchor, constant: 20),
            paletteStackView.trailingAnchor.constraint(lessThanOrEqualTo: paletteContainerView.trailingAnchor, constant: -20),
            paletteStackView.heightAnchor.constraint(equalToConstant: 40),
            
            // Play Button
            playButton.topAnchor.constraint(equalTo: paletteContainerView.bottomAnchor, constant: 30),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 250),
            playButton.heightAnchor.constraint(equalToConstant: 55),
            
            // Actions Grid
            actionsGridView.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 25),
            actionsGridView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            actionsGridView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            actionsGridView.heightAnchor.constraint(equalToConstant: 160),
            
            // Grid Layout (2x2)
            tutorialButton.topAnchor.constraint(equalTo: actionsGridView.topAnchor),
            tutorialButton.leadingAnchor.constraint(equalTo: actionsGridView.leadingAnchor),
            tutorialButton.widthAnchor.constraint(equalTo: actionsGridView.widthAnchor, multiplier: 0.48),
            tutorialButton.heightAnchor.constraint(equalToConstant: 70),
            
            leaderboardButton.topAnchor.constraint(equalTo: actionsGridView.topAnchor),
            leaderboardButton.trailingAnchor.constraint(equalTo: actionsGridView.trailingAnchor),
            leaderboardButton.widthAnchor.constraint(equalTo: actionsGridView.widthAnchor, multiplier: 0.48),
            leaderboardButton.heightAnchor.constraint(equalToConstant: 70),
            
            settingsButton.bottomAnchor.constraint(equalTo: actionsGridView.bottomAnchor),
            settingsButton.leadingAnchor.constraint(equalTo: actionsGridView.leadingAnchor),
            settingsButton.widthAnchor.constraint(equalTo: actionsGridView.widthAnchor, multiplier: 0.48),
            settingsButton.heightAnchor.constraint(equalToConstant: 70),
            
            achievementsButton.bottomAnchor.constraint(equalTo: actionsGridView.bottomAnchor),
            achievementsButton.trailingAnchor.constraint(equalTo: actionsGridView.trailingAnchor),
            achievementsButton.widthAnchor.constraint(equalTo: actionsGridView.widthAnchor, multiplier: 0.48),
            achievementsButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func createInteractivePalette() {
        let colors: [UIColor] = [
            UIColor(hex: "#FF5722"), // Red-Orange
            UIColor(hex: "#FFC107"), // Amber
            UIColor(hex: "#4CAF50"), // Green
            UIColor(hex: "#2196F3"), // Blue
            UIColor(hex: "#9C27B0"), // Purple
            UIColor(hex: "#E91E63")  // Pink
        ]
        
        colorPaletteBubbles.removeAll()
        
        for (index, color) in colors.enumerated() {
            let bubble = UIView()
            bubble.backgroundColor = color
            bubble.layer.cornerRadius = 20
            bubble.layer.shadowColor = color.cgColor
            bubble.layer.shadowOffset = CGSize(width: 0, height: 2)
            bubble.layer.shadowRadius = 4
            bubble.layer.shadowOpacity = 0.3
            bubble.translatesAutoresizingMaskIntoConstraints = false
            
            // Add subtle inner shadow effect
            let innerShadow = CALayer()
            innerShadow.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            innerShadow.cornerRadius = 20
            innerShadow.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
            bubble.layer.addSublayer(innerShadow)
            
            paletteStackView.addArrangedSubview(bubble)
            colorPaletteBubbles.append(bubble)
            
            NSLayoutConstraint.activate([
                bubble.widthAnchor.constraint(equalToConstant: 40),
                bubble.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            // Add tap gesture
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorBubbleTapped(_:)))
            bubble.addGestureRecognizer(tapGesture)
            bubble.tag = index
        }
    }
    
    private func startAnimations() {
        // Animate color bubbles with pulsing effect
        pulseTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.animateColorBubbles()
        }
        
        // Initial animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animateColorBubbles()
        }
    }
    
    private func animateColorBubbles() {
        for (index, bubble) in colorPaletteBubbles.enumerated() {
            UIView.animate(withDuration: 1.0,
                          delay: Double(index) * 0.1,
                          options: [.autoreverse, .repeat],
                          animations: {
                bubble.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { _ in
                bubble.transform = .identity
            }
        }
    }
    
    private func updateWeatherInfo() {
        let weatherEmojis = ["☀️", "⛅️", "🌧", "❄️", "🌈", "⭐️"]
        let weatherTexts = ["Perfect Day", "Great Weather", "Cozy Vibes", "Cool Day", "Rainbow Day", "Starry Night"]
        
        let randomIndex = Int.arc4random_uniform(UInt32(weatherEmojis.count)))
        let emoji = weatherEmojis[randomIndex]
        let text = weatherTexts[randomIndex]
        
        weatherInfoLabel.text = "\(emoji)\n\(text)\nfor Colors!"
        
        // Update tip
        let tips = [
            "💡\nDaily Tip\nMix primaries!",
            "🎨\nPro Tip\nUse gradients!",
            "✨\nHint\nTry blending!",
            "🌟\nSecret\nLayer colors!"
        ]
        gameTipLabel.text = tips.randomElement() ?? tips[0]
        
        // Update score
        let scores = ["🏆\nBest Score\n1,250", "🥇\nHigh Score\n2,180", "⭐️\nTop Score\n3,420"]
        scoreLabel.text = scores.randomElement() ?? scores[0]
    }
    
    private func setupActions() {
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        tutorialButton.addTarget(self, action: #selector(tutorialButtonTapped), for: .touchUpInside)
        leaderboardButton.addTarget(self, action: #selector(leaderboardButtonTapped), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        achievementsButton.addTarget(self, action: #selector(achievementsButtonTapped), for: .touchUpInside)
    }
    
    @objc private func colorBubbleTapped(_ gesture: UITapGestureRecognizer) {
        guard let bubble = gesture.view else { return }
        
        // Animate bubble tap
        UIView.animate(withDuration: 0.2, animations: {
            bubble.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                bubble.transform = .identity
            }
        }
        
        // Show color info (optional feedback)
        let colors = ["Red-Orange", "Amber", "Green", "Blue", "Purple", "Pink"]
        let colorName = colors[bubble.tag]
        
        // Create temporary feedback label
        let feedbackLabel = UILabel()
        feedbackLabel.text = colorName
        feedbackLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        feedbackLabel.textColor = .white
        feedbackLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        feedbackLabel.textAlignment = .center
        feedbackLabel.layer.cornerRadius = 15
        feedbackLabel.clipsToBounds = true
        feedbackLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(feedbackLabel)
        NSLayoutConstraint.activate([
            feedbackLabel.centerXAnchor.constraint(equalTo: bubble.centerXAnchor),
            feedbackLabel.bottomAnchor.constraint(equalTo: bubble.topAnchor, constant: -10),
            feedbackLabel.widthAnchor.constraint(equalToConstant: 80),
            feedbackLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Animate and remove feedback
        feedbackLabel.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            feedbackLabel.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 1.0, options: [], animations: {
                feedbackLabel.alpha = 0
            }) { _ in
                feedbackLabel.removeFromSuperview()
            }
        }
    }
    
    @objc private func playButtonTapped() {
        // Add button animation
        UIView.animate(withDuration: 0.1, animations: {
            self.playButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.playButton.transform = .identity
            }
        }
        
        let levelsVC = LevelsViewController()
        navigationController?.pushViewController(levelsVC, animated: true)
    }
    
    @objc private func tutorialButtonTapped() {
        let tutorialVC = TutorialViewController()
        navigationController?.pushViewController(tutorialVC, animated: true)
    }
    
    @objc private func leaderboardButtonTapped() {
        let leaderboardVC = LeaderboardViewController()
        navigationController?.pushViewController(leaderboardVC, animated: true)
    }
    
    @objc private func settingsButtonTapped() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc private func achievementsButtonTapped() {
        // For now, redirect to leaderboard or create a new AchievementsViewController
        let leaderboardVC = LeaderboardViewController()
        navigationController?.pushViewController(leaderboardVC, animated: true)
    }
}