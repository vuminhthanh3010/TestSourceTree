import UIKit

class SplashViewController: BaseViewController {
    
    // UI Components
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let versionLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let dotsStackView = UIStackView()
    private let featureStackView = UIStackView()
    
    // Animation properties
    private var progressTimer: Timer?
    private var dotAnimationTimer: Timer?
    private var currentDotIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startAnimations()
        
        // Original navigation logic preserved
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.navigateToHome()
        }
    }
    
    private func setupUI() {
        setupContainerView()
        setupTitleSection()
        setupLoadingSection()
        setupFeatureHighlights()
        setupVersionInfo()
        setupConstraints()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTitleSection() {
        // Main title with enhanced styling
        titleLabel.text = "Flow Free Mini"
        titleLabel.font = UIFont(name: "Chalkduster", size: 36)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        // Enhanced shadow effect
        titleLabel.layer.shadowColor = UIColor.cyan.cgColor
        titleLabel.layer.shadowRadius = 5
        titleLabel.layer.shadowOpacity = 0.8
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        // Subtitle with different styling
        subtitleLabel.text = "Nối Màu Không Cắt"
        subtitleLabel.font = UIFont(name: "Chalkduster", size: 18)
        subtitleLabel.textColor = UIColor.cyan
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLoadingSection() {
        // Loading indicator
        loadingIndicator.color = .white
        loadingIndicator.hidesWhenStopped = true
        
        // Progress bar
        progressView.progressTintColor = .cyan
        progressView.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        progressView.layer.cornerRadius = 2
        progressView.clipsToBounds = true
        
        // Animated dots
        dotsStackView.axis = .horizontal
        dotsStackView.spacing = 8
        dotsStackView.distribution = .equalSpacing
        
        for i in 0..<5 {
            let dot = UIView()
            dot.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            dot.layer.cornerRadius = 4
            dot.tag = i
            
            dotsStackView.addArrangedSubview(dot)
            
            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: 8),
                dot.heightAnchor.constraint(equalToConstant: 8)
            ])
        }
        
        containerView.addSubview(loadingIndicator)
        containerView.addSubview(progressView)
        containerView.addSubview(dotsStackView)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        dotsStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupFeatureHighlights() {
        featureStackView.axis = .vertical
        featureStackView.spacing = 12
        featureStackView.distribution = .equalSpacing
        
        let features = [
            ("🎮", "Puzzle Game"),
            ("🌈", "Colorful Paths"),
            ("🧠", "Brain Training"),
            ("⭐", "Multiple Levels")
        ]
        
        for (emoji, text) in features {
            let featureView = createFeatureView(emoji: emoji, text: text)
            featureStackView.addArrangedSubview(featureView)
        }
        
        containerView.addSubview(featureStackView)
        featureStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func createFeatureView(emoji: String, text: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        
        let emojiLabel = UILabel()
        emojiLabel.text = emoji
        emojiLabel.font = UIFont.systemFont(ofSize: 20)
        emojiLabel.textAlignment = .center
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textLabel.textColor = .white
        textLabel.textAlignment = .left
        
        containerView.addSubview(emojiLabel)
        containerView.addSubview(textLabel)
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 40),
            
            emojiLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            emojiLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 30),
            
            textLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 8),
            textLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            textLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
        
        return containerView
    }
    
    private func setupVersionInfo() {
        versionLabel.text = "Version 1.0.0"
        versionLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        versionLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        versionLabel.textAlignment = .center
        
        view.addSubview(versionLabel)
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            containerView.heightAnchor.constraint(equalToConstant: 400),
            
            // Title section
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -20),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -20),
            
            // Loading section
            loadingIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 25),
            
            progressView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            progressView.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 15),
            progressView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
            progressView.heightAnchor.constraint(equalToConstant: 4),
            
            dotsStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dotsStackView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 15),
            
            // Feature highlights
            featureStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            featureStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            featureStackView.topAnchor.constraint(equalTo: dotsStackView.bottomAnchor, constant: 25),
            featureStackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -20),
            
            // Version info
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func startAnimations() {
        // Start loading indicator
        loadingIndicator.startAnimating()
        
        // Animate title with pulsing effect
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.titleLabel.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        })
        
        // Animate progress bar
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            DispatchQueue.main.async {
                let currentProgress = self.progressView.progress
                if currentProgress < 1.0 {
                    self.progressView.setProgress(currentProgress + 0.025, animated: true)
                }
            }
        }
        
        // Animate dots
        dotAnimationTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            self.animateDots()
        }
        
        // Animate feature views with staggered entrance
        for (index, featureView) in featureStackView.arrangedSubviews.enumerated() {
            featureView.alpha = 0
            featureView.transform = CGAffineTransform(translationX: -50, y: 0)
            
            UIView.animate(withDuration: 0.6, delay: Double(index) * 0.2, options: .curveEaseOut, animations: {
                featureView.alpha = 1
                featureView.transform = .identity
            })
        }
    }
    
    private func animateDots() {
        // Reset all dots
        for dot in dotsStackView.arrangedSubviews {
            dot.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            dot.transform = .identity
        }
        
        // Animate current dot
        if currentDotIndex < dotsStackView.arrangedSubviews.count {
            let currentDot = dotsStackView.arrangedSubviews[currentDotIndex]
            currentDot.backgroundColor = .cyan
            
            UIView.animate(withDuration: 0.2, animations: {
                currentDot.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    currentDot.transform = .identity
                }
            }
        }
        
        currentDotIndex = (currentDotIndex + 1) % dotsStackView.arrangedSubviews.count
    }
    
    private func stopAnimations() {
        progressTimer?.invalidate()
        dotAnimationTimer?.invalidate()
        loadingIndicator.stopAnimating()
        titleLabel.layer.removeAllAnimations()
    }
    
    // Original navigation logic preserved
    private func navigateToHome() {
        stopAnimations()
        let homeVC = HomeViewController()
        navigationController?.setViewControllers([homeVC], animated: true)
    }
    
    deinit {
        stopAnimations()
    }
}