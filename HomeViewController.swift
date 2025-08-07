import UIKit
import CoreLocation

class HomeViewController: BaseViewController {
    
    private let locationManager = CLLocationManager()
    private var weatherLabel: UILabel!
    private var playerNameLabel: UILabel!
    private var scoreLabel: UILabel!
    private var levelLabel: UILabel!
    private var streakLabel: UILabel!
    private var playTimeLabel: UILabel!
    private var animatedIconView: UIView!
    private var pulseAnimation: CABasicAnimation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationManager()
        setupPlayerName()
        setupAnimations()
        loadPlayerStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startPulseAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopPulseAnimation()
    }
    
    private func setupUI() {
        // Dynamic gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(hex: "#667eea").cgColor,
            UIColor(hex: "#764ba2").cgColor,
            UIColor(hex: "#f093fb").cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        setupHeaderSection()
        setupStatsCards()
        setupGameSection()
        setupMenuButtons()
        setupFloatingElements()
    }
    
    private func setupHeaderSection() {
        // Header container
        let headerContainer = UIView()
        headerContainer.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        headerContainer.layer.cornerRadius = 20
        headerContainer.layer.masksToBounds = true
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerContainer)
        
        // Add blur effect to header
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(blurView)
        
        // Weather container
        let weatherContainer = UIView()
        weatherContainer.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        weatherContainer.layer.cornerRadius = 15
        weatherContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(weatherContainer)
        
        weatherLabel = UILabel()
        weatherLabel.text = "Fetching weather..."
        weatherLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        weatherLabel.textColor = .white
        weatherLabel.textAlignment = .center
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherContainer.addSubview(weatherLabel)
        
        // Player section
        let playerContainer = UIView()
        playerContainer.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        playerContainer.layer.cornerRadius = 15
        playerContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(playerContainer)
        
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome back,"
        welcomeLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        welcomeLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        playerContainer.addSubview(welcomeLabel)
        
        playerNameLabel = UILabel()
        playerNameLabel.text = "Player"
        playerNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        playerNameLabel.textColor = .white
        playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        playerContainer.addSubview(playerNameLabel)
        
        let changeNameButton = UIButton(type: .system)
        changeNameButton.setTitle("✏️ Edit", for: .normal)
        changeNameButton.setTitleColor(.white, for: .normal)
        changeNameButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        changeNameButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        changeNameButton.layer.cornerRadius = 8
        changeNameButton.addTarget(self, action: #selector(changeNameTapped), for: .touchUpInside)
        changeNameButton.translatesAutoresizingMaskIntoConstraints = false
        playerContainer.addSubview(changeNameButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            headerContainer.heightAnchor.constraint(equalToConstant: 80),
            
            blurView.topAnchor.constraint(equalTo: headerContainer.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            
            weatherContainer.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 10),
            weatherContainer.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -10),
            weatherContainer.widthAnchor.constraint(equalToConstant: 120),
            weatherContainer.heightAnchor.constraint(equalToConstant: 30),
            
            weatherLabel.centerXAnchor.constraint(equalTo: weatherContainer.centerXAnchor),
            weatherLabel.centerYAnchor.constraint(equalTo: weatherContainer.centerYAnchor),
            
            playerContainer.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 10),
            playerContainer.trailingAnchor.constraint(equalTo: weatherContainer.leadingAnchor, constant: -10),
            playerContainer.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 10),
            playerContainer.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -10),
            
            welcomeLabel.topAnchor.constraint(equalTo: playerContainer.topAnchor, constant: 8),
            welcomeLabel.leadingAnchor.constraint(equalTo: playerContainer.leadingAnchor, constant: 12),
            
            playerNameLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 2),
            playerNameLabel.leadingAnchor.constraint(equalTo: playerContainer.leadingAnchor, constant: 12),
            
            changeNameButton.centerYAnchor.constraint(equalTo: playerContainer.centerYAnchor),
            changeNameButton.trailingAnchor.constraint(equalTo: playerContainer.trailingAnchor, constant: -10),
            changeNameButton.widthAnchor.constraint(equalToConstant: 60),
            changeNameButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setupStatsCards() {
        // Stats container
        let statsContainer = UIView()
        statsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statsContainer)
        
        // Individual stat cards
        let scoreCard = createStatCard(title: "Best Score", value: "0", icon: "🏆", color: UIColor(hex: "#ff6b6b"))
        let levelCard = createStatCard(title: "Level", value: "1", icon: "🎯", color: UIColor(hex: "#4ecdc4"))
        let streakCard = createStatCard(title: "Win Streak", value: "0", icon: "🔥", color: UIColor(hex: "#45b7d1"))
        let timeCard = createStatCard(title: "Play Time", value: "0h", icon: "⏰", color: UIColor(hex: "#f9ca24"))
        
        scoreLabel = scoreCard.viewWithTag(100) as? UILabel
        levelLabel = levelCard.viewWithTag(100) as? UILabel
        streakLabel = streakCard.viewWithTag(100) as? UILabel
        playTimeLabel = timeCard.viewWithTag(100) as? UILabel
        
        // Stats stack
        let topStack = UIStackView(arrangedSubviews: [scoreCard, levelCard])
        topStack.axis = .horizontal
        topStack.distribution = .fillEqually
        topStack.spacing = 10
        
        let bottomStack = UIStackView(arrangedSubviews: [streakCard, timeCard])
        bottomStack.axis = .horizontal
        bottomStack.distribution = .fillEqually
        bottomStack.spacing = 10
        
        let statsStack = UIStackView(arrangedSubviews: [topStack, bottomStack])
        statsStack.axis = .vertical
        statsStack.spacing = 10
        statsStack.translatesAutoresizingMaskIntoConstraints = false
        statsContainer.addSubview(statsStack)
        
        NSLayoutConstraint.activate([
            statsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110),
            statsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statsContainer.heightAnchor.constraint(equalToConstant: 120),
            
            statsStack.topAnchor.constraint(equalTo: statsContainer.topAnchor),
            statsStack.leadingAnchor.constraint(equalTo: statsContainer.leadingAnchor),
            statsStack.trailingAnchor.constraint(equalTo: statsContainer.trailingAnchor),
            statsStack.bottomAnchor.constraint(equalTo: statsContainer.bottomAnchor)
        ])
    }
    
    private func createStatCard(title: String, value: String, icon: String, color: UIColor) -> UIView {
        let card = UIView()
        card.backgroundColor = color.withAlphaComponent(0.8)
        card.layer.cornerRadius = 15
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 4)
        card.layer.shadowRadius = 8
        card.layer.shadowOpacity = 0.2
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 20)
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(iconLabel)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.boldSystemFont(ofSize: 16)
        valueLabel.textColor = .white
        valueLabel.textAlignment = .center
        valueLabel.tag = 100 // For easy reference
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(valueLabel)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 8),
            iconLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            
            valueLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -6),
            titleLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor)
        ])
        
        return card
    }
    
    private func setupGameSection() {
        // Game title container
        let titleContainer = UIView()
        titleContainer.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        titleContainer.layer.cornerRadius = 25
        titleContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleContainer)
        
        // Animated icon
        animatedIconView = UIView()
        animatedIconView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        animatedIconView.layer.cornerRadius = 20
        animatedIconView.translatesAutoresizingMaskIntoConstraints = false
        titleContainer.addSubview(animatedIconView)
        
        let iconLabel = UILabel()
        iconLabel.text = "🎮"
        iconLabel.font = UIFont.systemFont(ofSize: 24)
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        animatedIconView.addSubview(iconLabel)
        
        // Game title
        let titleLabel = UILabel()
        titleLabel.text = "Chase Grid"
        titleLabel.font = UIFont(name: "Avenir-Black", size: 32) ?? UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleContainer.addSubview(titleLabel)
        
        // Subtitle
        let subtitleLabel = UILabel()
        subtitleLabel.text = "The Ultimate Reflex Challenge"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleContainer.addSubview(subtitleLabel)
        
        // Game tip with modern styling
        let tipContainer = UIView()
        tipContainer.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        tipContainer.layer.cornerRadius = 15
        tipContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tipContainer)
        
        let tipIcon = UILabel()
        tipIcon.text = "💡"
        tipIcon.font = UIFont.systemFont(ofSize: 16)
        tipIcon.translatesAutoresizingMaskIntoConstraints = false
        tipContainer.addSubview(tipIcon)
        
        let tipLabel = UILabel()
        tipLabel.text = "Pro Tip: Quick reflexes and pattern recognition are your best friends!"
        tipLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        tipLabel.textColor = .white
        tipLabel.numberOfLines = 0
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        tipContainer.addSubview(tipLabel)
        
        NSLayoutConstraint.activate([
            titleContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
            titleContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleContainer.heightAnchor.constraint(equalToConstant: 100),
            
            animatedIconView.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 20),
            animatedIconView.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor),
            animatedIconView.widthAnchor.constraint(equalToConstant: 40),
            animatedIconView.heightAnchor.constraint(equalToConstant: 40),
            
            iconLabel.centerXAnchor.constraint(equalTo: animatedIconView.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: animatedIconView.centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: titleContainer.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 20),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: titleContainer.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            
            tipContainer.topAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: 15),
            tipContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tipContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tipContainer.heightAnchor.constraint(equalToConstant: 50),
            
            tipIcon.leadingAnchor.constraint(equalTo: tipContainer.leadingAnchor, constant: 15),
            tipIcon.centerYAnchor.constraint(equalTo: tipContainer.centerYAnchor),
            
            tipLabel.leadingAnchor.constraint(equalTo: tipIcon.trailingAnchor, constant: 10),
            tipLabel.trailingAnchor.constraint(equalTo: tipContainer.trailingAnchor, constant: -15),
            tipLabel.centerYAnchor.constraint(equalTo: tipContainer.centerYAnchor)
        ])
    }
    
    private func setupMenuButtons() {
        // Create buttons with new styling
        let playButton = createModernMenuButton(title: "🚀 Start Playing", subtitle: "Begin your adventure", action: #selector(playTapped), isPrimary: true)
        let tutorialButton = createModernMenuButton(title: "📚 How to Play", subtitle: "Learn the basics", action: #selector(tutorialTapped))
        let leaderboardButton = createModernMenuButton(title: "🏆 Leaderboard", subtitle: "See top players", action: #selector(leaderboardTapped))
        let settingsButton = createModernMenuButton(title: "⚙️ Settings", subtitle: "Customize your game", action: #selector(settingsTapped))
        
        // Button stack with improved layout
        let buttonStack = UIStackView(arrangedSubviews: [playButton, tutorialButton, leaderboardButton, settingsButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonStack.heightAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    private func createModernMenuButton(title: String, subtitle: String = "", action: Selector, isPrimary: Bool = false) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = isPrimary ? 
            UIColor.white.withAlphaComponent(0.25) : 
            UIColor.white.withAlphaComponent(0.15)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = isPrimary ? 2 : 1
        button.layer.borderColor = UIColor.white.withAlphaComponent(isPrimary ? 0.6 : 0.3).cgColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        
        // Create attributed title
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: isPrimary ? 18 : 16)
        ]
        
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.7),
            .font: UIFont.systemFont(ofSize: 12)
        ]
        
        let attributedTitle = NSMutableAttributedString(string: title, attributes: titleAttributes)
        if !subtitle.isEmpty {
            attributedTitle.append(NSAttributedString(string: "\n\(subtitle)", attributes: subtitleAttributes))
        }
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: action, for: .touchUpInside)
        
        // Add hover effect
        button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        return button
    }
    
    private func setupFloatingElements() {
        // Add some floating decorative elements
        for i in 0..<5 {
            let floatingView = UIView()
            floatingView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            floatingView.layer.cornerRadius = CGFloat.random(in: 5...15)
            floatingView.translatesAutoresizingMaskIntoConstraints = false
            view.insertSubview(floatingView, at: 1)
            
            let size = CGFloat.random(in: 10...30)
            let xPosition = CGFloat.random(in: 0...view.bounds.width)
            let yPosition = CGFloat.random(in: 100...view.bounds.height - 200)
            
            NSLayoutConstraint.activate([
                floatingView.widthAnchor.constraint(equalToConstant: size),
                floatingView.heightAnchor.constraint(equalToConstant: size),
                floatingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xPosition),
                floatingView.topAnchor.constraint(equalTo: view.topAnchor, constant: yPosition)
            ])
            
            // Add floating animation
            let animation = CABasicAnimation(keyPath: "transform.translation.y")
            animation.fromValue = 0
            animation.toValue = -20
            animation.duration = Double.random(in: 2...4)
            animation.repeatCount = .infinity
            animation.autoreverses = true
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            floatingView.layer.add(animation, forKey: "float_\(i)")
        }
    }
    
    private func setupAnimations() {
        // Setup pulse animation for the game icon
        pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.1
        pulseAnimation.duration = 1.5
        pulseAnimation.repeatCount = .infinity
        pulseAnimation.autoreverses = true
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    }
    
    private func startPulseAnimation() {
        animatedIconView?.layer.add(pulseAnimation, forKey: "pulse")
    }
    
    private func stopPulseAnimation() {
        animatedIconView?.layer.removeAnimation(forKey: "pulse")
    }
    
    private func loadPlayerStats() {
        // Load and display player statistics
        // This would typically come from your game data storage
        scoreLabel?.text = "1250"
        levelLabel?.text = "7"
        streakLabel?.text = "3"
        playTimeLabel?.text = "2h"
    }
    
    @objc private func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            sender.alpha = 0.8
        }
    }
    
    @objc private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
            sender.alpha = 1.0
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupPlayerName() {
        if let name = LocalStorage.shared.getPlayerName() {
            playerNameLabel.text = name
        }
    }
    
    @objc private func changeNameTapped() {
        let alert = UIAlertController(title: "Change Name", message: "Enter your player name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Player name"
            textField.text = self.playerNameLabel.text
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            if let textField = alert.textFields?.first, let name = textField.text, !name.isEmpty {
                self.playerNameLabel.text = name
                LocalStorage.shared.savePlayerName(name)
            }
        })
        
        present(alert, animated: true)
    }
    
    @objc private func playTapped() {
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
        
        // In a real app, you would call a weather API here
        // For demo purposes, we'll just show a mock weather
        weatherLabel.text = "☀️ 24°C"
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        weatherLabel.text = "🌤️ --°C"
    }
}

// MARK: - UIColor Extension
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