import UIKit

public class TextViewCell:AbstractSettingsCell, UITextViewDelegate {
    override var model:SettingModel! {
        didSet {
            model.cellHeight = CGFloat(200)
        }
    }
    override func getValueFromUI() -> AnyObject {
        guard textView != nil else {
            return ""
        }
        return textView.text!
    }
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var textView: UITextView!
    
    public func textViewDidChange(textView: UITextView) {
        setValue()
    }
    public func textViewDidEndEditing(textView: UITextView) {
//        self.textView.removeFromSuperview()
//        self.textView = nil
    }
    override func mainCellTapAction(sender: AnyObject) {
        print("creating text view")
        if textView == nil {
            createTextView()
        }
    }
    
    func createTextView() {
//        mainCellView.translatesAutoresizingMaskIntoConstraints = false;
        
        let screenSize: CGRect = mainCellView.bounds;
        let screenWidth = screenSize.width;
        let screenHeight = screenSize.height;
        
        let frame = CGRect(x: 0,y: 0, width: screenWidth, height: screenHeight)

        textView = UITextView(frame : frame);
        
//        textView.backgroundColor = UIColor( red: 0.9, green: 0.9, blue:0.9, alpha: 1.0 );
        
//        textView.text = NSLocalizedString("Start typing... maybe...", comment: "");
        
        mainCellView.addSubview(textView);
        textView.delegate = self
        textView.becomeFirstResponder()
    }
}
