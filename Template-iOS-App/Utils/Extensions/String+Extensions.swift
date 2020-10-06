import UIKit

public extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
