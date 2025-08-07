import UIKit

class SplashViewController: BaseViewController {
    
    private var loadingProgressView: UIProgressView!
    private var loadingLabel: UILabel!
    private var versionLabel: UILabel!
    private var companyLabel: UILabel!
    private var particleViews: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startLoadingAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigateToHome()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update gradient frame when layout changes
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
    
    private func setupUI() {
        setupGradientBackground()
        setupParticleAnimation()
        setupMainContent()
        setupLoadingIndicator()
        setupFooterContent()
    }
    
    private func setupGradientBackground() {
        // Multi-color animated gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(hex: "#667eea").cgColor,
            UIColor(hex: "#764ba2").cgColor,
            UIColor(hex: "#f093fb").cgColor,
            UIColor(hex: "#f5576c").cgColor,
            UIColor(hex: "#4facfe").cgColor
        ]
        gradientLayer.locations = [0.0, 0.25, 0.5, 0.75, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Animate gradient colors
        let colorAnimation = CABasicAnimation(keyPath: "colors")
        colorAnimation.duration = 3.0
        colorAnimation.repeatCount = .infinity
        colorAnimation.autoreverses = true
        colorAnimation.fromValue = gradientLayer.colors
        colorAnimation.toValue = [
            UIColor(hex: "#2575FC").cgColor,
            UIColor(hex: "#6A11CB").cgColor,
            UIColor(hex: "#FF6B6B").cgColor,
            UIColor(hex: "#4ECDC4").cgColor,
            UIColor(hex: "#45B7D1").cgColor
        ]
        gradientLayer.add(colorAnimation, forKey: "colorAnimation")
    }
    
    private func setupParticleAnimation() {
        // Create floating particles for visual interest
        for i in 0..<15 {
            let particle = UIView()
            let size = CGFloat.random(in: 3...8)
            particle.frame = CGRect(x: CGFloat.random(in: 0...view.bounds.width), 
                                  y: CGFloat.random(in: 0...view.bounds.height), 
                                  width: size, height: size)
            particle.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            particle.layer.cornerRadius = size / 2
            particle.alpha = CGFloat.random(in: 0.3...0.8)
            
            view.addSubview(particle)
            particleViews.append(particle)
            
            // Animate particles
            UIView.animate(withDuration: Double.random(in: 3...6), 
                          delay: Double(i) * 0.1, 
                          options: [.repeat, .autoreverse, .curveEaseInOut], 
                          animations: {
                particle.transform = CGAffineTransform(translationX: CGFloat.random(in: -50...50), 
                                                     y: CGFloat.random(in: -100...100))
            })
        }
    }
    
    private func setupMainContent() {
        // Container view for main content
        let contentContainer = UIView()
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentContainer)
        
        // App icon placeholder (using styled view instead of image)
        let iconContainer = UIView()
        iconContainer.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        iconContainer.layer.cornerRadius = 30
        iconContainer.layer.borderWidth = 2
        iconContainer.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let iconLabel = UILabel()
        iconLabel.text = "CG"
        iconLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        iconLabel.textColor = .white
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        iconContainer.addSubview(iconLabel)
        contentContainer.addSubview(iconContainer)
        
        // App name with modern styling
        let appNameLabel = UILabel()
        appNameLabel.text = "Chase Grid"
        appNameLabel.font = UIFont.systemFont(ofSize: 36, weight: .black)
        appNameLabel.textColor = .white
        appNameLabel.textAlignment = .center
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add shadow to text
        appNameLabel.layer.shadowColor = UIColor.black.cgColor
        appNameLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        appNameLabel.layer.shadowOpacity = 0.3
        appNameLabel.layer.shadowRadius = 4
        
        contentContainer.addSubview(appNameLabel)
        
        // Tagline
        let taglineLabel = UILabel()
        taglineLabel.text = "Experience the Future"
        taglineLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        taglineLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        taglineLabel.textAlignment = .center
        taglineLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(taglineLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            contentContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            contentContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            iconContainer.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            iconContainer.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 60),
            iconContainer.heightAnchor.constraint(equalToConstant: 60),
            
            iconLabel.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            
            appNameLabel.topAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: 20),
            appNameLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            
            taglineLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 8),
            taglineLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            taglineLabel.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor)
        ])
        
        // Enhanced animations
        contentContainer.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        contentContainer.alpha = 0
        
        UIView.animate(withDuration: 1.2, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [], animations: {
            contentContainer.transform = .identity
            contentContainer.alpha = 1
        })
        
        // Icon pulse animation
        UIView.animate(withDuration: 2.0, delay: 1.0, options: [.repeat, .autoreverse], animations: {
            iconContainer.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
    }
    
    private func setupLoadingIndicator() {
        // Loading container
        let loadingContainer = UIView()
        loadingContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingContainer)
        
        // Loading label
        loadingLabel = UILabel()
        loadingLabel.text = "Loading..."
        loadingLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        loadingLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        loadingLabel.textAlignment = .center
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Progress view
        loadingProgressView = UIProgressView(progressViewStyle: .default)
        loadingProgressView.progressTintColor = .white
        loadingProgressView.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        loadingProgressView.layer.cornerRadius = 2
        loadingProgressView.clipsToBounds = true
        loadingProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        loadingContainer.addSubview(loadingLabel)
        loadingContainer.addSubview(loadingProgressView)
        
        NSLayoutConstraint.activate([
            loadingContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            loadingContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            loadingLabel.topAnchor.constraint(equalTo: loadingContainer.topAnchor),
            loadingLabel.centerXAnchor.constraint(equalTo: loadingContainer.centerXAnchor),
            
            loadingProgressView.topAnchor.constraint(equalTo: loadingLabel.bottomAnchor, constant: 12),
            loadingProgressView.leadingAnchor.constraint(equalTo: loadingContainer.leadingAnchor),
            loadingProgressView.trailingAnchor.constraint(equalTo: loadingContainer.trailingAnchor),
            loadingProgressView.heightAnchor.constraint(equalToConstant: 4),
            loadingProgressView.bottomAnchor.constraint(equalTo: loadingContainer.bottomAnchor)
        ])
    }
    
    private func setupFooterContent() {
        // Version info
        versionLabel = UILabel()
        versionLabel.text = "Version 1.0.0"
        versionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        versionLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        versionLabel.textAlignment = .center
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Company info
        companyLabel = UILabel()
        companyLabel.text = "© 2024 Chase Grid Inc."
        companyLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
        companyLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        companyLabel.textAlignment = .center
        companyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(versionLabel)
        view.addSubview(companyLabel)
        
        NSLayoutConstraint.activate([
            companyLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            companyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            versionLabel.bottomAnchor.constraint(equalTo: companyLabel.topAnchor, constant: -8),
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Fade in animation for footer
        versionLabel.alpha = 0
        companyLabel.alpha = 0
        
        UIView.animate(withDuration: 1.0, delay: 1.5, animations: {
            self.versionLabel.alpha = 1
            self.companyLabel.alpha = 1
        })
    }
    
    private func startLoadingAnimation() {
        loadingProgressView.setProgress(0, animated: false)
        
        // Animate loading text
        let loadingTexts = ["Loading...", "Initializing...", "Almost Ready...", "Welcome!"]
        var currentIndex = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if currentIndex < loadingTexts.count {
                UIView.transition(with: self.loadingLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.loadingLabel.text = loadingTexts[currentIndex]
                })
                currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
        
        // Animate progress bar
        UIView.animate(withDuration: 1.8, delay: 0.2, options: .curveEaseInOut, animations: {
            self.loadingProgressView.setProgress(1.0, animated: true)
        })
    }
    
    private func navigateToHome() {
        let homeVC = HomeViewController()
        navigationController?.setViewControllers([homeVC], animated: true)
    }
}

// Extension for hex color support
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