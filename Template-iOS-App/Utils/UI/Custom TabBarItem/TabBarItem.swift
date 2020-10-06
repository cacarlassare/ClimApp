
import UIKit

class TabBarItem: UITabBarItem {

    open override func awakeFromNib() {
        super.awakeFromNib()

        if let text = self.title {
            self.title = text.localized
        }
    }
}
