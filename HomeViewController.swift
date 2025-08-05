import UIKit
import CoreLocation

class HomeViewController: BaseViewController {
    
    private let locationManager = CLLocationManager()
    private var weatherLabel: UILabel!
    private var playerNameLabel: UILabel!
    private var nameTextField: UITextField!
    
    // New UI components
    private var statsCardView: UIView!
    private var gamesPlayedLabel: UILabel!
    private var bestTimeLabel: UILabel!
    private var streakLabel: UILabel!
    private var levelProgressView: UIProgressView!
    private var currentLevelLabel: UILabel!
    private var welcomeMessageLabel: UILabel!
    private var lastPlayedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationManager()
        setupPlayerName()
        loadPlayerStats()
        startWelcomeAnimation()
    }
    
    override func gradientColors() -> [CGColor] {
        return [UIColor(hex: "#667eea").cgColor, UIColor(hex: "#764ba2").cgColor]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        updatePlayerStats()
    }
    
    private func setupUI() {
        setupHeaderSection()
        setupStatsCard()
        setupGameTitle()
        setupMenuButtons()
        setupFooterSection()
    }
    
    private func setupHeaderSection() {
        // Header container
        let headerContainer = UIView()
        headerContainer.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        headerContainer.layer.cornerRadius = 15
        headerContainer.layer.backdropFilter = true
        
        view.addSubview(headerContainer)
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Weather Info with icon
        let weatherContainer = UIView()
        weatherContainer.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        weatherContainer.layer.cornerRadius = 20
        
        weatherLabel = UILabel()
        weatherLabel.text = "Loading weather..."
        weatherLabel.textColor = .white
        weatherLabel.textAlignment = .center
        weatherLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        let weatherIcon = UILabel()
        weatherIcon.text = "☀️"
        weatherIcon.font = UIFont.systemFont(ofSize: 16)
        weatherIcon.textAlignment = .center
        
        weatherContainer.addSubview(weatherIcon)
        weatherContainer.addSubview(weatherLabel)
        
        // Player greeting
        welcomeMessageLabel = UILabel()
        welcomeMessageLabel.text = "Welcome back!"
        welcomeMessageLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        welcomeMessageLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        welcomeMessageLabel.textAlignment = .center
        
        playerNameLabel = UILabel()
        playerNameLabel.text = "Player"
        playerNameLabel.textColor = .white
        playerNameLabel.textAlignment = .center
        playerNameLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        
        // Current level indicator
        currentLevelLabel = UILabel()
        currentLevelLabel.text = "Level 1"
        currentLevelLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        currentLevelLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        currentLevelLabel.textAlignment = .center
        
        levelProgressView = UIProgressView(progressViewStyle: .default)
        levelProgressView.progressTintColor = UIColor.white
        levelProgressView.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        levelProgressView.progress = 0.3
        levelProgressView.layer.cornerRadius = 2
        levelProgressView.clipsToBounds = true
        
        headerContainer.addSubview(weatherContainer)
        headerContainer.addSubview(welcomeMessageLabel)
        headerContainer.addSubview(playerNameLabel)
        headerContainer.addSubview(currentLevelLabel)
        headerContainer.addSubview(levelProgressView)
        
        // Layout constraints
        weatherContainer.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        currentLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            headerContainer.heightAnchor.constraint(equalToConstant: 140),
            
            weatherContainer.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 10),
            weatherContainer.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -10),
            weatherContainer.widthAnchor.constraint(equalToConstant: 120),
            weatherContainer.heightAnchor.constraint(equalToConstant: 40),
            
            weatherIcon.leadingAnchor.constraint(equalTo: weatherContainer.leadingAnchor, constant: 8),
            weatherIcon.centerYAnchor.constraint(equalTo: weatherContainer.centerYAnchor),
            
            weatherLabel.leadingAnchor.constraint(equalTo: weatherIcon.trailingAnchor, constant: 4),
            weatherLabel.trailingAnchor.constraint(equalTo: weatherContainer.trailingAnchor, constant: -8),
            weatherLabel.centerYAnchor.constraint(equalTo: weatherContainer.centerYAnchor),
            
            welcomeMessageLabel.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 15),
            welcomeMessageLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 15),
            
            playerNameLabel.topAnchor.constraint(equalTo: welcomeMessageLabel.bottomAnchor, constant: 5),
            playerNameLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 15),
            
            currentLevelLabel.topAnchor.constraint(equalTo: playerNameLabel.bottomAnchor, constant: 10),
            currentLevelLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 15),
            
            levelProgressView.topAnchor.constraint(equalTo: currentLevelLabel.bottomAnchor, constant: 5),
            levelProgressView.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 15),
            levelProgressView.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -15),
            levelProgressView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    
    private func setupStatsCard() {
        statsCardView = UIView()
        statsCardView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        statsCardView.layer.cornerRadius = 20
        statsCardView.layer.shadowColor = UIColor.black.cgColor
        statsCardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        statsCardView.layer.shadowRadius = 8
        statsCardView.layer.shadowOpacity = 0.1
        
        let statsTitle = UILabel()
        statsTitle.text = "Your Progress"
        statsTitle.textColor = .white
        statsTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        statsTitle.textAlignment = .center
        
        // Stats stack view
        let statsStackView = UIStackView()
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.spacing = 10
        
        // Individual stat containers
        let gamesPlayedContainer = createStatContainer(title: "Games Played", value: "0")
        gamesPlayedLabel = gamesPlayedContainer.subviews.last as? UILabel
        
        let bestTimeContainer = createStatContainer(title: "Best Time", value: "--:--")
        bestTimeLabel = bestTimeContainer.subviews.last as? UILabel
        
        let streakContainer = createStatContainer(title: "Streak", value: "0")
        streakLabel = streakContainer.subviews.last as? UILabel
        
        statsStackView.addArrangedSubview(gamesPlayedContainer)
        statsStackView.addArrangedSubview(bestTimeContainer)
        statsStackView.addArrangedSubview(streakContainer)
        
        // Last played info
        lastPlayedLabel = UILabel()
        lastPlayedLabel.text = "Start your first game!"
        lastPlayedLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        lastPlayedLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        lastPlayedLabel.textAlignment = .center
        
        statsCardView.addSubview(statsTitle)
        statsCardView.addSubview(statsStackView)
        statsCardView.addSubview(lastPlayedLabel)
        
        view.addSubview(statsCardView)
        
        statsTitle.translatesAutoresizingMaskIntoConstraints = false
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        lastPlayedLabel.translatesAutoresizingMaskIntoConstraints = false
        statsCardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statsCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 170),
            statsCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statsCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statsCardView.heightAnchor.constraint(equalToConstant: 120),
            
            statsTitle.topAnchor.constraint(equalTo: statsCardView.topAnchor, constant: 15),
            statsTitle.centerXAnchor.constraint(equalTo: statsCardView.centerXAnchor),
            
            statsStackView.topAnchor.constraint(equalTo: statsTitle.bottomAnchor, constant: 15),
            statsStackView.leadingAnchor.constraint(equalTo: statsCardView.leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: statsCardView.trailingAnchor, constant: -20),
            statsStackView.heightAnchor.constraint(equalToConstant: 50),
            
            lastPlayedLabel.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 10),
            lastPlayedLabel.centerXAnchor.constraint(equalTo: statsCardView.centerXAnchor)
        ])
    }
    
    private func createStatContainer(title: String, value: String) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        container.layer.cornerRadius = 12
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        titleLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textColor = .white
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        valueLabel.textAlignment = .center
        
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            valueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 5),
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5),
            valueLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5)
        ])
        
        return container
    }
    
    private func setupGameTitle() {
        let titleContainer = UIView()
        titleContainer.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        titleContainer.layer.cornerRadius = 25
        
        let titleLabel = UILabel()
        titleLabel.text = "Flow Free Mini"
        titleLabel.font = UIFont(name: "Chalkduster", size: 36)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowRadius = 4
        titleLabel.layer.shadowOpacity = 0.3
        titleLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Connect the dots, flow the colors"
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        subtitleLabel.textAlignment = .center
        
        titleContainer.addSubview(titleLabel)
        titleContainer.addSubview(subtitleLabel)
        view.addSubview(titleContainer)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleContainer.topAnchor.constraint(equalTo: statsCardView.bottomAnchor, constant: 20),
            titleContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleContainer.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.centerXAnchor.constraint(equalTo: titleContainer.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 10),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: titleContainer.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        ])
    }
    
    private func setupMenuButtons() {
        let buttonsContainer = UIView()
        buttonsContainer.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        buttonsContainer.layer.cornerRadius = 20
        
        let buttonsGrid = UIStackView()
        buttonsGrid.axis = .vertical
        buttonsGrid.spacing = 15
        buttonsGrid.distribution = .fillEqually
        
        // First row
        let firstRow = UIStackView()
        firstRow.axis = .horizontal
        firstRow.spacing = 15
        firstRow.distribution = .fillEqually
        
        let playButton = createModernMenuButton(title: "Play Game", emoji: "🎮", color: UIColor(hex: "#4CAF50"))
        playButton.addTarget(self, action: #selector(playGameTapped), for: .touchUpInside)
        
        let tutorialButton = createModernMenuButton(title: "Tutorial", emoji: "📚", color: UIColor(hex: "#2196F3"))
        tutorialButton.addTarget(self, action: #selector(tutorialTapped), for: .touchUpInside)
        
        firstRow.addArrangedSubview(playButton)
        firstRow.addArrangedSubview(tutorialButton)
        
        // Second row
        let secondRow = UIStackView()
        secondRow.axis = .horizontal
        secondRow.spacing = 15
        secondRow.distribution = .fillEqually
        
        let leaderboardButton = createModernMenuButton(title: "Leaderboard", emoji: "🏆", color: UIColor(hex: "#FF9800"))
        leaderboardButton.addTarget(self, action: #selector(leaderboardTapped), for: .touchUpInside)
        
        let settingsButton = createModernMenuButton(title: "Settings", emoji: "⚙️", color: UIColor(hex: "#9C27B0"))
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        
        secondRow.addArrangedSubview(leaderboardButton)
        secondRow.addArrangedSubview(settingsButton)
        
        buttonsGrid.addArrangedSubview(firstRow)
        buttonsGrid.addArrangedSubview(secondRow)
        
        buttonsContainer.addSubview(buttonsGrid)
        view.addSubview(buttonsContainer)
        
        buttonsGrid.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonsContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 450),
            buttonsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsContainer.heightAnchor.constraint(equalToConstant: 160),
            
            buttonsGrid.topAnchor.constraint(equalTo: buttonsContainer.topAnchor, constant: 20),
            buttonsGrid.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor, constant: 20),
            buttonsGrid.trailingAnchor.constraint(equalTo: buttonsContainer.trailingAnchor, constant: -20),
            buttonsGrid.bottomAnchor.constraint(equalTo: buttonsContainer.bottomAnchor, constant: -20)
        ])
    }
    
    private func createModernMenuButton(title: String, emoji: String, color: UIColor) -> UIButton {
        let button = UIButton()
        
        let emojiLabel = UILabel()
        emojiLabel.text = emoji
        emojiLabel.font = UIFont.systemFont(ofSize: 24)
        emojiLabel.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        button.backgroundColor = color.withAlphaComponent(0.8)
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        
        button.addSubview(emojiLabel)
        button.addSubview(titleLabel)
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            emojiLabel.topAnchor.constraint(equalTo: button.topAnchor, constant: 15),
            
            titleLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -10)
        ])
        
        return button
    }
    
    private func setupFooterSection() {
        let footerContainer = UIView()
        footerContainer.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        footerContainer.layer.cornerRadius = 15
        
        // Daily tip with rotating tips
        let tipIcon = UILabel()
        tipIcon.text = "💡"
        tipIcon.font = UIFont.systemFont(ofSize: 20)
        
        let tipLabel = UILabel()
        tipLabel.text = getDailyTip()
        tipLabel.textColor = .white
        tipLabel.textAlignment = .left
        tipLabel.numberOfLines = 2
        tipLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        
        // Quick stats footer
        let quickStatsLabel = UILabel()
        quickStatsLabel.text = "Ready to challenge yourself?"
        quickStatsLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        quickStatsLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        quickStatsLabel.textAlignment = .center
        
        footerContainer.addSubview(tipIcon)
        footerContainer.addSubview(tipLabel)
        footerContainer.addSubview(quickStatsLabel)
        view.addSubview(footerContainer)
        
        tipIcon.translatesAutoresizingMaskIntoConstraints = false
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        quickStatsLabel.translatesAutoresizingMaskIntoConstraints = false
        footerContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            footerContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            footerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            footerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            footerContainer.heightAnchor.constraint(equalToConstant: 80),
            
            tipIcon.leadingAnchor.constraint(equalTo: footerContainer.leadingAnchor, constant: 15),
            tipIcon.topAnchor.constraint(equalTo: footerContainer.topAnchor, constant: 15),
            
            tipLabel.leadingAnchor.constraint(equalTo: tipIcon.trailingAnchor, constant: 10),
            tipLabel.trailingAnchor.constraint(equalTo: footerContainer.trailingAnchor, constant: -15),
            tipLabel.topAnchor.constraint(equalTo: footerContainer.topAnchor, constant: 15),
            
            quickStatsLabel.bottomAnchor.constraint(equalTo: footerContainer.bottomAnchor, constant: -10),
            quickStatsLabel.centerXAnchor.constraint(equalTo: footerContainer.centerXAnchor)
        ])
    }
    
    private func getDailyTip() -> String {
        let tips = [
            "Complete levels faster to earn bonus points!",
            "Try to solve puzzles with minimum moves",
            "Look for patterns to solve complex levels",
            "Take breaks to keep your mind fresh",
            "Challenge friends to beat your records!"
        ]
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return tips[dayOfYear % tips.count]
    }
    
    private func loadPlayerStats() {
        // Load stats from UserDefaults
        let gamesPlayed = UserDefaults.standard.integer(forKey: "gamesPlayed")
        let bestTime = UserDefaults.standard.string(forKey: "bestTime") ?? "--:--"
        let streak = UserDefaults.standard.integer(forKey: "currentStreak")
        let currentLevel = UserDefaults.standard.integer(forKey: "currentLevel")
        let levelProgress = UserDefaults.standard.float(forKey: "levelProgress")
        
        gamesPlayedLabel.text = "\(gamesPlayed)"
        bestTimeLabel.text = bestTime
        streakLabel.text = "\(streak)"
        currentLevelLabel.text = "Level \(max(1, currentLevel))"
        levelProgressView.progress = max(0.1, levelProgress)
        
        if let lastPlayed = UserDefaults.standard.object(forKey: "lastPlayed") as? Date {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            lastPlayedLabel.text = "Last played: \(formatter.string(from: lastPlayed))"
        }
    }
    
    private func updatePlayerStats() {
        loadPlayerStats()
    }
    
    private func startWelcomeAnimation() {
        // Animate welcome message
        welcomeMessageLabel.alpha = 0
        playerNameLabel.transform = CGAffineTransform(translationX: -50, y: 0)
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseOut) {
            self.welcomeMessageLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.7, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.playerNameLabel.transform = .identity
        }
        
        // Animate stats card
        statsCardView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        statsCardView.alpha = 0
        
        UIView.animate(withDuration: 0.6, delay: 1.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveEaseOut) {
            self.statsCardView.transform = .identity
            self.statsCardView.alpha = 1
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupPlayerName() {
        if let name = UserDefaults.standard.string(forKey: "playerName") {
            playerNameLabel.text = name
        } else {
            showNameInputAlert()
        }
    }
    
    private func showNameInputAlert() {
        let alert = UIAlertController(title: "Enter Your Name", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Player Name"
        }
        
        let submitAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let name = alert.textFields?.first?.text, !name.isEmpty else { return }
            self?.playerNameLabel.text = name
            UserDefaults.standard.set(name, forKey: "playerName")
        }
        
        alert.addAction(submitAction)
        present(alert, animated: true)
    }
    
    @objc private func playGameTapped() {
        let levelsVC = LevelsViewController()
        navigationController?.pushViewController(levelsVC, animated: true)
    }
    
    @objc private func tutorialTapped() {
        let tutorialVC = TutorialViewController()
        navigationController?.pushViewController(tutorialVC, animated: true)
    }
    
    @objc private func leaderboardTapped() {
        let leaderboardVC = LeaderboardViewController()
        navigationController?.pushViewController(leaderboardVC, animated: true)
    }
    
    @objc private func settingsTapped() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Simulate weather data (in a real app, you'd call a weather API)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let temperature = Int.random(in: 15...30)
            let conditions = ["Sunny", "Cloudy", "Rainy", "Clear"].randomElement() ?? "Sunny"
            self.weatherLabel.text = "\(conditions) • \(temperature)°C"
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        weatherLabel.text = "Weather: Location unavailable"
    }
}

// Extension for UIColor hex support
extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            alpha: Double(a) / 255
        )
    }
}