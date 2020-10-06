
import UIKit

@objc protocol EmptyDataViewDelegate {
    @objc optional func refreshAction()
}

class EmptyDataView: UIView {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    
    var delegate: EmptyDataViewDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.reloadButton.addTarget(self, action: #selector(self.refreshButtonAction), for: .touchUpInside)
        self.reloadButton.setTitle("EMPTY_DATA_VIEW_REFRESH_BUTTON_TITLE".localized, for: .normal) 
    }
    
    @objc fileprivate func refreshButtonAction() {
        DispatchQueue.main.async {
            self.delegate?.refreshAction?()
        }
    }
}
