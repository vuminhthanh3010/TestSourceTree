import UIKit
import StoreKit

class SettingsViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let backButton = UIButton(type: .system)
    private let settingsTableView = UITableView()
    
    private struct SettingsItem {
        let title: String
        let subtitle: String?
        let action: () -> Void
    }
    
    private var settingsItems: [SettingsItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupSettingsItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GradientHelper.applyGradient(to: view, type: .settings)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        GradientHelper.updateGradientFrame(in: view)
    }
    
    private func setupUI() {
        // Title Label
        titleLabel.text = "Settings"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Back Button
        backButton.setTitle("← Back", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        backButton.setTitleColor(.white, for: .normal)
        backButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        backButton.layer.cornerRadius = 15
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
        
        // Settings Table View
        settingsTableView.backgroundColor = .clear
        settingsTableView.separatorStyle = .none
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Back Button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 80),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Table View
            settingsTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            settingsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupSettingsItems() {
        settingsItems = [
            SettingsItem(
                title: "Share Game",
                subtitle: "Tell your friends about Number Flip!",
                action: { [weak self] in self?.shareApp() }
            ),
            SettingsItem(
                title: "Rate App",
                subtitle: "Love the game? Rate us on the App Store!",
                action: { [weak self] in self?.rateApp() }
            ),
            SettingsItem(
                title: "Reset Statistics",
                subtitle: "Clear all saved scores and progress",
                action: { [weak self] in self?.resetStatistics() }
            ),
            SettingsItem(
                title: "How to Play",
                subtitle: "Learn the rules and strategies",
                action: { [weak self] in self?.showHowToPlay() }
            ),
            SettingsItem(
                title: "About",
                subtitle: "Version 1.0 - Made with ❤️",
                action: { [weak self] in self?.showAbout() }
            )
        ]
        
        settingsTableView.reloadData()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func shareApp() {
        let shareText = "Check out Number Flip - an amazing memory and logic puzzle game! Test your skills by remembering number positions and tapping them in sequence. Download it now!"
        let shareURL = URL(string: "https://apps.apple.com/app/number-flip")! // Replace with actual App Store URL
        
        let activityViewController = UIActivityViewController(
            activityItems: [shareText, shareURL],
            applicationActivities: nil
        )
        
        activityViewController.popoverPresentationController?.sourceView = view
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        
        present(activityViewController, animated: true)
    }
    
    private func rateApp() {
        if #available(iOS 14.0, *) {
            if let scene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }
    }
    
    private func resetStatistics() {
        let alert = UIAlertController(
            title: "Reset Statistics",
            message: "Are you sure you want to reset all your game statistics? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { _ in
            UserDefaults.standard.removeObject(forKey: "bestScore")
            UserDefaults.standard.removeObject(forKey: "gamesPlayed")
            
            let successAlert = UIAlertController(
                title: "Reset Complete",
                message: "All statistics have been reset successfully.",
                preferredStyle: .alert
            )
            successAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(successAlert, animated: true)
        })
        
        present(alert, animated: true)
    }
    
    private func showHowToPlay() {
        let howToPlayVC = HowToPlayViewController()
        navigationController?.pushViewController(howToPlayVC, animated: true)
    }
    
    private func showAbout() {
        let aboutMessage = """
        Number Flip
        Version 1.0
        
        A unique memory and logic puzzle game that challenges your ability to remember number positions and tap them in sequential order.
        
        Features:
        • Multiple difficulty levels
        • Casual and Challenge modes
        • Beautiful animations
        • Score tracking
        
        Developed with Swift and UIKit
        """
        
        let alert = UIAlertController(title: "About Number Flip", message: aboutMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
        let item = settingsItems[indexPath.row]
        cell.configure(with: item.title, subtitle: item.subtitle)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        settingsItems[indexPath.row].action()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - SettingsTableViewCell
class SettingsTableViewCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let containerView = UIView()
    private let arrowImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Container View
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // Title Label
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        // Subtitle Label
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitleLabel.numberOfLines = 2
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(subtitleLabel)
        
        // Arrow Image View
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = UIColor.white.withAlphaComponent(0.6)
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(arrowImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container View
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -10),
            
            // Subtitle Label
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -10),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -15),
            
            // Arrow Image View
            arrowImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with title: String, subtitle: String?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle == nil
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        UIView.animate(withDuration: 0.1) {
            self.containerView.alpha = highlighted ? 0.7 : 1.0
            self.transform = highlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
        }
    }
}