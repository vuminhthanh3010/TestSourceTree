import UIKit

protocol GameBoardViewDelegate: AnyObject {
    func didSelectTile(at position: Int)
}

class GameBoardView: UIView {
    
    weak var delegate: GameBoardViewDelegate?
    private var gameModel: GameModel
    private var tileButtons: [TileButton] = []
    
    init(gameModel: GameModel) {
        self.gameModel = gameModel
        super.init(frame: .zero)
        setupBoard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBoard() {
        // Clear existing tiles
        tileButtons.forEach { $0.removeFromSuperview() }
        tileButtons.removeAll()
        
        let gridSize = gameModel.gridSize
        let tileSize: CGFloat = 280 / CGFloat(gridSize) - 10
        let spacing: CGFloat = 10
        
        for position in 0..<(gridSize * gridSize) {
            let row = position / gridSize
            let col = position % gridSize
            
            let tileButton = TileButton()
            tileButton.position = position
            tileButton.translatesAutoresizingMaskIntoConstraints = false
            tileButton.addTarget(self, action: #selector(tileButtonTapped(_:)), for: .touchUpInside)
            
            addSubview(tileButton)
            tileButtons.append(tileButton)
            
            NSLayoutConstraint.activate([
                tileButton.widthAnchor.constraint(equalToConstant: tileSize),
                tileButton.heightAnchor.constraint(equalToConstant: tileSize),
                tileButton.leftAnchor.constraint(equalTo: leftAnchor, constant: CGFloat(col) * (tileSize + spacing)),
                tileButton.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(row) * (tileSize + spacing))
            ])
        }
        
        updateDisplay()
    }
    
    func updateDisplay() {
        for (index, button) in tileButtons.enumerated() {
            if let tile = gameModel.getTileAt(position: index) {
                button.configure(with: tile)
            }
        }
    }
    
    @objc private func tileButtonTapped(_ sender: TileButton) {
        delegate?.didSelectTile(at: sender.position)
    }
    
    func animateWrongSelection(at position: Int) {
        guard position < tileButtons.count else { return }
        tileButtons[position].animateWrongSelection()
    }
    
    func animateCorrectSelection(at position: Int) {
        guard position < tileButtons.count else { return }
        tileButtons[position].animateCorrectSelection()
    }
}

class TileButton: UIButton {
    
    var position: Int = 0
    private var isFlipped: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        // Add touch feedback
        addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func buttonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.identity
        }
    }
    
    func configure(with tile: GameTile) {
        if tile.isRevealed {
            showNumber(tile.number, isCompleted: tile.isCompleted)
        } else {
            showBackSide()
        }
    }
    
    private func showNumber(_ number: Int, isCompleted: Bool) {
        setTitle("\(number)", for: .normal)
        
        if isCompleted {
            backgroundColor = UIColor.green.withAlphaComponent(0.7)
            setTitleColor(.white, for: .normal)
            isEnabled = false
        } else {
            backgroundColor = UIColor.white.withAlphaComponent(0.9)
            setTitleColor(.black, for: .normal)
            isEnabled = true
        }
        
        if !isFlipped {
            flipToFront()
        }
    }
    
    private func showBackSide() {
        setTitle("?", for: .normal)
        backgroundColor = UIColor.white.withAlphaComponent(0.3)
        setTitleColor(.white, for: .normal)
        isEnabled = true
        
        if isFlipped {
            flipToBack()
        }
    }
    
    private func flipToFront() {
        guard !isFlipped else { return }
        
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            // Animation is handled by the transition
        }) { _ in
            self.isFlipped = true
        }
    }
    
    private func flipToBack() {
        guard isFlipped else { return }
        
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromRight, animations: {
            // Animation is handled by the transition
        }) { _ in
            self.isFlipped = false
        }
    }
    
    func animateWrongSelection() {
        backgroundColor = UIColor.red.withAlphaComponent(0.7)
        
        // Shake animation
        let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shake.timingFunction = CAMediaTimingFunction(name: .linear)
        shake.duration = 0.6
        shake.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        layer.add(shake, forKey: "shake")
        
        // Reset color after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            }
        }
    }
    
    func animateCorrectSelection() {
        // Pulse animation
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform.identity
            }
        }
    }
}