
import UIKit

class LoadingView: UIView {

    var activityView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isOpaque = true
        
        self.activityView = UIActivityIndicatorView(style: .white)
        self.addSubview(self.activityView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.activityView?.center = self.center
    }
    
    override func show() {
        super.show()
        self.activityView.startAnimating()
    }
    
    override func hide() {
        super.hide()
        self.activityView.stopAnimating()
    }
}
