
import Foundation

public struct device {
    
    public static var languageID: String {
        return Bundle.main.preferredLocalizations.first ?? ""
    }
}

