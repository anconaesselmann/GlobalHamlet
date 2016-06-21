import UIKit

class ImagePagesCell: AbstractSettingsCell {
    @IBOutlet weak var titleTextField: UITextField!
    override var mainText:String {
        didSet {
            titleTextField.placeholder = mainText
        }
    }
    override func getValueFromUI() -> AnyObject {
        return titleTextField.text!
    }
    @IBAction func titleTextFieldAction(sender: AnyObject) {
        setValue()
    }
}