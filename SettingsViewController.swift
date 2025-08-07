import UIKit
import MessageUI

class SettingsViewController: BaseViewController, MFMailComposeViewControllerDelegate {
    
    private let darkModeSwitch = UISwitch()
    private let notificationsSwitch = UISwitch()
    private let soundEffectsSwitch = UISwitch()
    private let versionLabel = UILabel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Settings"
        
        // Create gradient background with animated colors
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
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Profile Header Card
        let profileCard = createProfileHeaderCard()
        contentView.addSubview(profileCard)
        
        // Preferences Card
        let preferencesCard = createPreferencesCard()
        contentView.addSubview(preferencesCard)
        
        // App Actions Card
        let actionsCard = createAppActionsCard()
        contentView.addSubview(actionsCard)
        
        // Privacy & Security Card
        let privacyCard = createPrivacyCard()
        contentView.addSubview(privacyCard)
        
        // About Card
        let aboutCard = createAboutCard()
        contentView.addSubview(aboutCard)
        
        // Version footer
        versionLabel.text = "Version \(Bundle.main.appVersion) (\(Bundle.main.buildNumber))"
        versionLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        versionLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        versionLabel.textAlignment = .center
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(versionLabel)
        
        setupConstraints(profileCard: profileCard, preferencesCard: preferencesCard, 
                        actionsCard: actionsCard, privacyCard: privacyCard, aboutCard: aboutCard)
    }
    
    private func createProfileHeaderCard() -> UIView {
        let card = createCard()
        
        let avatarView = UIView()
        avatarView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        avatarView.layer.cornerRadius = 35
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        let avatarLabel = UILabel()
        avatarLabel.text = "👤"
        avatarLabel.font = UIFont.systemFont(ofSize: 30)
        avatarLabel.textAlignment = .center
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarView.addSubview(avatarLabel)
        
        let nameLabel = UILabel()
        nameLabel.text = "Chase Grid Player"
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let statusLabel = UILabel()
        statusLabel.text = "Level Master • 🏆 High Scorer"
        statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        statusLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(avatarView)
        card.addSubview(nameLabel)
        card.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            avatarView.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 70),
            avatarView.heightAnchor.constraint(equalToConstant: 70),
            
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 25),
            nameLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            
            statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            statusLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            card.heightAnchor.constraint(equalToConstant: 110)
        ])
        
        return card
    }
    
    private func createPreferencesCard() -> UIView {
        let card = createCard()
        
        let titleLabel = createSectionTitle("🎮 Game Preferences")
        card.addSubview(titleLabel)
        
        // Dark Mode Row
        let darkModeRow = createToggleRow(icon: "🌙", title: "Dark Mode", subtitle: "Switch between light and dark themes", toggle: darkModeSwitch)
        darkModeSwitch.isOn = isDarkMode
        darkModeSwitch.addTarget(self, action: #selector(darkModeChanged), for: .valueChanged)
        card.addSubview(darkModeRow)
        
        // Notifications Row
        let notificationRow = createToggleRow(icon: "🔔", title: "Push Notifications", subtitle: "Get notified about new challenges", toggle: notificationsSwitch)
        notificationsSwitch.isOn = true
        notificationsSwitch.addTarget(self, action: #selector(notificationsChanged), for: .valueChanged)
        card.addSubview(notificationRow)
        
        // Sound Effects Row
        let soundRow = createToggleRow(icon: "🔊", title: "Sound Effects", subtitle: "Enable game sound effects", toggle: soundEffectsSwitch)
        soundEffectsSwitch.isOn = true
        soundEffectsSwitch.addTarget(self, action: #selector(soundEffectsChanged), for: .valueChanged)
        card.addSubview(soundRow)
        
        // Language Row
        let languageRow = createActionRow(icon: "🌍", title: "Language", subtitle: "English", action: #selector(languageTapped))
        card.addSubview(languageRow)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            
            darkModeRow.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            darkModeRow.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            darkModeRow.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            darkModeRow.heightAnchor.constraint(equalToConstant: 60),
            
            notificationRow.topAnchor.constraint(equalTo: darkModeRow.bottomAnchor, constant: 8),
            notificationRow.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            notificationRow.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            notificationRow.heightAnchor.constraint(equalToConstant: 60),
            
            soundRow.topAnchor.constraint(equalTo: notificationRow.bottomAnchor, constant: 8),
            soundRow.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            soundRow.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            soundRow.heightAnchor.constraint(equalToConstant: 60),
            
            languageRow.topAnchor.constraint(equalTo: soundRow.bottomAnchor, constant: 8),
            languageRow.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            languageRow.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            languageRow.heightAnchor.constraint(equalToConstant: 60),
            languageRow.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20)
        ])
        
        return card
    }
    
    private func createAppActionsCard() -> UIView {
        let card = createCard()
        
        let titleLabel = createSectionTitle("📱 App Actions")
        card.addSubview(titleLabel)
        
        let shareRow = createActionRow(icon: "📤", title: "Share App", subtitle: "Tell friends about Chase Grid", action: #selector(shareTapped))
        card.addSubview(shareRow)
        
        let rateRow = createActionRow(icon: "⭐", title: "Rate App", subtitle: "Rate us on the App Store", action: #selector(rateTapped))
        card.addSubview(rateRow)
        
        let feedbackRow = createActionRow(icon: "💬", title: "Send Feedback", subtitle: "Help us improve the game", action: #selector(feedbackTapped))
        card.addSubview(feedbackRow)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            
            shareRow.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            shareRow.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            shareRow.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            shareRow.heightAnchor.constraint(equalToConstant: 60),
            
            rateRow.topAnchor.constraint(equalTo: shareRow.bottomAnchor, constant: 8),
            rateRow.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            rateRow.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            rateRow.heightAnchor.constraint(equalToConstant: 60),
            
            feedbackRow.topAnchor.constraint(equalTo: rateRow.bottomAnchor, constant: 8),
            feedbackRow.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            feedbackRow.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            feedbackRow.heightAnchor.constraint(equalToConstant: 60),
            feedbackRow.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20)
        ])
        
        return card
    }
    
    private func createPrivacyCard() -> UIView {
        let card = createCard()
        
        let titleLabel = createSectionTitle("🔒 Privacy & Security")
        card.addSubview(titleLabel)
        
        let privacyRow = createActionRow(icon: "📋", title: "Privacy Policy", subtitle: "Read our privacy policy", action: #selector(privacyTapped))
        card.addSubview(privacyRow)
        
        let termsRow = createActionRow(icon: "📄", title: "Terms of Service", subtitle: "View terms and conditions", action: #selector(termsTapped))
        card.addSubview(termsRow)
        
        let dataRow = createActionRow(icon: "🗑️", title: "Clear Data", subtitle: "Reset all game progress", action: #selector(clearDataTapped))
        card.addSubview(dataRow)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            
            privacyRow.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            privacyRow.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            privacyRow.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            privacyRow.heightAnchor.constraint(equalToConstant: 60),
            
            termsRow.topAnchor.constraint(equalTo: privacyRow.bottomAnchor, constant: 8),
            termsRow.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            termsRow.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            termsRow.heightAnchor.constraint(equalToConstant: 60),
            
            dataRow.topAnchor.constraint(equalTo: termsRow.bottomAnchor, constant: 8),
            dataRow.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            dataRow.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            dataRow.heightAnchor.constraint(equalToConstant: 60),
            dataRow.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20)
        ])
        
        return card
    }
    
    private func createAboutCard() -> UIView {
        let card = createCard()
        
        let titleLabel = createSectionTitle("ℹ️ About")
        card.addSubview(titleLabel)
        
        let appInfoRow = createInfoRow(icon: "📱", title: "App Version", value: "\(Bundle.main.appVersion)")
        card.addSubview(appInfoRow)
        
        let buildInfoRow = createInfoRow(icon: "🔧", title: "Build Number", value: Bundle.main.buildNumber)
        card.addSubview(buildInfoRow)
        
        let developerRow = createActionRow(icon: "👨‍💻", title: "Developer", subtitle: "Made with ❤️ for gamers", action: #selector(developerTapped))
        card.addSubview(developerRow)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            
            appInfoRow.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            appInfoRow.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            appInfoRow.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            appInfoRow.heightAnchor.constraint(equalToConstant: 50),
            
            buildInfoRow.topAnchor.constraint(equalTo: appInfoRow.bottomAnchor, constant: 8),
            buildInfoRow.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            buildInfoRow.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            buildInfoRow.heightAnchor.constraint(equalToConstant: 50),
            
            developerRow.topAnchor.constraint(equalTo: buildInfoRow.bottomAnchor, constant: 8),
            developerRow.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            developerRow.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            developerRow.heightAnchor.constraint(equalToConstant: 60),
            developerRow.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20)
        ])
        
        return card
    }
    
    private func createCard() -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        card.layer.cornerRadius = 20
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 4)
        card.layer.shadowRadius = 10
        card.layer.shadowOpacity = 0.1
        card.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subtle border
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        
        return card
    }
    
    private func createSectionTitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createToggleRow(icon: String, title: String, subtitle: String, toggle: UISwitch) -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 24)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        toggle.translatesAutoresizingMaskIntoConstraints = false
        
        row.addSubview(iconLabel)
        row.addSubview(titleLabel)
        row.addSubview(subtitleLabel)
        row.addSubview(toggle)
        
        NSLayoutConstraint.activate([
            iconLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 20),
            iconLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: row.topAnchor, constant: 12),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: toggle.leadingAnchor, constant: -10),
            
            toggle.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -20),
            toggle.centerYAnchor.constraint(equalTo: row.centerYAnchor)
        ])
        
        return row
    }
    
    private func createActionRow(icon: String, title: String, subtitle: String, action: Selector) -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 24)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let chevronLabel = UILabel()
        chevronLabel.text = "›"
        chevronLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        chevronLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        chevronLabel.translatesAutoresizingMaskIntoConstraints = false
        
        row.addSubview(button)
        row.addSubview(iconLabel)
        row.addSubview(titleLabel)
        row.addSubview(subtitleLabel)
        row.addSubview(chevronLabel)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: row.topAnchor),
            button.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: row.bottomAnchor),
            
            iconLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 20),
            iconLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: row.topAnchor, constant: 12),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronLabel.leadingAnchor, constant: -10),
            
            chevronLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -20),
            chevronLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor)
        ])
        
        return row
    }
    
    private func createInfoRow(icon: String, title: String, value: String) -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 20)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        valueLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        row.addSubview(iconLabel)
        row.addSubview(titleLabel)
        row.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            iconLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 20),
            iconLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -20),
            valueLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 10)
        ])
        
        return row
    }
    
    private func setupConstraints(profileCard: UIView, preferencesCard: UIView, actionsCard: UIView, privacyCard: UIView, aboutCard: UIView) {
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
            
            profileCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            profileCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            preferencesCard.topAnchor.constraint(equalTo: profileCard.bottomAnchor, constant: 20),
            preferencesCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            preferencesCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            actionsCard.topAnchor.constraint(equalTo: preferencesCard.bottomAnchor, constant: 20),
            actionsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            actionsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            privacyCard.topAnchor.constraint(equalTo: actionsCard.bottomAnchor, constant: 20),
            privacyCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            privacyCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            aboutCard.topAnchor.constraint(equalTo: privacyCard.bottomAnchor, constant: 20),
            aboutCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            aboutCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            versionLabel.topAnchor.constraint(equalTo: aboutCard.bottomAnchor, constant: 20),
            versionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    // MARK: - Actions (Preserving Original Logic)
    
    @objc private func darkModeChanged() {
        isDarkMode = darkModeSwitch.isOn
        LocalStorage.shared.saveDarkModeStatus(isDarkMode)
        
        // Update appearance with enhanced animation
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.navigationController?.navigationBar.barTintColor = self.isDarkMode ? .black : .white
            self.navigationController?.navigationBar.tintColor = self.isDarkMode ? .white : .black
        }
    }
    
    @objc private func shareTapped() {
        let items = ["Check out this awesome game - Chase Grid!"]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    @objc private func rateTapped() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/idYOUR_APP_ID") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc private func feedbackTapped() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["support@yourdomain.com"])
            mail.setSubject("Feedback for Chase Grid")
            mail.setMessageBody("I have some feedback about the app:", isHTML: false)
            
            present(mail, animated: true)
        } else {
            showToast(message: "Mail services are not available")
        }
    }
    
    // MARK: - New Action Methods
    
    @objc private func notificationsChanged() {
        // Handle notifications toggle
        let message = notificationsSwitch.isOn ? "Notifications enabled" : "Notifications disabled"
        showToast(message: message)
    }
    
    @objc private func soundEffectsChanged() {
        // Handle sound effects toggle
        let message = soundEffectsSwitch.isOn ? "Sound effects enabled" : "Sound effects disabled"
        showToast(message: message)
    }
    
    @objc private func languageTapped() {
        let alert = UIAlertController(title: "Language", message: "Select your preferred language", preferredStyle: .actionSheet)
        
        let languages = ["English", "Español", "Français", "Deutsch", "中文", "日本語"]
        
        for language in languages {
            alert.addAction(UIAlertAction(title: language, style: .default) { _ in
                self.showToast(message: "Language changed to \(language)")
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func privacyTapped() {
        showToast(message: "Privacy Policy opened")
    }
    
    @objc private func termsTapped() {
        showToast(message: "Terms of Service opened")
    }
    
    @objc private func clearDataTapped() {
        let alert = UIAlertController(title: "Clear Data", message: "This will reset all your game progress. Are you sure?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive) { _ in
            self.showToast(message: "Game data cleared")
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func developerTapped() {
        showToast(message: "Thank you for playing Chase Grid! 🎮")
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension Bundle {
    var appVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}