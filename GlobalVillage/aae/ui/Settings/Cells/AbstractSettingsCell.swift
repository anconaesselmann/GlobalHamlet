import Foundation
import UIKit
@IBDesignable public class AbstractSettingsCell: UITableViewCell {
    var hasChangedCallback:((Void)->Void)?
    var valueHasChangedCallback:((AnyObject)->Void)?
    var delegate:UITableViewController?
    var nibName:String!
    var view: UIView!
    var model:SettingModel!
    var value:AnyObject? {
        get {
            return model.value
        }
    }
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib    = UINib(nibName: nibName, bundle: bundle)
        let view   = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    func getValueFromUI() -> AnyObject? {
        print("Has to overwrite getValueFromUI")
        return nil
    }
    func setValue() {
        guard model != nil, let value = getValueFromUI() else {
            print("UI does not have a value set yet")
            return
        }
        model.value = value
        if valueHasChangedCallback != nil {
            valueHasChangedCallback!(value)
        }
    }
    func formatValueForDisplay(value:AnyObject?) -> String {
        return "formatValueForDisplay(value:AnyObject? not overridden)"
    }
    var mainText:String = "Label" {
        didSet{
            if mainLabel != nil {
                mainLabel!.text = mainText
            }
        }
    }
    func mainCellTapAction(sender: AnyObject) {
        print("main cell tapped.")
    }
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var mainCellView: UIView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(AbstractSettingsCell.mainCellTapAction(_:)))
            tap.delegate = self
            mainCellView.addGestureRecognizer(tap)
        }
    }
}