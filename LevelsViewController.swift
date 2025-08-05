import UIKit

class LevelsViewController: BaseViewController {
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#1A1A2E")
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose Your Challenge"
        label.font = UIFont.systemFont(ofSize: 32, weight: .black)
        label.textColor = UIColor(hex: "#FFFFFF")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Master each level to unlock the next"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(hex: "#B8B8D1")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#16213E")
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "Progress"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressBar: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.trackTintColor = UIColor(hex: "#2A2A3E")
        progress.progressTintColor = UIColor(hex: "#00D4AA")
        progress.layer.cornerRadius = 4
        progress.clipsToBounds = true
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private let progressPercentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(hex: "#00D4AA")
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let levelsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let levels = GameData.shared.getLevels()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        setupStats()
        updateProgress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProgress()
        levelsCollectionView.reloadData()
    }
    
    private func setupView() {
        title = "Levels"
        view.backgroundColor = UIColor(hex: "#0F0F23")
        
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)
        
        view.addSubview(progressView)
        progressView.addSubview(progressLabel)
        progressView.addSubview(progressBar)
        progressView.addSubview(progressPercentLabel)
        
        view.addSubview(statsStackView)
        view.addSubview(levelsCollectionView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 140),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            progressView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressView.heightAnchor.constraint(equalToConstant: 80),
            
            progressLabel.topAnchor.constraint(equalTo: progressView.topAnchor, constant: 15),
            progressLabel.leadingAnchor.constraint(equalTo: progressView.leadingAnchor, constant: 20),
            
            progressPercentLabel.topAnchor.constraint(equalTo: progressView.topAnchor, constant: 15),
            progressPercentLabel.trailingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: -20),
            
            progressBar.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 15),
            progressBar.leadingAnchor.constraint(equalTo: progressView.leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: -20),
            progressBar.heightAnchor.constraint(equalToConstant: 8),
            
            statsStackView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20),
            statsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statsStackView.heightAnchor.constraint(equalToConstant: 80),
            
            levelsCollectionView.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 10),
            levelsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            levelsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            levelsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupStats() {
        let completedLevels = GameData.shared.highestUnlockedLevel - 1
        let totalLevels = levels.count
        let completionRate = totalLevels > 0 ? Double(completedLevels) / Double(totalLevels) * 100 : 0
        
        let completedCard = createStatCard(title: "Completed", value: "\(completedLevels)", subtitle: "levels", color: "#00D4AA")
        let totalCard = createStatCard(title: "Total", value: "\(totalLevels)", subtitle: "levels", color: "#6200EE")
        let rateCard = createStatCard(title: "Rate", value: "\(Int(completionRate))%", subtitle: "complete", color: "#FF6B6B")
        
        statsStackView.addArrangedSubview(completedCard)
        statsStackView.addArrangedSubview(totalCard)
        statsStackView.addArrangedSubview(rateCard)
    }
    
    private func createStatCard(title: String, value: String, subtitle: String, color: String) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor(hex: "#16213E")
        card.layer.cornerRadius = 15
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor(hex: color).withAlphaComponent(0.3).cgColor
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = UIColor(hex: "#B8B8D1")
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        valueLabel.textColor = UIColor(hex: color)
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        subtitleLabel.textColor = UIColor(hex: "#B8B8D1")
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(titleLabel)
        card.addSubview(valueLabel)
        card.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            
            valueLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            
            subtitleLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -8),
            subtitleLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor)
        ])
        
        return card
    }
    
    private func updateProgress() {
        let completedLevels = GameData.shared.highestUnlockedLevel - 1
        let totalLevels = levels.count
        let progress = totalLevels > 0 ? Float(completedLevels) / Float(totalLevels) : 0
        let percentage = Int(progress * 100)
        
        UIView.animate(withDuration: 0.5) {
            self.progressBar.setProgress(progress, animated: true)
        }
        
        progressPercentLabel.text = "\(percentage)%"
        
        // Update stats
        statsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        setupStats()
    }
    
    private func setupCollectionView() {
        levelsCollectionView.delegate = self
        levelsCollectionView.dataSource = self
        levelsCollectionView.register(LevelCell.self, forCellWithReuseIdentifier: LevelCell.identifier)
    }
}

extension LevelsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LevelCell.identifier, for: indexPath) as! LevelCell
        let isUnlocked = levels[indexPath.item].levelNumber <= GameData.shared.highestUnlockedLevel
        cell.configure(with: levels[indexPath.item], isUnlocked: isUnlocked)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 60) / 2
        return CGSize(width: width, height: width * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let level = levels[indexPath.item]
        
        // Check if level is unlocked
        if level.levelNumber <= GameData.shared.highestUnlockedLevel {
            // Add haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            let gameVC = GameViewController()
            gameVC.currentLevel = level
            navigationController?.pushViewController(gameVC, animated: true)
        } else {
            // Add error haptic feedback
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.error)
            
            showAlert(message: "Complete level \(GameData.shared.highestUnlockedLevel) first!")
        }
    }
}

class LevelCell: UICollectionViewCell {
    static let identifier = "LevelCell"
    
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let gradientLayer = CAGradientLayer()
    
    private let levelNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 36, weight: .black)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let levelTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let difficultyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let difficultyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let movesContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let blendMovesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let splitMovesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lockOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.layer.cornerRadius = 20
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lockLabel: UILabel = {
        let label = UILabel()
        label.text = "🔒"
        label.font = UIFont.systemFont(ofSize: 40)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lockMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "LOCKED"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = cardView.bounds
    }
    
    private func setupCell() {
        contentView.addSubview(cardView)
        
        cardView.addSubview(levelNumberLabel)
        cardView.addSubview(levelTitleLabel)
        cardView.addSubview(difficultyView)
        difficultyView.addSubview(difficultyLabel)
        cardView.addSubview(movesContainerView)
        movesContainerView.addSubview(blendMovesLabel)
        movesContainerView.addSubview(splitMovesLabel)
        
        cardView.addSubview(lockOverlay)
        lockOverlay.addSubview(lockLabel)
        lockOverlay.addSubview(lockMessageLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            levelNumberLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            levelNumberLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            
            levelTitleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            levelTitleLabel.topAnchor.constraint(equalTo: levelNumberLabel.bottomAnchor, constant: 5),
            
            difficultyView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            difficultyView.topAnchor.constraint(equalTo: levelTitleLabel.bottomAnchor, constant: 10),
            difficultyView.widthAnchor.constraint(equalToConstant: 60),
            difficultyView.heightAnchor.constraint(equalToConstant: 20),
            
            difficultyLabel.centerXAnchor.constraint(equalTo: difficultyView.centerXAnchor),
            difficultyLabel.centerYAnchor.constraint(equalTo: difficultyView.centerYAnchor),
            
            movesContainerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15),
            movesContainerView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -15),
            movesContainerView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            movesContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            blendMovesLabel.topAnchor.constraint(equalTo: movesContainerView.topAnchor, constant: 8),
            blendMovesLabel.centerXAnchor.constraint(equalTo: movesContainerView.centerXAnchor),
            
            splitMovesLabel.topAnchor.constraint(equalTo: blendMovesLabel.bottomAnchor, constant: 2),
            splitMovesLabel.centerXAnchor.constraint(equalTo: movesContainerView.centerXAnchor),
            
            lockOverlay.topAnchor.constraint(equalTo: cardView.topAnchor),
            lockOverlay.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            lockOverlay.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            lockOverlay.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            
            lockLabel.centerXAnchor.constraint(equalTo: lockOverlay.centerXAnchor),
            lockLabel.centerYAnchor.constraint(equalTo: lockOverlay.centerYAnchor, constant: -10),
            
            lockMessageLabel.centerXAnchor.constraint(equalTo: lockOverlay.centerXAnchor),
            lockMessageLabel.topAnchor.constraint(equalTo: lockLabel.bottomAnchor, constant: 5)
        ])
    }
    
    func configure(with level: Level, isUnlocked: Bool) {
        levelNumberLabel.text = "\(level.levelNumber)"
        levelTitleLabel.text = "LEVEL \(level.levelNumber)"
        blendMovesLabel.text = "Blend: \(level.maxBlendMoves)"
        splitMovesLabel.text = "Split: \(level.maxSplitMoves)"
        
        // Set difficulty based on level number
        let difficulty = getDifficulty(for: level.levelNumber)
        difficultyLabel.text = difficulty.0
        
        // Set gradient colors based on difficulty and unlock status
        let colors = isUnlocked ? difficulty.1 : [UIColor(hex: "#4A4A4A"), UIColor(hex: "#2A2A2A")]
        
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 20
        
        if cardView.layer.sublayers?.first != gradientLayer {
            cardView.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        // Show/hide lock overlay
        lockOverlay.isHidden = isUnlocked
        
        // Add subtle animation for unlocked levels
        if isUnlocked {
            cardView.transform = CGAffineTransform.identity
        } else {
            cardView.transform = CGAffineTransform(scaleX: 0.95, scaleY: 0.95)
        }
    }
    
    private func getDifficulty(for levelNumber: Int) -> (String, [UIColor]) {
        switch levelNumber {
        case 1...5:
            return ("EASY", [UIColor(hex: "#00D4AA"), UIColor(hex: "#00A693")])
        case 6...15:
            return ("MEDIUM", [UIColor(hex: "#6200EE"), UIColor(hex: "#4A00B8")])
        case 16...25:
            return ("HARD", [UIColor(hex: "#FF6B6B"), UIColor(hex: "#E55555")])
        default:
            return ("EXPERT", [UIColor(hex: "#FF9500"), UIColor(hex: "#E6800A")])
        }
    }
}

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