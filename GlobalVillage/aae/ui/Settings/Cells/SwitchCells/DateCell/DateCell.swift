import Foundation
import UIKit

@IBDesignable public class DateCell: AbstractSwitchCell {
    @IBOutlet weak var picker: UIDatePicker!
    @IBAction func datePickerAction(sender: UIDatePicker) {
        setValue()
    }
    override func getValueFromUI() -> AnyObject {
        return picker.date
    }
    override func formatValueForDisplay(value:AnyObject?) -> String {
        guard value != nil else {
            return ""
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let strDate = dateFormatter.stringFromDate(value as! NSDate)
        return strDate
    }
}