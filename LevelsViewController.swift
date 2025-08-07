import UIKit

class LevelsViewController: BaseViewController {
    
    private var collectionView: UICollectionView!
    private var headerView: UIView!
    private var filterScrollView: UIScrollView!
    private var progressView: CircularProgressView!
    private var statsStackView: UIStackView!
    private var animatedGradientLayer: CAGradientLayer!
    private var levels: [GameLevel] = []
    private var filteredLevels: [GameLevel] = []
    private var selectedFilter: LevelFilter = .all
    
    enum LevelFilter: CaseIterable {
        case all, easy, medium, hard, completed, locked
        
        var title: String {
            switch self {
            case .all: return "All"
            case .easy: return "Easy"
            case .medium: return "Medium"
            case .hard: return "Hard"
            case .completed: return "Completed"
            case .locked: return "Locked"
            }
        }
        
        var emoji: String {
            switch self {
            case .all: return "🎮"
            case .easy: return "🟢"
            case .medium: return "🟡"
            case .hard: return "🔴"
            case .completed: return "✅"
            case .locked: return "🔒"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadLevels()
        startGradientAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProgressStats()
    }
    
    private func setupUI() {
        title = "Level Selection"
        view.backgroundColor = isDarkMode ? .black : .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupAnimatedBackground()
        setupHeaderView()
        setupFilterSection()
        setupCollectionView()
        setupConstraints()
    }
    
    private func setupAnimatedBackground() {
        // Create animated gradient background
        animatedGradientLayer = CAGradientLayer()
        animatedGradientLayer.frame = view.bounds
        animatedGradientLayer.colors = [
            UIColor(hex: "#667eea").cgColor,
            UIColor(hex: "#764ba2").cgColor,
            UIColor(hex: "#f093fb").cgColor,
            UIColor(hex: "#f5576c").cgColor
        ]
        animatedGradientLayer.locations = [0.0, 0.3, 0.7, 1.0]
        animatedGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        animatedGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(animatedGradientLayer, at: 0)
        
        // Add floating particles effect
        addFloatingParticles()
    }
    
    private func addFloatingParticles() {
        for i in 0..<15 {
            let particle = UIView()
            particle.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            particle.layer.cornerRadius = CGFloat.random(in: 2...8)
            particle.frame = CGRect(
                x: CGFloat.random(in: 0...view.bounds.width),
                y: CGFloat.random(in: 0...view.bounds.height),
                width: particle.layer.cornerRadius * 2,
                height: particle.layer.cornerRadius * 2
            )
            view.addSubview(particle)
            
            // Animate particles
            UIView.animate(withDuration: Double.random(in: 3...8), delay: Double(i) * 0.2, options: [.repeat, .autoreverse, .curveEaseInOut]) {
                particle.transform = CGAffineTransform(translationX: CGFloat.random(in: -50...50), y: CGFloat.random(in: -100...100))
                particle.alpha = CGFloat.random(in: 0.05...0.3)
            }
        }
    }
    
    private func setupHeaderView() {
        headerView = UIView()
        headerView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        headerView.layer.cornerRadius = 20
        headerView.layer.masksToBounds = false
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOpacity = 0.1
        headerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        headerView.layer.shadowRadius = 8
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        // Progress circle
        progressView = CircularProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(progressView)
        
        // Stats stack view
        statsStackView = UIStackView()
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.spacing = 16
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(statsStackView)
        
        // Create stat cards
        let totalStat = createStatCard(title: "Total", value: "0", emoji: "🎯", color: UIColor(hex: "#4facfe"))
        let completedStat = createStatCard(title: "Completed", value: "0", emoji: "✨", color: UIColor(hex: "#00f2fe"))
        let bestTimeStat = createStatCard(title: "Best Time", value: "--", emoji: "⚡", color: UIColor(hex: "#43e97b"))
        
        statsStackView.addArrangedSubview(totalStat)
        statsStackView.addArrangedSubview(completedStat)
        statsStackView.addArrangedSubview(bestTimeStat)
    }
    
    private func createStatCard(title: String, value: String, emoji: String, color: UIColor) -> UIView {
        let container = UIView()
        container.backgroundColor = color.withAlphaComponent(0.2)
        container.layer.cornerRadius = 12
        container.layer.borderWidth = 1
        container.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stackView)
        
        let emojiLabel = UILabel()
        emojiLabel.text = emoji
        emojiLabel.font = UIFont.systemFont(ofSize: 20)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.boldSystemFont(ofSize: 18)
        valueLabel.textColor = .white
        valueLabel.tag = 100 // For updating later
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        
        stackView.addArrangedSubview(emojiLabel)
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -8)
        ])
        
        return container
    }
    
    private func setupFilterSection() {
        filterScrollView = UIScrollView()
        filterScrollView.showsHorizontalScrollIndicator = false
        filterScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterScrollView)
        
        let filterStackView = UIStackView()
        filterStackView.axis = .horizontal
        filterStackView.spacing = 12
        filterStackView.translatesAutoresizingMaskIntoConstraints = false
        filterScrollView.addSubview(filterStackView)
        
        // Create filter buttons
        for filter in LevelFilter.allCases {
            let button = createFilterButton(for: filter)
            filterStackView.addArrangedSubview(button)
        }
        
        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: filterScrollView.topAnchor),
            filterStackView.leadingAnchor.constraint(equalTo: filterScrollView.leadingAnchor, constant: 20),
            filterStackView.trailingAnchor.constraint(equalTo: filterScrollView.trailingAnchor, constant: -20),
            filterStackView.bottomAnchor.constraint(equalTo: filterScrollView.bottomAnchor),
            filterStackView.heightAnchor.constraint(equalTo: filterScrollView.heightAnchor)
        ])
    }
    
    private func createFilterButton(for filter: LevelFilter) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("\(filter.emoji) \(filter.title)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = filter == selectedFilter ? UIColor.white.withAlphaComponent(0.9) : UIColor.white.withAlphaComponent(0.2)
        button.setTitleColor(filter == selectedFilter ? UIColor(hex: "#667eea") : .white, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left:16, bottom: 8, right: 16)
        button.tag = LevelFilter.allCases.firstIndex(of: filter) ?? 0
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        
        // Add subtle shadow
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        
        return button
    }
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        let newFilter = LevelFilter.allCases[sender.tag]
        guard newFilter != selectedFilter else { return }
        
        selectedFilter = newFilter
        updateFilterButtons()
        applyFilter()
        
        // Animate button selection
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            sender.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                sender.transform = .identity
            }
        }
    }
    
    private func updateFilterButtons() {
        filterScrollView.subviews.first?.subviews.enumerated().forEach { index, view in
            guard let button = view as? UIButton else { return }
            let filter = LevelFilter.allCases[index]
            let isSelected = filter == selectedFilter
            
            UIView.animate(withDuration: 0.3) {
                button.backgroundColor = isSelected ? UIColor.white.withAlphaComponent(0.9) : UIColor.white.withAlphaComponent(0.2)
                button.setTitleColor(isSelected ? UIColor(hex: "#667eea") : .white, for: .normal)
            }
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 20)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ModernLevelCell.self, forCellWithReuseIdentifier: ModernLevelCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Header view
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 120),
            
            // Progress view
            progressView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            progressView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            progressView.widthAnchor.constraint(equalToConstant: 80),
            progressView.heightAnchor.constraint(equalToConstant: 80),
            
            // Stats stack view
            statsStackView.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            statsStackView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            statsStackView.heightAnchor.constraint(equalToConstant: 80),
            
            // Filter scroll view
            filterScrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            filterScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterScrollView.heightAnchor.constraint(equalToConstant: 40),
            
            // Collection view
            collectionView.topAnchor.constraint(equalTo: filterScrollView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadLevels() {
        levels = GameLevel.loadLevels()
        applyFilter()
        updateProgressStats()
    }
    
    private func applyFilter() {
        switch selectedFilter {
        case .all:
            filteredLevels = levels
        case .easy:
            filteredLevels = levels.filter { $0.id <= 3 }
        case .medium:
            filteredLevels = levels.filter { $0.id > 3 && $0.id <= 6 }
        case .hard:
            filteredLevels = levels.filter { $0.id > 6 }
        case .completed:
            filteredLevels = levels.filter { !$0.isLocked && $0.id > 1 } // Assuming completed means unlocked and not first level
        case .locked:
            filteredLevels = levels.filter { $0.isLocked }
        }
        
        collectionView.reloadData()
    }
    
    private func updateProgressStats() {
        let completedCount = levels.filter { !$0.isLocked }.count - 1 // Subtract 1 for first level
        let totalCount = levels.count
        let progress = Float(completedCount) / Float(totalCount)
        
        progressView.setProgress(progress, animated: true)
        
        // Update stat cards
        if let totalCard = statsStackView.arrangedSubviews[0].viewWithTag(100) as? UILabel {
            totalCard.text = "\(totalCount)"
        }
        if let completedCard = statsStackView.arrangedSubviews[1].viewWithTag(100) as? UILabel {
            completedCard.text = "\(completedCount)"
        }
        if let bestTimeCard = statsStackView.arrangedSubviews[2].viewWithTag(100) as? UILabel {
            bestTimeCard.text = "2:34" // You can implement actual best time tracking
        }
    }
    
    private func startGradientAnimation() {
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = animatedGradientLayer.colors
        animation.toValue = [
            UIColor(hex: "#f093fb").cgColor,
            UIColor(hex: "#f5576c").cgColor,
            UIColor(hex: "#667eea").cgColor,
            UIColor(hex: "#764ba2").cgColor
        ]
        animation.duration = 4.0
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animatedGradientLayer.add(animation, forKey: "colorChange")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animatedGradientLayer.frame = view.bounds
    }
}

extension LevelsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredLevels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ModernLevelCell.identifier, for: indexPath) as! ModernLevelCell
        cell.configure(with: filteredLevels[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 56) / 2 // 20 + 16 + 20 = 56 for padding and spacing
        return CGSize(width: width, height: width * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let level = filteredLevels[indexPath.item]
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Animate cell selection
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    cell.transform = .identity
                }
            }
        }
        
        if level.isLocked {
            showToast(message: "Complete level \(level.id - 1) to unlock!")
        } else {
            let gameVC = GameViewController()
            gameVC.configure(with: level)
            navigationController?.pushViewController(gameVC, animated: true)
        }
    }
}

// MARK: - Modern Level Cell
class ModernLevelCell: UICollectionViewCell {
    static let identifier = "ModernLevelCell"
    
    private let containerView = UIView()
    private let emojiLabel = UILabel()
    private let nameLabel = UILabel()
    private let difficultyLabel = UILabel()
    private let progressBar = UIProgressView()
    private let starsStackView = UIStackView()
    private let lockView = UIView()
    private let shimmerView = UIView()
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Container view with glass morphism effect
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // Gradient background
        gradientLayer.cornerRadius = 20
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0.3).cgColor,
            UIColor.white.withAlphaComponent(0.1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Emoji label with glow effect
        emojiLabel.font = UIFont.systemFont(ofSize: 48)
        emojiLabel.textAlignment = .center
        emojiLabel.layer.shadowColor = UIColor.black.cgColor
        emojiLabel.layer.shadowOpacity = 0.3
        emojiLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        emojiLabel.layer.shadowRadius = 4
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(emojiLabel)
        
        // Name label
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.layer.shadowOpacity = 0.5
        nameLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        nameLabel.layer.shadowRadius = 2
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLabel)
        
        // Difficulty label
        difficultyLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        difficultyLabel.textAlignment = .center
        difficultyLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(difficultyLabel)
        
        // Progress bar
        progressBar.progressTintColor = UIColor(hex: "#00f2fe")
        progressBar.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        progressBar.layer.cornerRadius = 2
        progressBar.clipsToBounds = true
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(progressBar)
        
        // Stars stack view
        starsStackView.axis = .horizontal
        starsStackView.distribution = .fillEqually
        starsStackView.spacing = 2
        starsStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(starsStackView)
        
        // Create star views
        for _ in 0..<3 {
            let starLabel = UILabel()
            starLabel.text = "⭐"
            starLabel.font = UIFont.systemFont(ofSize: 12)
            starLabel.textAlignment = .center
            starLabel.alpha = 0.3
            starsStackView.addArrangedSubview(starLabel)
        }
        
        // Lock view with blur effect
        lockView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        lockView.layer.cornerRadius = 20
        lockView.isHidden = true
        lockView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(lockView)
        
        let lockIcon = UIImageView(image: UIImage(systemName: "lock.fill"))
        lockIcon.tintColor = .white
        lockIcon.contentMode = .scaleAspectFit
        lockIcon.translatesAutoresizingMaskIntoConstraints = false
        lockView.addSubview(lockIcon)
        
        let unlockLabel = UILabel()
        unlockLabel.text = "LOCKED"
        unlockLabel.font = UIFont.boldSystemFont(ofSize: 12)
        unlockLabel.textColor = .white
        unlockLabel.textAlignment = .center
        unlockLabel.translatesAutoresizingMaskIntoConstraints = false
        lockView.addSubview(unlockLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            emojiLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            emojiLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            difficultyLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            difficultyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            difficultyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            progressBar.topAnchor.constraint(equalTo: difficultyLabel.bottomAnchor, constant: 12),
            progressBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            
            starsStackView.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8),
            starsStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            starsStackView.widthAnchor.constraint(equalToConstant: 60),
            starsStackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16),
            
            lockView.topAnchor.constraint(equalTo: containerView.topAnchor),
            lockView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            lockView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            lockView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            lockIcon.centerXAnchor.constraint(equalTo: lockView.centerXAnchor),
            lockIcon.centerYAnchor.constraint(equalTo: lockView.centerYAnchor, constant: -10),
            lockIcon.widthAnchor.constraint(equalToConstant: 30),
            lockIcon.heightAnchor.constraint(equalToConstant: 30),
            
            unlockLabel.topAnchor.constraint(equalTo: lockIcon.bottomAnchor, constant: 8),
            unlockLabel.centerXAnchor.constraint(equalTo: lockView.centerXAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = containerView.bounds
    }
    
    func configure(with level: GameLevel) {
        emojiLabel.text = level.targetEmoji
        nameLabel.text = level.name
        difficultyLabel.text = "Grid: \(level.gridSize)×\(level.gridSize)"
        
        // Configure progress (simulated)
        let progress = level.isLocked ? 0.0 : Float.random(in: 0.3...1.0)
        progressBar.setProgress(progress, animated: false)
        
        // Configure stars based on progress
        let starCount = level.isLocked ? 0 : Int.random(in: 1...3)
        for (index, star) in starsStackView.arrangedSubviews.enumerated() {
            star.alpha = index < starCount ? 1.0 : 0.3
        }
        
        // Configure lock state
        if level.isLocked {
            lockView.isHidden = false
            containerView.alpha = 0.6
        } else {
            lockView.isHidden = true
            containerView.alpha = 1.0
        }
        
        // Configure gradient colors based on difficulty
        let colors: [CGColor]
        switch level.id {
        case 1...3: // Easy
            colors = [
                UIColor(hex: "#a8edea").withAlphaComponent(0.8).cgColor,
                UIColor(hex: "#fed6e3").withAlphaComponent(0.6).cgColor
            ]
        case 4...6: // Medium
            colors = [
                UIColor(hex: "#ffecd2").withAlphaComponent(0.8).cgColor,
                UIColor(hex: "#fcb69f").withAlphaComponent(0.6).cgColor
            ]
        default: // Hard
            colors = [
                UIColor(hex: "#ff9a9e").withAlphaComponent(0.8).cgColor,
                UIColor(hex: "#fecfef").withAlphaComponent(0.6).cgColor
            ]
        }
        gradientLayer.colors = colors
        
        // Add subtle animation for unlocked levels
        if !level.isLocked {
            addPulseAnimation()
        }
    }
    
    private func addPulseAnimation() {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 2.0
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.02
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        containerView.layer.add(pulseAnimation, forKey: "pulse")
    }
}

// MARK: - Circular Progress View
class CircularProgressView: UIView {
    private let progressLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()
    private let percentageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        // Track layer
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.white.withAlphaComponent(0.3).cgColor
        trackLayer.lineWidth = 6
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)
        
        // Progress layer
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.lineWidth = 6
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
        
        // Percentage label
        percentageLabel.textAlignment = .center
        percentageLabel.font = UIFont.boldSystemFont(ofSize: 16)
        percentageLabel.textColor = .white
        percentageLabel.text = "0%"
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(percentageLabel)
        
        NSLayoutConstraint.activate([
            percentageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 3
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 3 * CGFloat.pi / 2, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        progressLayer.path = circularPath.cgPath
    }
    
    func setProgress(_ progress: Float, animated: Bool) {
        let clampedProgress = max(0, min(1, progress))
        
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = progressLayer.strokeEnd
            animation.toValue = clampedProgress
            animation.duration = 1.0
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            progressLayer.add(animation, forKey: "progress")
        }
        
        progressLayer.strokeEnd = CGFloat(clampedProgress)
        percentageLabel.text = "\(Int(clampedProgress * 100))%"
    }
}