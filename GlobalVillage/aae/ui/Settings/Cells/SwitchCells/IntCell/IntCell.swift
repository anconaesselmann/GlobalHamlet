import Foundation
import UIKit

@IBDesignable public class IntCell: AbstractSwitchCell, UIPickerViewDelegate, UIPickerViewDataSource {
    var pickerSelection:AnyObject?
    @IBOutlet weak var picker: UIPickerView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        picker.delegate   = self
        picker.dataSource = self
        expandedHeight    = CGFloat(200)
    }
    override func getValueFromUI() -> AnyObject? {
        guard let intModel = model as? SwitchCellModelProtocol else {
            return nil
        }
        if pickerSelection == nil {
            pickerSelection = intModel.getDataAtIndex(0)
        }
        return pickerSelection
    }
    override func formatValueForDisplay(value:AnyObject?) -> String {
        return (value != nil) ? "\(value!)" : ""
    }
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let intModel = model as? SwitchCellModelProtocol else {
            return
        }
        pickerSelection = intModel.getDataAtIndex(row)
        setValue()
    }
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int { return 1 }
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        guard let intModel = model as? SwitchCellModelProtocol else {
            return 0
        }
        return intModel.count
    }
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let intModel = model as? SwitchCellModelProtocol else {
            return nil
        }
        return String(intModel.getDataAtIndex(row))
    }
}