import UIKit

class SplashViewController: BaseViewController {
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Blend & Split"
        label.font = UIFont(name: "Chalkduster", size: 32)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Perfect Mix, Perfect Split"
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "v1.0.0"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progressTintColor = UIColor.systemBlue
        progress.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.layer.cornerRadius = 2
        progress.clipsToBounds = true
        return progress
    }()
    
    private let decorativeView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let decorativeView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let decorativeView3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupView()
        startAnimations()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigateToHome()
        }
    }
    
    // MARK: - Setup Methods
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemIndigo.cgColor,
            UIColor.systemPurple.cgColor,
            UIColor.systemBlue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupView() {
        // Add all subviews
        view.addSubview(decorativeView1)
        view.addSubview(decorativeView2)
        view.addSubview(decorativeView3)
        view.addSubview(containerView)
        containerView.addSubview(appNameLabel)
        containerView.addSubview(subtitleLabel)
        view.addSubview(loadingIndicator)
        view.addSubview(progressView)
        view.addSubview(versionLabel)
        
        setupConstraints()
        
        // Initial states for animations
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        loadingIndicator.alpha = 0
        progressView.alpha = 0
        versionLabel.alpha = 0
        
        // Decorative views initial positions
        decorativeView1.transform = CGAffineTransform(translationX: -200, y: -200)
        decorativeView2.transform = CGAffineTransform(translationX: 200, y: -150)
        decorativeView3.transform = CGAffineTransform(translationX: -150, y: 200)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            containerView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40),
            containerView.heightAnchor.constraint(equalToConstant: 120),
            
            // App name label
            appNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            appNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            appNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            // Subtitle label
            subtitleLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            subtitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            
            // Loading indicator
            loadingIndicator.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 30),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Progress view
            progressView.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            progressView.heightAnchor.constraint(equalToConstant: 4),
            
            // Version label
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Decorative views
            decorativeView1.widthAnchor.constraint(equalToConstant: 60),
            decorativeView1.heightAnchor.constraint(equalToConstant: 60),
            decorativeView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            decorativeView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            decorativeView2.widthAnchor.constraint(equalToConstant: 50),
            decorativeView2.heightAnchor.constraint(equalToConstant: 50),
            decorativeView2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            decorativeView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            
            decorativeView3.widthAnchor.constraint(equalToConstant: 40),
            decorativeView3.heightAnchor.constraint(equalToConstant: 40),
            decorativeView3.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
            decorativeView3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80)
        ])
    }
    
    // MARK: - Animation Methods
    private func startAnimations() {
        // Animate decorative views
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseOut]) {
            self.decorativeView1.transform = .identity
        }
        
        UIView.animate(withDuration: 1.5, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseOut]) {
            self.decorativeView2.transform = .identity
        }
        
        UIView.animate(withDuration: 1.5, delay: 0.4, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseOut]) {
            self.decorativeView3.transform = .identity
        }
        
        // Animate main container
        UIView.animate(withDuration: 1.0, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [.curveEaseOut]) {
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
        
        // Animate loading indicator
        UIView.animate(withDuration: 0.5, delay: 0.8) {
            self.loadingIndicator.alpha = 1
        } completion: { _ in
            self.loadingIndicator.startAnimating()
        }
        
        // Animate progress view
        UIView.animate(withDuration: 0.5, delay: 1.0) {
            self.progressView.alpha = 1
        } completion: { _ in
            self.animateProgress()
        }
        
        // Animate version label
        UIView.animate(withDuration: 0.5, delay: 1.2) {
            self.versionLabel.alpha = 1
        }
        
        // Add rotation animation to decorative views
        addContinuousRotationAnimation()
    }
    
    private func animateProgress() {
        UIView.animate(withDuration: 1.5, delay: 0.0, options: [.curveEaseInOut]) {
            self.progressView.setProgress(1.0, animated: true)
        }
    }
    
    private func addContinuousRotationAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 8.0
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        
        decorativeView1.layer.add(rotation, forKey: "rotationAnimation1")
        
        let rotation2 = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation2.toValue = NSNumber(value: -Double.pi * 2)
        rotation2.duration = 10.0
        rotation2.isCumulative = true
        rotation2.repeatCount = Float.greatestFiniteMagnitude
        
        decorativeView2.layer.add(rotation2, forKey: "rotationAnimation2")
        
        let rotation3 = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation3.toValue = NSNumber(value: Double.pi * 2)
        rotation3.duration = 12.0
        rotation3.isCumulative = true
        rotation3.repeatCount = Float.greatestFiniteMagnitude
        
        decorativeView3.layer.add(rotation3, forKey: "rotationAnimation3")
    }
    
    // MARK: - Navigation
    private func navigateToHome() {
        let homeVC = HomeViewController()
        navigationController?.setViewControllers([homeVC], animated: true)
    }
}