import UIKit

class GradientHelper {
    
    enum GradientType {
        case mainMenu
        case gameScreen
        case settings
        case gameOver
        case levelComplete
    }
    
    static func applyGradient(to view: UIView, type: GradientType) {
        // Remove existing gradient layers
        view.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        switch type {
        case .mainMenu:
            gradientLayer.colors = [
                UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0).cgColor,
                UIColor(red: 0.1, green: 0.2, blue: 0.6, alpha: 1.0).cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            
        case .gameScreen:
            gradientLayer.colors = [
                UIColor(red: 0.3, green: 0.7, blue: 0.5, alpha: 1.0).cgColor,
                UIColor(red: 0.1, green: 0.5, blue: 0.3, alpha: 1.0).cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            
        case .settings:
            gradientLayer.colors = [
                UIColor(red: 0.6, green: 0.3, blue: 0.8, alpha: 1.0).cgColor,
                UIColor(red: 0.4, green: 0.1, blue: 0.6, alpha: 1.0).cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            
        case .gameOver:
            gradientLayer.colors = [
                UIColor(red: 0.8, green: 0.3, blue: 0.3, alpha: 1.0).cgColor,
                UIColor(red: 0.6, green: 0.1, blue: 0.1, alpha: 1.0).cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            
        case .levelComplete:
            gradientLayer.colors = [
                UIColor(red: 0.8, green: 0.7, blue: 0.2, alpha: 1.0).cgColor,
                UIColor(red: 0.6, green: 0.5, blue: 0.1, alpha: 1.0).cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        }
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    static func updateGradientFrame(in view: UIView) {
        if let gradientLayer = view.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
}