
import Foundation

public extension Date {

    func dayAndMonthFormat() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "DATE_FORMATTING_DATE_AND_MONTH".localized
        let strDate = dateFormatter.string(from: self)
        
        return strDate
    }
    
    func fullDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        let date = dateFormatter.string(from: self)
        
        return date
    }

}
