import UIKit

public class ToggleCell:AbstractSettingsCell {
    override var model:SettingModel! {
        didSet {
            model.cellHeight = CGFloat(22)
        }
    }
    var activeButton = 0
    struct Colors {
        let backgroundSelected   = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        let backgroundUnselected = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let textUnselected       = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let textSelected         = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBAction func leftButtonAction(sender: UIButton) {
        buttonPressed(0)
    }
    @IBAction func rightButtonAction(sender: UIButton) {
        buttonPressed(1)
    }
    func buttonPressed(buttonNbr:Int) {
        if buttonNbr == 0 {
            leftButton.backgroundColor = Colors().backgroundUnselected
            rightButton.backgroundColor = Colors().backgroundSelected
            leftButton.setTitleColor(Colors().textSelected, forState: UIControlState.Highlighted)
            leftButton.setTitleColor(Colors().textSelected, forState: UIControlState.Normal)
            rightButton.setTitleColor(Colors().textUnselected, forState: UIControlState.Normal)
            rightButton.setTitleColor(Colors().textUnselected, forState: UIControlState.Normal)
        } else {
            rightButton.backgroundColor = Colors().backgroundUnselected
            leftButton.backgroundColor = Colors().backgroundSelected
            rightButton.setTitleColor(Colors().textSelected, forState: UIControlState.Highlighted)
            rightButton.setTitleColor(Colors().textSelected, forState: UIControlState.Normal)
            leftButton.setTitleColor(Colors().textUnselected, forState: UIControlState.Normal)
            leftButton.setTitleColor(Colors().textUnselected, forState: UIControlState.Normal)
        }
        activeButton = buttonNbr
        setValue()
    }
    override func getValueFromUI() -> AnyObject {
        return activeButton
    }
    override public func awakeFromNib() {
        super.awakeFromNib()
        buttonPressed(0)
        leftButton?.setTitle("offer", forState: .Normal)
        rightButton?.setTitle("ask", forState: .Normal)
    }
}
