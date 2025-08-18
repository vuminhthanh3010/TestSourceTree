import UIKit

class HowToPlayViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let backButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupContent()
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
        titleLabel.text = "How to Play"
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
        
        // Scroll View
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Content View
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
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
            
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupContent() {
        let sections = [
            ("🎯 Objective", "Memorize the positions of numbers and tap them in ascending order (1, 2, 3, etc.)"),
            ("👀 Memory Phase", "Study the board for a few seconds while numbers are visible. The timer shows how much time you have left."),
            ("🎮 Game Phase", "After numbers are hidden, tap the tiles in numerical order starting from 1."),
            ("✅ Correct Tap", "The tile stays revealed and you move to the next number."),
            ("❌ Wrong Tap", "In Casual mode: tile briefly shows then hides again. In Challenge mode: game ends immediately."),
            ("🏆 Scoring", "Points based on speed, accuracy, and difficulty level. Fewer mistakes = higher score!"),
            ("📊 Difficulty Levels", "• Easy (3×3): 9 tiles, 5 seconds to memorize\n• Medium (4×4): 16 tiles, 4 seconds to memorize\n• Hard (5×5): 25 tiles, 3 seconds to memorize"),
            ("🎮 Game Modes", "• Casual: Practice mode with unlimited attempts\n• Challenge: One mistake and you're out!"),
            ("💡 Tips", "• Focus on patterns and positions\n• Start with easy mode to learn\n• Use visual memory techniques\n• Stay calm under pressure")
        ]
        
        var previousView: UIView = contentView
        var isFirst = true
        
        for (title, description) in sections {
            let sectionView = createSectionView(title: title, description: description)
            contentView.addSubview(sectionView)
            
            NSLayoutConstraint.activate([
                sectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                sectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                sectionView.topAnchor.constraint(equalTo: isFirst ? contentView.topAnchor : previousView.bottomAnchor, constant: isFirst ? 20 : 15)
            ])
            
            previousView = sectionView
            isFirst = false
        }
        
        // Bottom constraint for content view
        NSLayoutConstraint.activate([
            previousView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func createSectionView(title: String, description: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15)
        ])
        
        return containerView
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}