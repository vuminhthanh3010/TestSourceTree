import UIKit

class LevelsViewController: BaseViewController {
    
    private var levels: [GameLevel] = []
    private var collectionView: UICollectionView!
    private var headerView: UIView!
    private var progressView: UIProgressView!
    private var progressLabel: UILabel!
    private var totalLevelsLabel: UILabel!
    private var completedLevelsLabel: UILabel!
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevels()
        setupUI()
        setupGradientBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        title = "Select Level"
        collectionView.reloadData()
        updateProgressInfo()
    }
    
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.2, green: 0.3, blue: 0.8, alpha: 1.0).cgColor,
            UIColor(red: 0.1, green: 0.2, blue: 0.6, alpha: 1.0).cgColor,
            UIColor(red: 0.05, green: 0.1, blue: 0.4, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func loadLevels() {
        if let url = Bundle.main.url(forResource: "questions", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                levels = try JSONDecoder().decode([GameLevel].self, from: data)
                
                // Sort by level number
                levels.sort { $0.levelNumber < $1.levelNumber }
                
                // Check unlocked status
                let highestUnlocked = UserDefaults.standard.integer(forKey: "highestUnlockedLevel")
                for i in 0..<levels.count {
                    levels[i].isUnlocked = (i <= highestUnlocked)
                }
                
            } catch {
                print("Error loading levels: \(error)")
                // Fallback levels
                levels = [
                    GameLevel(levelNumber: 1, gridSize: 3, timeLimit: 60, questions: [], isUnlocked: true),
                    GameLevel(levelNumber: 2, gridSize: 4, timeLimit: 90, questions: [], isUnlocked: false),
                    GameLevel(levelNumber: 3, gridSize: 5, timeLimit: 120, questions: [], isUnlocked: false)
                ]
            }
        }
    }
    
    private func setupUI() {
        // Main scroll view
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        
        contentView = UIView()
        contentView.backgroundColor = .clear
        scrollView.addSubview(contentView)
        
        // Header section
        setupHeaderSection()
        
        // Collection view setup
        setupCollectionView()
        
        // Setup constraints
        setupConstraints()
    }
    
    private func setupHeaderSection() {
        headerView = UIView()
        headerView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        headerView.layer.cornerRadius = 20
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        headerView.layer.shadowOpacity = 0.3
        headerView.layer.shadowRadius = 8
        
        // Welcome label
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Choose Your Challenge"
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 28)
        welcomeLabel.textColor = .white
        welcomeLabel.textAlignment = .center
        
        // Subtitle
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Test your skills across different levels"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitleLabel.textAlignment = .center
        
        // Progress section
        let progressContainerView = UIView()
        progressContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        progressContainerView.layer.cornerRadius = 15
        
        progressLabel = UILabel()
        progressLabel.text = "Progress"
        progressLabel.font = UIFont.boldSystemFont(ofSize: 18)
        progressLabel.textColor = .white
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor.systemGreen
        progressView.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        
        // Stats container
        let statsContainer = UIView()
        
        completedLevelsLabel = UILabel()
        completedLevelsLabel.font = UIFont.boldSystemFont(ofSize: 16)
        completedLevelsLabel.textColor = UIColor.systemGreen
        completedLevelsLabel.textAlignment = .center
        
        totalLevelsLabel = UILabel()
        totalLevelsLabel.font = UIFont.systemFont(ofSize: 14)
        totalLevelsLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        totalLevelsLabel.textAlignment = .center
        
        let dividerView = UIView()
        dividerView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
        // Add subviews
        contentView.addSubview(headerView)
        headerView.addSubview(welcomeLabel)
        headerView.addSubview(subtitleLabel)
        headerView.addSubview(progressContainerView)
        progressContainerView.addSubview(progressLabel)
        progressContainerView.addSubview(progressView)
        progressContainerView.addSubview(statsContainer)
        statsContainer.addSubview(completedLevelsLabel)
        statsContainer.addSubview(dividerView)
        statsContainer.addSubview(totalLevelsLabel)
        
        // Header constraints
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        progressContainerView.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        statsContainer.translatesAutoresizingMaskIntoConstraints = false
        completedLevelsLabel.translatesAutoresizingMaskIntoConstraints = false
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        totalLevelsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            progressContainerView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            progressContainerView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            progressContainerView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            progressContainerView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            
            progressLabel.topAnchor.constraint(equalTo: progressContainerView.topAnchor, constant: 15),
            progressLabel.leadingAnchor.constraint(equalTo: progressContainerView.leadingAnchor, constant: 15),
            
            progressView.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 10),
            progressView.leadingAnchor.constraint(equalTo: progressContainerView.leadingAnchor, constant: 15),
            progressView.trailingAnchor.constraint(equalTo: progressContainerView.trailingAnchor, constant: -15),
            progressView.heightAnchor.constraint(equalToConstant: 8),
            
            statsContainer.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 15),
            statsContainer.leadingAnchor.constraint(equalTo: progressContainerView.leadingAnchor, constant: 15),
            statsContainer.trailingAnchor.constraint(equalTo: progressContainerView.trailingAnchor, constant: -15),
            statsContainer.bottomAnchor.constraint(equalTo: progressContainerView.bottomAnchor, constant: -15),
            statsContainer.heightAnchor.constraint(equalToConstant: 50),
            
            completedLevelsLabel.topAnchor.constraint(equalTo: statsContainer.topAnchor),
            completedLevelsLabel.leadingAnchor.constraint(equalTo: statsContainer.leadingAnchor),
            completedLevelsLabel.trailingAnchor.constraint(equalTo: statsContainer.trailingAnchor),
            
            dividerView.topAnchor.constraint(equalTo: completedLevelsLabel.bottomAnchor, constant: 5),
            dividerView.centerXAnchor.constraint(equalTo: statsContainer.centerXAnchor),
            dividerView.widthAnchor.constraint(equalToConstant: 40),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            totalLevelsLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 5),
            totalLevelsLabel.leadingAnchor.constraint(equalTo: statsContainer.leadingAnchor),
            totalLevelsLabel.trailingAnchor.constraint(equalTo: statsContainer.trailingAnchor),
            totalLevelsLabel.bottomAnchor.constraint(equalTo: statsContainer.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        // Dynamic sizing based on screen width
        let screenWidth = UIScreen.main.bounds.width
        let itemsPerRow: CGFloat = screenWidth > 400 ? 3 : 2
        let totalSpacing = layout.sectionInset.left + layout.sectionInset.right + (layout.minimumInteritemSpacing * (itemsPerRow - 1))
        let itemWidth = (screenWidth - totalSpacing) / itemsPerRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.2)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EnhancedLevelCell.self, forCellWithReuseIdentifier: "EnhancedLevelCell")
        collectionView.showsVerticalScrollIndicator = false
        
        contentView.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 200),
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: CGFloat(levels.count / 2 + 1) * 200)
        ])
    }
    
    private func updateProgressInfo() {
        let completedCount = levels.filter { $0.isUnlocked }.count
        let totalCount = levels.count
        let progress = Float(completedCount) / Float(totalCount)
        
        progressView.setProgress(progress, animated: true)
        completedLevelsLabel.text = "\(completedCount) Completed"
        totalLevelsLabel.text = "of \(totalCount) Total Levels"
    }
}

extension LevelsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EnhancedLevelCell", for: indexPath) as! EnhancedLevelCell
        let level = levels[indexPath.item]
        cell.configure(with: level)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let level = levels[indexPath.item]
        
        if level.isUnlocked {
            // Add selection animation
            let cell = collectionView.cellForItem(at: indexPath)
            UIView.animate(withDuration: 0.1, animations: {
                cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    cell?.transform = CGAffineTransform.identity
                }
            }
            
            let gameVC = GameViewController()
            gameVC.selectedLevel = level
            navigationController?.pushViewController(gameVC, animated: true)
        } else {
            showToast(message: "Complete level \(level.levelNumber - 1) first!")
        }
    }
}

class EnhancedLevelCell: UICollectionViewCell {
    private let containerView = UIView()
    private let levelLabel = UILabel()
    private let lockIcon = UILabel()
    private let difficultyIndicator = UIView()
    private let gridSizeLabel = UILabel()
    private let timeLimitLabel = UILabel()
    private let statusBadge = UIView()
    private let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Container setup
        contentView.addSubview(containerView)
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowRadius = 8
        
        // Level number
        levelLabel.font = UIFont.boldSystemFont(ofSize: 32)
        levelLabel.textColor = .white
        levelLabel.textAlignment = .center
        
        // Lock icon (using text instead of image)
        lockIcon.text = "🔒"
        lockIcon.font = UIFont.systemFont(ofSize: 24)
        lockIcon.textAlignment = .center
        lockIcon.isHidden = true
        
        // Difficulty indicator
        difficultyIndicator.layer.cornerRadius = 3
        
        // Grid size label
        gridSizeLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        gridSizeLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        gridSizeLabel.textAlignment = .center
        
        // Time limit label
        timeLimitLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        timeLimitLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        timeLimitLabel.textAlignment = .center
        
        // Status badge
        statusBadge.layer.cornerRadius = 8
        statusBadge.backgroundColor = UIColor.systemGreen
        
        statusLabel.font = UIFont.boldSystemFont(ofSize: 10)
        statusLabel.textColor = .white
        statusLabel.textAlignment = .center
        statusLabel.text = "UNLOCKED"
        
        // Add subviews
        containerView.addSubview(levelLabel)
        containerView.addSubview(lockIcon)
        containerView.addSubview(difficultyIndicator)
        containerView.addSubview(gridSizeLabel)
        containerView.addSubview(timeLimitLabel)
        containerView.addSubview(statusBadge)
        statusBadge.addSubview(statusLabel)
        
        // Setup constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        lockIcon.translatesAutoresizingMaskIntoConstraints = false
        difficultyIndicator.translatesAutoresizingMaskIntoConstraints = false
        gridSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLimitLabel.translatesAutoresizingMaskIntoConstraints = false
        statusBadge.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            levelLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            levelLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            
            lockIcon.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            lockIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            difficultyIndicator.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 8),
            difficultyIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            difficultyIndicator.widthAnchor.constraint(equalToConstant: 40),
            difficultyIndicator.heightAnchor.constraint(equalToConstant: 6),
            
            gridSizeLabel.topAnchor.constraint(equalTo: difficultyIndicator.bottomAnchor, constant: 12),
            gridSizeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            gridSizeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            timeLimitLabel.topAnchor.constraint(equalTo: gridSizeLabel.bottomAnchor, constant: 4),
            timeLimitLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            timeLimitLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            statusBadge.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            statusBadge.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            statusBadge.widthAnchor.constraint(equalToConstant: 70),
            statusBadge.heightAnchor.constraint(equalToConstant: 16),
            
            statusLabel.centerXAnchor.constraint(equalTo: statusBadge.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: statusBadge.centerYAnchor)
        ])
    }
    
    func configure(with level: GameLevel) {
        levelLabel.text = "\(level.levelNumber)"
        gridSizeLabel.text = "\(level.gridSize)×\(level.gridSize) Grid"
        timeLimitLabel.text = "\(level.timeLimit)s Time"
        
        // Difficulty color based on grid size
        let difficultyColors: [UIColor] = [
            UIColor.systemGreen,    // Easy
            UIColor.systemYellow,   // Medium
            UIColor.systemOrange,   // Hard
            UIColor.systemRed       // Expert
        ]
        
        let colorIndex = min(level.gridSize - 3, difficultyColors.count - 1)
        let difficultyColor = difficultyColors[max(0, colorIndex)]
        difficultyIndicator.backgroundColor = difficultyColor
        
        if level.isUnlocked {
            levelLabel.isHidden = false
            lockIcon.isHidden = true
            difficultyIndicator.isHidden = false
            gridSizeLabel.isHidden = false
            timeLimitLabel.isHidden = false
            statusBadge.isHidden = false
            statusLabel.text = "UNLOCKED"
            statusBadge.backgroundColor = UIColor.systemGreen
            
            // Gradient background for unlocked levels
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = containerView.bounds
            gradientLayer.colors = [
                difficultyColor.withAlphaComponent(0.8).cgColor,
                difficultyColor.withAlphaComponent(0.6).cgColor
            ]
            gradientLayer.cornerRadius = 16
            containerView.layer.insertSublayer(gradientLayer, at: 0)
            
        } else {
            levelLabel.isHidden = true
            lockIcon.isHidden = false
            difficultyIndicator.isHidden = true
            gridSizeLabel.isHidden = true
            timeLimitLabel.isHidden = true
            statusBadge.isHidden = false
            statusLabel.text = "LOCKED"
            statusBadge.backgroundColor = UIColor.systemGray
            
            containerView.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
            containerView.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        containerView.layer.sublayers?.removeAll { $0 is CAGradientLayer }
    }
}