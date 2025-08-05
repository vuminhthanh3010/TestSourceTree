import UIKit

class LevelsViewController: BaseViewController {
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Level Selection"
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose your challenge"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressBar: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progressTintColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        progress.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        progress.layer.cornerRadius = 4
        progress.clipsToBounds = true
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
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
        updateProgressInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProgressInfo()
        levelsCollectionView.reloadData()
    }
    
    private func setupView() {
        title = "Levels"
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)
        headerView.addSubview(progressContainerView)
        progressContainerView.addSubview(progressLabel)
        progressContainerView.addSubview(progressBar)
        headerView.addSubview(statsStackView)
        view.addSubview(levelsCollectionView)
        
        setupStatsViews()
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 220),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            progressContainerView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            progressContainerView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 30),
            progressContainerView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -30),
            progressContainerView.heightAnchor.constraint(equalToConstant: 60),
            
            progressLabel.topAnchor.constraint(equalTo: progressContainerView.topAnchor, constant: 10),
            progressLabel.centerXAnchor.constraint(equalTo: progressContainerView.centerXAnchor),
            
            progressBar.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 8),
            progressBar.leadingAnchor.constraint(equalTo: progressContainerView.leadingAnchor, constant: 15),
            progressBar.trailingAnchor.constraint(equalTo: progressContainerView.trailingAnchor, constant: -15),
            progressBar.heightAnchor.constraint(equalToConstant: 8),
            
            statsStackView.topAnchor.constraint(equalTo: progressContainerView.bottomAnchor, constant: 15),
            statsStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 30),
            statsStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -30),
            statsStackView.heightAnchor.constraint(equalToConstant: 40),
            
            levelsCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            levelsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            levelsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            levelsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupStatsViews() {
        let totalLevels = createStatView(title: "Total", value: "\(levels.count)", color: UIColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 1.0))
        let completedLevels = createStatView(title: "Completed", value: "\(GameData.shared.highestUnlockedLevel - 1)", color: UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0))
        let remainingLevels = createStatView(title: "Remaining", value: "\(levels.count - (GameData.shared.highestUnlockedLevel - 1))", color: UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0))
        
        statsStackView.addArrangedSubview(totalLevels)
        statsStackView.addArrangedSubview(completedLevels)
        statsStackView.addArrangedSubview(remainingLevels)
    }
    
    private func createStatView(title: String, value: String, color: UIColor) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        container.layer.cornerRadius = 10
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        valueLabel.textColor = color
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 5),
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            valueLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])
        
        return container
    }
    
    private func updateProgressInfo() {
        let completed = GameData.shared.highestUnlockedLevel - 1
        let total = levels.count
        let progress = Float(completed) / Float(total)
        
        progressLabel.text = "Progress: \(completed)/\(total) levels completed"
        progressBar.setProgress(progress, animated: true)
        
        // Update stats
        if let completedStat = statsStackView.arrangedSubviews[1] as? UIView,
           let remainingStat = statsStackView.arrangedSubviews[2] as? UIView {
            if let completedValueLabel = completedStat.subviews.compactMap({ $0 as? UILabel }).last {
                completedValueLabel.text = "\(completed)"
            }
            if let remainingValueLabel = remainingStat.subviews.compactMap({ $0 as? UILabel }).last {
                remainingValueLabel.text = "\(total - completed)"
            }
        }
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
        cell.configure(with: levels[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 60) / 2
        return CGSize(width: width, height: width + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let level = levels[indexPath.item]
        
        // Check if level is unlocked
        if level.levelNumber <= GameData.shared.highestUnlockedLevel {
            let gameVC = GameViewController()
            gameVC.currentLevel = level
            navigationController?.pushViewController(gameVC, animated: true)
        } else {
            showAlert(message: "Complete level \(GameData.shared.highestUnlockedLevel) first!")
        }
    }
}

class LevelCell: UICollectionViewCell {
    static let identifier = "LevelCell"
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let levelNumberView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let difficultyIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let movesContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let blendMoveView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let splitMoveView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let blendLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let blendValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let splitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor(red: 0.8, green: 0.2, blue: 0.4, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let splitValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(red: 0.8, green: 0.2, blue: 0.4, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lockOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.layer.cornerRadius = 20
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lockIcon: UILabel = {
        let label = UILabel()
        label.text = "🔒"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .clear
        
        addSubview(cardView)
        cardView.addSubview(levelNumberView)
        levelNumberView.addSubview(levelLabel)
        cardView.addSubview(difficultyIndicator)
        cardView.addSubview(movesContainer)
        movesContainer.addSubview(blendMoveView)
        movesContainer.addSubview(splitMoveView)
        blendMoveView.addSubview(blendLabel)
        blendMoveView.addSubview(blendValueLabel)
        splitMoveView.addSubview(splitLabel)
        splitMoveView.addSubview(splitValueLabel)
        cardView.addSubview(statusIndicator)
        addSubview(lockOverlay)
        lockOverlay.addSubview(lockIcon)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            levelNumberView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 15),
            levelNumberView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            levelNumberView.widthAnchor.constraint(equalToConstant: 40),
            levelNumberView.heightAnchor.constraint(equalToConstant: 40),
            
            levelLabel.centerXAnchor.constraint(equalTo: levelNumberView.centerXAnchor),
            levelLabel.centerYAnchor.constraint(equalTo: levelNumberView.centerYAnchor),
            
            difficultyIndicator.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            difficultyIndicator.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            difficultyIndicator.widthAnchor.constraint(equalToConstant: 6),
            difficultyIndicator.heightAnchor.constraint(equalToConstant: 20),
            
            movesContainer.topAnchor.constraint(equalTo: levelNumberView.bottomAnchor, constant: 15),
            movesContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            movesContainer.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            movesContainer.heightAnchor.constraint(equalToConstant: 70),
            
            blendMoveView.topAnchor.constraint(equalTo: movesContainer.topAnchor),
            blendMoveView.leadingAnchor.constraint(equalTo: movesContainer.leadingAnchor),
            blendMoveView.trailingAnchor.constraint(equalTo: movesContainer.centerXAnchor, constant: -5),
            blendMoveView.bottomAnchor.constraint(equalTo: movesContainer.bottomAnchor),
            
            splitMoveView.topAnchor.constraint(equalTo: movesContainer.topAnchor),
            splitMoveView.leadingAnchor.constraint(equalTo: movesContainer.centerXAnchor, constant: 5),
            splitMoveView.trailingAnchor.constraint(equalTo: movesContainer.trailingAnchor),
            splitMoveView.bottomAnchor.constraint(equalTo: movesContainer.bottomAnchor),
            
            blendLabel.topAnchor.constraint(equalTo: blendMoveView.topAnchor, constant: 8),
            blendLabel.centerXAnchor.constraint(equalTo: blendMoveView.centerXAnchor),
            
            blendValueLabel.topAnchor.constraint(equalTo: blendLabel.bottomAnchor, constant: 5),
            blendValueLabel.centerXAnchor.constraint(equalTo: blendMoveView.centerXAnchor),
            
            splitLabel.topAnchor.constraint(equalTo: splitMoveView.topAnchor, constant: 8),
            splitLabel.centerXAnchor.constraint(equalTo: splitMoveView.centerXAnchor),
            
            splitValueLabel.topAnchor.constraint(equalTo: splitLabel.bottomAnchor, constant: 5),
            splitValueLabel.centerXAnchor.constraint(equalTo: splitMoveView.centerXAnchor),
            
            statusIndicator.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            statusIndicator.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            statusIndicator.widthAnchor.constraint(equalToConstant: 12),
            statusIndicator.heightAnchor.constraint(equalToConstant: 12),
            
            lockOverlay.topAnchor.constraint(equalTo: topAnchor),
            lockOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            lockOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            lockOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            lockIcon.centerXAnchor.constraint(equalTo: lockOverlay.centerXAnchor),
            lockIcon.centerYAnchor.constraint(equalTo: lockOverlay.centerYAnchor)
        ])
    }
    
    func configure(with level: Level) {
        levelLabel.text = "\(level.levelNumber)"
        blendLabel.text = "BLEND"
        blendValueLabel.text = "\(level.maxBlendMoves)"
        splitLabel.text = "SPLIT"
        splitValueLabel.text = "\(level.maxSplitMoves)"
        
        let isUnlocked = level.levelNumber <= GameData.shared.highestUnlockedLevel
        lockOverlay.isHidden = isUnlocked
        
        // Configure colors based on unlock status and difficulty
        if isUnlocked {
            let difficulty = level.maxBlendMoves + level.maxSplitMoves
            
            // Level number background color based on difficulty
            if difficulty <= 10 {
                levelNumberView.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0) // Easy - Green
                difficultyIndicator.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
            } else if difficulty <= 20 {
                levelNumberView.backgroundColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0) // Medium - Orange
                difficultyIndicator.backgroundColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0)
            } else {
                levelNumberView.backgroundColor = UIColor(red: 0.9, green: 0.2, blue: 0.3, alpha: 1.0) // Hard - Red
                difficultyIndicator.backgroundColor = UIColor(red: 0.9, green: 0.2, blue: 0.3, alpha: 1.0)
            }
            
            // Status indicator for completed levels
            if level.levelNumber < GameData.shared.highestUnlockedLevel {
                statusIndicator.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
                statusIndicator.isHidden = false
            } else {
                statusIndicator.isHidden = true
            }
        } else {
            levelNumberView.backgroundColor = UIColor.lightGray
            difficultyIndicator.backgroundColor = UIColor.lightGray
            statusIndicator.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lockOverlay.isHidden = true
        statusIndicator.isHidden = true
    }
}