import UIKit

@IBDesignable public class AbstractSwitchCell: AbstractSettingsCell  {
    var expandedHeight   = CGFloat(250)
    var contractedHeight = CGFloat(44)
    struct Static {
        static var _currentExpandedCell:AbstractSwitchCell?
    }
    func _setValueDisplay() {
        if !uiElementHidden {
            valueSwitch.hidden  = false
            valueDisplay.hidden = true
        } else if value != nil && uiElementHidden {
            valueSwitch.hidden  = true
            valueDisplay.hidden = false
            valueDisplay.text   = formatValueForDisplay(value)
        }
        
    }
    private func _setCellStatus(isExpanded: Bool) {
        guard let tableView = delegate?.tableView else {
            print("Cell has no delegate. Assign one in tableView cellForRowAtIndexPath.")
            return
        }
        model.cellHeight = (isExpanded) ? expandedHeight : contractedHeight
        uiElementHidden = !isExpanded
//        if uiElementHidden {
//            
//            let pointInTable: CGPoint = self.convertPoint(bounds.origin, toView: delegate!.tableView)
//            let cellIndexPath = delegate!.tableView.indexPathForRowAtPoint(pointInTable)
//            
//            delegate!.tableView.scrollToRowAtIndexPath(cellIndexPath!, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
//        }
        tableView.scrollEnabled = false
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.scrollEnabled = true
        if value == nil && !uiElementHidden {
            setValue()
        }
        if hasChangedCallback != nil {
            hasChangedCallback!()
        }
        _setValueDisplay()
    }
    private func _contractOtherCells() {
        if !uiElementHidden {
            if AbstractSwitchCell.Static._currentExpandedCell != nil &&
               AbstractSwitchCell.Static._currentExpandedCell != self
            {
                AbstractSwitchCell.Static._currentExpandedCell?._setCellStatus(false)
            }
            AbstractSwitchCell.Static._currentExpandedCell = self
        }
    }
    private var uiElementHidden = true {
        didSet {
            _contractOtherCells()
        }
    }
    
    override var value:AnyObject? {
        get {
            if _hasValue {
                return model.value
            } else {
                return nil
            }
        }
    }
    private var _hasValue = false {
        didSet {
            if _hasValue && model.value == nil {
                uiElementHidden = false
                valueSwitch.setOn(true, animated: true);
                uiElementHidden = false
                _setCellStatus(!uiElementHidden)
            } else if !_hasValue {
                model.value = nil
            }
        }
    }
    func _expandCell() {
        if _hasValue {
            print(_hasValue)
            uiElementHidden = !uiElementHidden
            _setCellStatus(!uiElementHidden)
        } else {
            _hasValue = true
        }
    }
    override func mainCellTapAction(sender: AnyObject) {
        _expandCell()
    }
    @IBOutlet weak var valueDisplay: UILabel!
    @IBOutlet weak var valueSwitch: UISwitch!
    @IBAction func valueSwitchAction(sender: AnyObject) {
        _hasValue = !_hasValue
        print(_hasValue)
        _setCellStatus(_hasValue)
    }
}
