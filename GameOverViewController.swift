import UIKit

class GameOverViewController: BaseViewController {
    var score: Int = 0
    var level: Int = 1
    var didWin: Bool = false
    
    // MARK: - Background Elements
    private lazy var backgroundGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = didWin ? 
            [UIColor.systemGreen.cgColor, UIColor.systemTeal.cgColor] :
            [UIColor.systemRed.cgColor, UIColor.systemOrange.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }()
    
    private lazy var floatingParticles: [UIView] = {
        var particles: [UIView] = []
        for _ in 0..<15 {
            let particle = UIView()
            particle.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            particle.layer.cornerRadius = CGFloat.random(in: 2...8)
            particles.append(particle)
        }
        return particles
    }()
    
    // MARK: - Header Section
    private lazy var headerContainer: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        container.layer.cornerRadius = 20
        container.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return container
    }()
    
    private lazy var statusIcon: UILabel = {
        let label = UILabel()
        label.text = didWin ? "🎉" : "💫"
        label.font = UIFont.systemFont(ofSize: 60)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = didWin ? "VICTORY!" : "GAME OVER"
        label.font = UIFont.systemFont(ofSize: 28, weight: .black)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.5
        label.layer.shadowRadius = 4
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = didWin ? "Outstanding performance!" : "Don't give up, try again!"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Stats Cards
    private lazy var statsContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 15
        return stack
    }()
    
    private lazy var scoreCard: UIView = {
        return createStatCard(
            title: "SCORE",
            value: "\(score)",
            icon: "🎯",
            color: .systemBlue
        )
    }()
    
    private lazy var levelCard: UIView = {
        return createStatCard(
            title: "LEVEL",
            value: "\(level)",
            icon: "⭐",
            color: .systemYellow
        )
    }()
    
    private lazy var accuracyCard: UIView = {
        let accuracy = min(100, max(0, (score * 100) / max(1, level * 50)))
        return createStatCard(
            title: "ACCURACY",
            value: "\(accuracy)%",
            icon: "🎪",
            color: .systemPurple
        )
    }()
    
    // MARK: - Achievement Section
    private lazy var achievementBanner: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        container.layer.cornerRadius = 15
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        let achievementLabel = UILabel()
        achievementLabel.text = getAchievementText()
        achievementLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        achievementLabel.textColor = .white
        achievementLabel.textAlignment = .center
        achievementLabel.numberOfLines = 2
        achievementLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(achievementLabel)
        
        NSLayoutConstraint.activate([
            achievementLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 15),
            achievementLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            achievementLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            achievementLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -15)
        ])
        
        return container
    }()
    
    // MARK: - Action Buttons
    private lazy var primaryButton: UIButton = {
        let button = createActionButton(
            title: "🔄 PLAY AGAIN",
            backgroundColor: .systemGreen,
            action: #selector(replayTapped)
        )
        return button
    }()
    
    private lazy var secondaryButtonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 15
        return stack
    }()
    
    private lazy var homeButton: UIButton = {
        let button = createActionButton(
            title: "🏠 HOME",
            backgroundColor: .systemGray,
            action: #selector(homeTapped)
        )
        return button
    }()
    
    private lazy var leaderboardButton: UIButton = {
        let button = createActionButton(
            title: "🏆 RANKINGS",
            backgroundColor: .systemIndigo,
            action: #selector(leaderboardTapped)
        )
        return button
    }()
    
    // MARK: - Progress Indicator
    private lazy var progressContainer: UIView = {
        let container = UIView()
        
        let progressLabel = UILabel()
        progressLabel.text = "Next Level Progress"
        progressLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        progressLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        progressLabel.textAlignment = .center
        
        let progressBar = UIView()
        progressBar.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        progressBar.layer.cornerRadius = 4
        
        let progressFill = UIView()
        let progress = CGFloat(score % 100) / 100.0
        progressFill.backgroundColor = .systemCyan
        progressFill.layer.cornerRadius = 4
        
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressFill.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(progressLabel)
        container.addSubview(progressBar)
        progressBar.addSubview(progressFill)
        
        NSLayoutConstraint.activate([
            progressLabel.topAnchor.constraint(equalTo: container.topAnchor),
            progressLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            progressLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            progressBar.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 8),
            progressBar.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 8),
            progressBar.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            
            progressFill.topAnchor.constraint(equalTo: progressBar.topAnchor),
            progressFill.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor),
            progressFill.bottomAnchor.constraint(equalTo: progressBar.bottomAnchor),
            progressFill.widthAnchor.constraint(equalTo: progressBar.widthAnchor, multiplier: progress)
        ])
        
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupUI()
        animateEntrance()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
        layoutFloatingParticles()
    }
    
    // MARK: - Setup Methods
    private func setupBackground() {
        view.layer.insertSublayer(backgroundGradient, at: 0)
        
        for particle in floatingParticles {
            view.addSubview(particle)
        }
        
        animateParticles()
    }
    
    private func setupUI() {
        // Header setup
        let headerStack = UIStackView(arrangedSubviews: [statusIcon, titleLabel, subtitleLabel])
        headerStack.axis = .vertical
        headerStack.spacing = 8
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        headerContainer.addSubview(headerStack)
        
        // Stats setup
        statsContainer.addArrangedSubview(scoreCard)
        statsContainer.addArrangedSubview(levelCard)
        statsContainer.addArrangedSubview(accuracyCard)
        
        // Secondary buttons setup
        secondaryButtonsStack.addArrangedSubview(homeButton)
        secondaryButtonsStack.addArrangedSubview(leaderboardButton)
        
        // Main layout
        let mainStack = UIStackView(arrangedSubviews: [
            headerContainer,
            statsContainer,
            achievementBanner,
            progressContainer,
            primaryButton,
            secondaryButtonsStack
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 25
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            // Header constraints
            headerStack.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 30),
            headerStack.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 20),
            headerStack.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -20),
            headerStack.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -30),
            
            // Main stack constraints
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            // Component height constraints
            headerContainer.heightAnchor.constraint(equalToConstant: 160),
            statsContainer.heightAnchor.constraint(equalToConstant: 100),
            achievementBanner.heightAnchor.constraint(equalToConstant: 60),
            progressContainer.heightAnchor.constraint(equalToConstant: 35),
            primaryButton.heightAnchor.constraint(equalToConstant: 55),
            secondaryButtonsStack.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    // MARK: - Helper Methods
    private func createStatCard(title: String, value: String, icon: String, color: UIColor) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        container.layer.cornerRadius = 15
        container.layer.borderWidth = 2
        container.layer.borderColor = color.withAlphaComponent(0.6).cgColor
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 24)
        iconLabel.textAlignment = .center
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        valueLabel.textColor = .white
        valueLabel.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        titleLabel.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [iconLabel, valueLabel, titleLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        return container
    }
    
    private func createActionButton(title: String, backgroundColor: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 8
        button.addTarget(self, action: action, for: .touchUpInside)
        
        // Add press animation
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleased(_:)), for: [.touchUpInside, .touchUpOutside])
        
        return button
    }
    
    private func getAchievementText() -> String {
        if didWin {
            if score > 500 {
                return "🌟 MASTER ACHIEVEMENT\nIncredible performance!"
            } else if score > 300 {
                return "🎖️ EXPERT LEVEL\nGreat job!"
            } else {
                return "🏅 WELL DONE\nKeep improving!"
            }
        } else {
            if level > 5 {
                return "💪 PERSISTENT PLAYER\nYou've made it far!"
            } else {
                return "🎯 KEEP PRACTICING\nYou'll get better!"
            }
        }
    }
    
    // MARK: - Animation Methods
    private func animateEntrance() {
        view.alpha = 0
        view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.view.alpha = 1
            self.view.transform = .identity
        })
        
        // Animate stats cards with delay
        for (index, card) in [scoreCard, levelCard, accuracyCard].enumerated() {
            card.transform = CGAffineTransform(translationX: 0, y: 50)
            card.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0.2 + Double(index) * 0.1, options: .curveEaseOut, animations: {
                card.transform = .identity
                card.alpha = 1
            })
        }
    }
    
    private func layoutFloatingParticles() {
        for particle in floatingParticles {
            let size = particle.layer.cornerRadius * 2
            particle.frame = CGRect(
                x: CGFloat.random(in: 0...view.bounds.width - size),
                y: CGFloat.random(in: 0...view.bounds.height - size),
                width: size,
                height: size
            )
        }
    }
    
    private func animateParticles() {
        for particle in floatingParticles {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = Double.random(in: 3...8)
            animation.repeatCount = .infinity
            animation.autoreverses = true
            
            let currentPosition = particle.layer.position
            let newX = CGFloat.random(in: 0...view.bounds.width)
            let newY = CGFloat.random(in: 0...view.bounds.height)
            
            animation.fromValue = NSValue(cgPoint: currentPosition)
            animation.toValue = NSValue(cgPoint: CGPoint(x: newX, y: newY))
            
            particle.layer.add(animation, forKey: "floating")
        }
    }
    
    // MARK: - Button Actions
    @objc private func buttonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func buttonReleased(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
        }
    }
    
    @objc private func replayTapped() {
        if let gameVC = navigationController?.viewControllers.first(where: { $0 is GameViewController }) as? GameViewController {
            gameVC.startGame()
            navigationController?.popToViewController(gameVC, animated: true)
        }
    }
    
    @objc private func homeTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func leaderboardTapped() {
        let leaderboardVC = LeaderboardViewController()
        navigationController?.pushViewController(leaderboardVC, animated: true)
    }
}