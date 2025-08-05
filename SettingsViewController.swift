import UIKit
import MessageUI

class SettingsViewController: BaseViewController {
    
    private var darkModeSwitch: UISwitch!
    private var versionLabel: UILabel!
    private var soundVolumeSlider: UISlider!
    private var vibrationSwitch: UISwitch!
    private var difficultySegmentedControl: UISegmentedControl!
    private var autoSaveSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Settings"
    }
    
    private func setupUI() {
        view.backgroundColor = isDarkMode ? .black : .systemGray6
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        let containerView = UIView()
        scrollView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // App Preferences Section
        let preferencesCard = createSectionCard(title: "App Preferences")
        containerView.addSubview(preferencesCard)
        
        // Dark Mode Setting
        let darkModeContainer = createSettingRow(
            title: "Dark Mode",
            subtitle: "Toggle between light and dark themes",
            icon: "🌙"
        )
        
        darkModeSwitch = UISwitch()
        darkModeSwitch.isOn = isDarkMode
        darkModeSwitch.addTarget(self, action: #selector(darkModeChanged), for: .valueChanged)
        darkModeContainer.addSubview(darkModeSwitch)
        darkModeSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        // Sound Volume Setting
        let soundContainer = createSettingRow(
            title: "Sound Volume",
            subtitle: "Adjust game sound effects volume",
            icon: "🔊"
        )
        
        soundVolumeSlider = UISlider()
        soundVolumeSlider.minimumValue = 0
        soundVolumeSlider.maximumValue = 1
        soundVolumeSlider.value = UserDefaults.standard.float(forKey: "soundVolume") != 0 ? UserDefaults.standard.float(forKey: "soundVolume") : 0.8
        soundVolumeSlider.addTarget(self, action: #selector(soundVolumeChanged), for: .valueChanged)
        soundContainer.addSubview(soundVolumeSlider)
        soundVolumeSlider.translatesAutoresizingMaskIntoConstraints = false
        
        // Vibration Setting
        let vibrationContainer = createSettingRow(
            title: "Vibration",
            subtitle: "Enable haptic feedback",
            icon: "📳"
        )
        
        vibrationSwitch = UISwitch()
        vibrationSwitch.isOn = UserDefaults.standard.bool(forKey: "vibrationEnabled")
        vibrationSwitch.addTarget(self, action: #selector(vibrationChanged), for: .valueChanged)
        vibrationContainer.addSubview(vibrationSwitch)
        vibrationSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        // Auto Save Setting
        let autoSaveContainer = createSettingRow(
            title: "Auto Save",
            subtitle: "Automatically save game progress",
            icon: "💾"
        )
        
        autoSaveSwitch = UISwitch()
        autoSaveSwitch.isOn = UserDefaults.standard.bool(forKey: "autoSaveEnabled")
        autoSaveSwitch.addTarget(self, action: #selector(autoSaveChanged), for: .valueChanged)
        autoSaveContainer.addSubview(autoSaveSwitch)
        autoSaveSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        let preferencesStack = UIStackView(arrangedSubviews: [
            darkModeContainer, soundContainer, vibrationContainer, autoSaveContainer
        ])
        preferencesStack.axis = .vertical
        preferencesStack.spacing = 0
        preferencesCard.addSubview(preferencesStack)
        preferencesStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Game Settings Section
        let gameCard = createSectionCard(title: "Game Settings")
        containerView.addSubview(gameCard)
        
        // Difficulty Setting
        let difficultyContainer = createSettingRow(
            title: "Default Difficulty",
            subtitle: "Choose your preferred difficulty level",
            icon: "⚡"
        )
        
        difficultySegmentedControl = UISegmentedControl(items: ["Easy", "Medium", "Hard"])
        difficultySegmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "defaultDifficulty")
        difficultySegmentedControl.addTarget(self, action: #selector(difficultyChanged), for: .valueChanged)
        difficultyContainer.addSubview(difficultySegmentedControl)
        difficultySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        gameCard.addSubview(difficultyContainer)
        difficultyContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Actions Section
        let actionsCard = createSectionCard(title: "Actions")
        containerView.addSubview(actionsCard)
        
        // Share Button
        let shareButton = createActionButton(title: "Share App", icon: "📤", color: .systemBlue)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        
        // Rate Button
        let rateButton = createActionButton(title: "Rate App", icon: "⭐", color: .systemOrange)
        rateButton.addTarget(self, action: #selector(rateTapped), for: .touchUpInside)
        
        // Feedback Button
        let feedbackButton = createActionButton(title: "Send Feedback", icon: "💬", color: .systemGreen)
        feedbackButton.addTarget(self, action: #selector(feedbackTapped), for: .touchUpInside)
        
        // Reset Button
        let resetButton = createActionButton(title: "Reset Progress", icon: "🗑️", color: .systemRed)
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        
        let actionsStack = UIStackView(arrangedSubviews: [
            shareButton, rateButton, feedbackButton, resetButton
        ])
        actionsStack.axis = .vertical
        actionsStack.spacing = 12
        actionsStack.distribution = .fillEqually
        
        actionsCard.addSubview(actionsStack)
        actionsStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Info Section
        let infoCard = createSectionCard(title: "App Information")
        containerView.addSubview(infoCard)
        
        // Version Label
        versionLabel = UILabel()
        versionLabel.text = "Version \(Bundle.main.appVersion) (Build \(Bundle.main.buildNumber))"
        versionLabel.textColor = isDarkMode ? .lightGray : .darkGray
        versionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        versionLabel.textAlignment = .center
        
        // Developer Label
        let developerLabel = UILabel()
        developerLabel.text = "Developed with ❤️"
        developerLabel.textColor = isDarkMode ? .lightGray : .darkGray
        developerLabel.font = UIFont.systemFont(ofSize: 12)
        developerLabel.textAlignment = .center
        
        let infoStack = UIStackView(arrangedSubviews: [versionLabel, developerLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 8
        infoCard.addSubview(infoStack)
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        NSLayoutConstraint.activate([
            // Preferences Card
            preferencesCard.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            preferencesCard.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            preferencesCard.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            preferencesStack.topAnchor.constraint(equalTo: preferencesCard.topAnchor, constant: 50),
            preferencesStack.leadingAnchor.constraint(equalTo: preferencesCard.leadingAnchor),
            preferencesStack.trailingAnchor.constraint(equalTo: preferencesCard.trailingAnchor),
            preferencesStack.bottomAnchor.constraint(equalTo: preferencesCard.bottomAnchor, constant: -16),
            
            // Dark Mode Switch
            darkModeSwitch.centerYAnchor.constraint(equalTo: darkModeContainer.centerYAnchor),
            darkModeSwitch.trailingAnchor.constraint(equalTo: darkModeContainer.trailingAnchor, constant: -16),
            
            // Sound Slider
            soundVolumeSlider.centerYAnchor.constraint(equalTo: soundContainer.centerYAnchor),
            soundVolumeSlider.trailingAnchor.constraint(equalTo: soundContainer.trailingAnchor, constant: -16),
            soundVolumeSlider.widthAnchor.constraint(equalToConstant: 120),
            
            // Vibration Switch
            vibrationSwitch.centerYAnchor.constraint(equalTo: vibrationContainer.centerYAnchor),
            vibrationSwitch.trailingAnchor.constraint(equalTo: vibrationContainer.trailingAnchor, constant: -16),
            
            // Auto Save Switch
            autoSaveSwitch.centerYAnchor.constraint(equalTo: autoSaveContainer.centerYAnchor),
            autoSaveSwitch.trailingAnchor.constraint(equalTo: autoSaveContainer.trailingAnchor, constant: -16),
            
            // Game Card
            gameCard.topAnchor.constraint(equalTo: preferencesCard.bottomAnchor, constant: 20),
            gameCard.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            gameCard.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            difficultyContainer.topAnchor.constraint(equalTo: gameCard.topAnchor, constant: 50),
            difficultyContainer.leadingAnchor.constraint(equalTo: gameCard.leadingAnchor),
            difficultyContainer.trailingAnchor.constraint(equalTo: gameCard.trailingAnchor),
            difficultyContainer.bottomAnchor.constraint(equalTo: gameCard.bottomAnchor, constant: -16),
            
            difficultySegmentedControl.topAnchor.constraint(equalTo: difficultyContainer.topAnchor, constant: 35),
            difficultySegmentedControl.leadingAnchor.constraint(equalTo: difficultyContainer.leadingAnchor, constant: 16),
            difficultySegmentedControl.trailingAnchor.constraint(equalTo: difficultyContainer.trailingAnchor, constant: -16),
            
            // Actions Card
            actionsCard.topAnchor.constraint(equalTo: gameCard.bottomAnchor, constant: 20),
            actionsCard.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            actionsCard.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            actionsStack.topAnchor.constraint(equalTo: actionsCard.topAnchor, constant: 50),
            actionsStack.leadingAnchor.constraint(equalTo: actionsCard.leadingAnchor, constant: 16),
            actionsStack.trailingAnchor.constraint(equalTo: actionsCard.trailingAnchor, constant: -16),
            actionsStack.bottomAnchor.constraint(equalTo: actionsCard.bottomAnchor, constant: -16),
            
            // Info Card
            infoCard.topAnchor.constraint(equalTo: actionsCard.bottomAnchor, constant: 20),
            infoCard.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            infoCard.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            infoCard.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            
            infoStack.topAnchor.constraint(equalTo: infoCard.topAnchor, constant: 50),
            infoStack.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor, constant: 16),
            infoStack.trailingAnchor.constraint(equalTo: infoCard.trailingAnchor, constant: -16),
            infoStack.bottomAnchor.constraint(equalTo: infoCard.bottomAnchor, constant: -16)
        ])
    }
    
    private func createSectionCard(title: String) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = isDarkMode ? .systemGray6 : .white
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = isDarkMode ? 0.3 : 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 8
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = isDarkMode ? .white : .black
        cardView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
        
        return cardView
    }
    
    private func createSettingRow(title: String, subtitle: String, icon: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 24)
        iconLabel.textAlignment = .center
        container.addSubview(iconLabel)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = isDarkMode ? .white : .black
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = isDarkMode ? .lightGray : .gray
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        container.addSubview(textStack)
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Add separator line
        let separator = UIView()
        separator.backgroundColor = isDarkMode ? .systemGray4 : .systemGray5
        container.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            iconLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 30),
            
            textStack.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),
            textStack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            separator.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            separator.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        return container
    }
    
    private func createActionButton(title: String, icon: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 20)
        iconLabel.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        
        let stackView = UIStackView(arrangedSubviews: [iconLabel, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = false
        
        button.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = color
        button.layer.cornerRadius = 12
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 25)
        ])
        
        return button
    }
    
    @objc private func darkModeChanged() {
        isDarkMode = darkModeSwitch.isOn
        // Refresh UI with new theme
        setupUI()
    }
    
    @objc private func soundVolumeChanged() {
        UserDefaults.standard.set(soundVolumeSlider.value, forKey: "soundVolume")
    }
    
    @objc private func vibrationChanged() {
        UserDefaults.standard.set(vibrationSwitch.isOn, forKey: "vibrationEnabled")
    }
    
    @objc private func autoSaveChanged() {
        UserDefaults.standard.set(autoSaveSwitch.isOn, forKey: "autoSaveEnabled")
    }
    
    @objc private func difficultyChanged() {
        UserDefaults.standard.set(difficultySegmentedControl.selectedSegmentIndex, forKey: "defaultDifficulty")
    }
    
    @objc private func shareTapped() {
        let text = "Check out this awesome Flow Free game!"
        let url = URL(string: "https://yourappstorelink.com")!
        
        let activityVC = UIActivityViewController(
            activityItems: [text, url],
            applicationActivities: nil
        )
        
        present(activityVC, animated: true)
    }
    
    @objc private func rateTapped() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/idYOUR_APP_ID?action=write-review") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        } else {
            showToast(message: "Could not open App Store")
        }
    }
    
    @objc private func feedbackTapped() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["support@yourcompany.com"])
            mail.setSubject("Feedback for Flow Free Mini")
            mail.setMessageBody("Hello,\n\nI have some feedback about the app:", isHTML: false)
            
            present(mail, animated: true)
        } else {
            showToast(message: "Mail services not available")
        }
    }
    
    @objc private func resetTapped() {
        let alert = UIAlertController(
            title: "Reset Progress",
            message: "Are you sure you want to reset all your game progress? This cannot be undone.",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let resetAction = UIAlertAction(title: "Reset", style: .destructive) { _ in
            UserDefaults.standard.removeObject(forKey: "highestUnlockedLevel")
            UserDefaults.standard.removeObject(forKey: "scores")
            self.showToast(message: "Progress has been reset")
        }
        
        alert.addAction(cancelAction)
        alert.addAction(resetAction)
        
        present(alert, animated: true)
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        
        switch result {
        case .sent:
            showToast(message: "Feedback sent. Thank you!")
        case .failed:
            showToast(message: "Failed to send feedback")
        default:
            break
        }
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