import UIKit

public class TitleCell:AbstractSettingsCell {
    @IBOutlet weak var titleTextField: UITextField!
    var hasBeenFirsResponder = false
    override var mainText:String {
        didSet {
            titleTextField.placeholder = mainText
            if !hasBeenFirsResponder {
                titleTextField.becomeFirstResponder()
                hasBeenFirsResponder = true
            }
        }
    }
    override func getValueFromUI() -> AnyObject {
        return titleTextField.text!
    }
    @IBAction func titleTextFieldAction(sender: AnyObject) {
        setValue()
    }
}
