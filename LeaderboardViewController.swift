import UIKit

class LeaderboardViewController: BaseViewController {
    
    private var tableView = UITableView()
    private var scores: [PlayerScore] = []
    private var allScores: [PlayerScore] = []
    private var segmentedControl = UISegmentedControl(items: ["All Levels", "Level 1", "Level 2", "Level 3"])
    
    // New UI Components
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let statisticsContainerView = UIView()
    private let totalPlayersLabel = UILabel()
    private let averageScoreLabel = UILabel()
    private let topScoreLabel = UILabel()
    private let filterContainerView = UIView()
    private let refreshButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadScores()
    }
    
    private func setupUI() {
        title = "Leaderboard"
        view.backgroundColor = isDarkMode ? .systemBackground : .systemGray6
        
        // Modern gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemPurple.withAlphaComponent(0.1).cgColor,
            UIColor.systemBlue.withAlphaComponent(0.1).cgColor,
            UIColor.systemTeal.withAlphaComponent(0.1).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        setupHeaderView()
        setupStatisticsView()
        setupFilterView()
        setupTableView()
        setupConstraints()
    }
    
    private func setupHeaderView() {
        headerView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        headerView.layer.cornerRadius = 20
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOpacity = 0.1
        headerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        headerView.layer.shadowRadius = 8
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        // Title with trophy emoji
        titleLabel.text = "🏆 Leaderboard"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        // Refresh button
        refreshButton.setTitle("↻ Refresh", for: .normal)
        refreshButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        refreshButton.backgroundColor = UIColor.systemBlue
        refreshButton.setTitleColor(.white, for: .normal)
        refreshButton.layer.cornerRadius = 15
        refreshButton.addTarget(self, action: #selector(refreshTapped), for: .touchUpInside)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(refreshButton)
    }
    
    private func setupStatisticsView() {
        statisticsContainerView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8)
        statisticsContainerView.layer.cornerRadius = 15
        statisticsContainerView.layer.borderWidth = 1
        statisticsContainerView.layer.borderColor = UIColor.separator.cgColor
        statisticsContainerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(statisticsContainerView)
        
        // Statistics labels
        totalPlayersLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        totalPlayersLabel.textAlignment = .center
        totalPlayersLabel.textColor = .systemBlue
        totalPlayersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        averageScoreLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        averageScoreLabel.textAlignment = .center
        averageScoreLabel.textColor = .systemGreen
        averageScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        topScoreLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        topScoreLabel.textAlignment = .center
        topScoreLabel.textColor = .systemOrange
        topScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [totalPlayersLabel, averageScoreLabel, topScoreLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        statisticsContainerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: statisticsContainerView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: statisticsContainerView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: statisticsContainerView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: statisticsContainerView.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupFilterView() {
        filterContainerView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        filterContainerView.layer.cornerRadius = 15
        filterContainerView.layer.shadowColor = UIColor.black.cgColor
        filterContainerView.layer.shadowOpacity = 0.05
        filterContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        filterContainerView.layer.shadowRadius = 4
        filterContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterContainerView)
        
        // Enhanced segmented control
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor.systemGray6
        segmentedControl.selectedSegmentTintColor = UIColor.systemBlue
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        filterContainerView.addSubview(segmentedControl)
        
        let filterLabel = UILabel()
        filterLabel.text = "🎯 Filter by Level"
        filterLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        filterLabel.textColor = .secondaryLabel
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        filterContainerView.addSubview(filterLabel)
        
        NSLayoutConstraint.activate([
            filterLabel.topAnchor.constraint(equalTo: filterContainerView.topAnchor, constant: 15),
            filterLabel.leadingAnchor.constraint(equalTo: filterContainerView.leadingAnchor, constant: 20),
            
            segmentedControl.topAnchor.constraint(equalTo: filterLabel.bottomAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: filterContainerView.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: filterContainerView.trailingAnchor, constant: -20),
            segmentedControl.bottomAnchor.constraint(equalTo: filterContainerView.bottomAnchor, constant: -15)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ScoreCell.self, forCellReuseIdentifier: ScoreCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Header view
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 140),
            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: refreshButton.leadingAnchor, constant: -10),
            
            // Refresh button
            refreshButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            refreshButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            refreshButton.widthAnchor.constraint(equalToConstant: 80),
            refreshButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Statistics container
            statisticsContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            statisticsContainerView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            statisticsContainerView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            statisticsContainerView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -15),
            
            // Filter container
            filterContainerView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 15),
            filterContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            filterContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Table view
            tableView.topAnchor.constraint(equalTo: filterContainerView.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadScores() {
        allScores = LocalStorage.shared.getScores()
        scores = allScores
        updateStatistics()
        filterScores()
    }
    
    private func updateStatistics() {
        let totalPlayers = Set(allScores.map { $0.name }).count
        let averageScore = allScores.isEmpty ? 0 : allScores.reduce(0) { $0 + $1.score } / allScores.count
        let topScore = allScores.max(by: { $0.score < $1.score })?.score ?? 0
        
        totalPlayersLabel.text = "👥\n\(totalPlayers)\nPlayers"
        averageScoreLabel.text = "📊\n\(averageScore)\nAvg Score"
        topScoreLabel.text = "🎯\n\(topScore)\nTop Score"
    }
    
    @objc private func segmentChanged() {
        filterScores()
    }
    
    @objc private func refreshTapped() {
        // Add refresh animation
        refreshButton.transform = CGAffineTransform(rotationAngle: .pi)
        UIView.animate(withDuration: 0.3) {
            self.refreshButton.transform = .identity
        }
        loadScores()
    }
    
    private func filterScores() {
        let selectedLevel = segmentedControl.selectedSegmentIndex
        if selectedLevel == 0 {
            scores = allScores
        } else {
            scores = allScores.filter { $0.level == selectedLevel }
        }
        tableView.reloadData()
    }
}

extension LeaderboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScoreCell.identifier, for: indexPath) as! ScoreCell
        cell.configure(with: scores[indexPath.row], rank: indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

class ScoreCell: UITableViewCell {
    static let identifier = "ScoreCell"
    
    private let rankLabel = UILabel()
    private let nameLabel = UILabel()
    private let scoreLabel = UILabel()
    private let levelLabel = UILabel()
    private let dateLabel = UILabel()
    private let cardView = UIView()
    private let rankBadgeView = UIView()
    private let progressBar = UIView()
    private let progressFill = UIView()
    private let achievementLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Modern card view with gradient
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 8
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        
        // Rank badge
        rankBadgeView.layer.cornerRadius = 20
        rankBadgeView.backgroundColor = UIColor.systemGray5
        rankBadgeView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(rankBadgeView)
        
        // Rank label with better styling
        rankLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        rankLabel.textAlignment = .center
        rankLabel.textColor = .white
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        rankBadgeView.addSubview(rankLabel)
        
        // Name label with emoji support
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nameLabel.textColor = .label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(nameLabel)
        
        // Score label with currency-style formatting
        scoreLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        scoreLabel.textColor = .systemBlue
        scoreLabel.textAlignment = .right
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(scoreLabel)
        
        // Level label with badge style
        levelLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        levelLabel.textColor = .white
        levelLabel.backgroundColor = UIColor.systemPurple
        levelLabel.textAlignment = .center
        levelLabel.layer.cornerRadius = 8
        levelLabel.layer.masksToBounds = true
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(levelLabel)
        
        // Date label with icon
        dateLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        dateLabel.textColor = .tertiaryLabel
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(dateLabel)
        
        // Progress bar for score visualization
        progressBar.backgroundColor = UIColor.systemGray6
        progressBar.layer.cornerRadius = 2
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(progressBar)
        
        progressFill.backgroundColor = UIColor.systemBlue
        progressFill.layer.cornerRadius = 2
        progressFill.translatesAutoresizingMaskIntoConstraints = false
        progressBar.addSubview(progressFill)
        
        // Achievement label
        achievementLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        achievementLabel.textColor = .systemOrange
        achievementLabel.textAlignment = .right
        achievementLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(achievementLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            rankBadgeView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15),
            rankBadgeView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            rankBadgeView.widthAnchor.constraint(equalToConstant: 40),
            rankBadgeView.heightAnchor.constraint(equalToConstant: 40),
            
            rankLabel.centerXAnchor.constraint(equalTo: rankBadgeView.centerXAnchor),
            rankLabel.centerYAnchor.constraint(equalTo: rankBadgeView.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: rankBadgeView.trailingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: scoreLabel.leadingAnchor, constant: -10),
            
            scoreLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -15),
            scoreLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            levelLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            levelLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            levelLabel.widthAnchor.constraint(equalToConstant: 60),
            levelLabel.heightAnchor.constraint(equalToConstant: 16),
            
            progressBar.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 8),
            progressBar.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: scoreLabel.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            
            progressFill.topAnchor.constraint(equalTo: progressBar.topAnchor),
            progressFill.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor),
            progressFill.bottomAnchor.constraint(equalTo: progressBar.bottomAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            achievementLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            achievementLabel.trailingAnchor.constraint(equalTo: scoreLabel.trailingAnchor)
        ])
    }
    
    func configure(with score: PlayerScore, rank: Int) {
        rankLabel.text = "\(rank)"
        
        // Enhanced rank styling with colors and emojis
        switch rank {
        case 1:
            nameLabel.text = "👑 \(score.name)"
            rankBadgeView.backgroundColor = UIColor.systemYellow
            rankLabel.textColor = .white
            achievementLabel.text = "🏆 CHAMPION"
        case 2:
            nameLabel.text = "🥈 \(score.name)"
            rankBadgeView.backgroundColor = UIColor.systemGray
            rankLabel.textColor = .white
            achievementLabel.text = "🥈 RUNNER-UP"
        case 3:
            nameLabel.text = "🥉 \(score.name)"
            rankBadgeView.backgroundColor = UIColor.systemBrown
            rankLabel.textColor = .white
            achievementLabel.text = "🥉 THIRD PLACE"
        case 4...10:
            nameLabel.text = "⭐ \(score.name)"
            rankBadgeView.backgroundColor = UIColor.systemBlue
            rankLabel.textColor = .white
            achievementLabel.text = "⭐ TOP 10"
        default:
            nameLabel.text = score.name
            rankBadgeView.backgroundColor = UIColor.systemGray5
            rankLabel.textColor = .label
            achievementLabel.text = ""
        }
        
        // Enhanced score formatting
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        scoreLabel.text = "\(formatter.string(from: NSNumber(value: score.score)) ?? "\(score.score)") pts"
        
        levelLabel.text = "LV \(score.level)"
        
        // Enhanced date formatting
        let formatter2 = DateFormatter()
        formatter2.dateStyle = .short
        formatter2.timeStyle = .short
        dateLabel.text = "🕒 \(formatter2.string(from: score.date))"
        
        // Progress bar animation (simulate score relative to max possible)
        let maxScore: Float = 10000 // Assume max possible score
        let progress = min(Float(score.score) / maxScore, 1.0)
        
        progressFill.widthAnchor.constraint(equalTo: progressBar.widthAnchor, multiplier: CGFloat(progress)).isActive = true
        
        // Highlight current player's score with special styling
        if score.name == LocalStorage.shared.getPlayerName() {
            cardView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
            cardView.layer.borderWidth = 2
            cardView.layer.borderColor = UIColor.systemBlue.cgColor
            nameLabel.text = "🎮 \(score.name) (You)"
        } else {
            cardView.backgroundColor = .systemBackground
            cardView.layer.borderWidth = 0
        }
        
        // Add subtle animation
        cardView.transform = CGAffineTransform(scaleX: 0.95, scaleY: 0.95)
        UIView.animate(withDuration: 0.3, delay: 0.1 * Double(rank), options: .curveEaseOut) {
            self.cardView.transform = .identity
        }
    }
}