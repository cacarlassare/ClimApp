
import UIKit

public extension UIView {
    
    // MARK: - Show and Hide
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
    
    
    // MARK: - Layer
    
    func setBorder(_ width: CGFloat = 1, color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        layer.masksToBounds = true
    }
    
    func setCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
}
