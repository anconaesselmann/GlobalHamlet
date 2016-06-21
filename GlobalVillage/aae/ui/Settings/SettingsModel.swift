import Foundation
import UIKit

class SettingsModels: NSObject {
    var models:[[SettingModel]] = [[SettingModel]]()
    var delegate:UITableViewController!

    func getCellHeight(forRowAtIndexPath indexPath:NSIndexPath) -> CGFloat? {
        let cellModel = models[indexPath.section][indexPath.row]
        return cellModel.cellHeight
    }
    func getCell(atIndexPath indexPath:NSIndexPath) -> UITableViewCell? {
        let settingsModel = models[indexPath.section][indexPath.row]
        let cell = delegate.tableView.dequeueReusableCellWithIdentifier(settingsModel.identifier, forIndexPath: indexPath) as! AbstractSettingsCell
        cell.model = settingsModel
        cell.delegate = delegate
        cell.mainText = settingsModel.text
        cell.hasChangedCallback = {
            settingsModel.value = cell.value
            print(cell.value)
        }
        cell.valueHasChangedCallback = {value in
            settingsModel.value = value
            print(value)
        }
        return cell
    }
    

    override var description: String {
        return "\(models)"
    }
    func asDictionary() -> [String:AnyObject?] {
        var dict = [String:AnyObject?]()
        for section in models {
            for model in section {
                dict[model.name] = model.value
            }
        }
        return dict
    }
    
    
    //    func getModel(atIndexPath indexPath:NSIndexPath) -> SwitchCellModelProtocol? {
    //        guard models.count > indexPath.section && models[indexPath.section].count > indexPath.row else {
    //            print("Index surpassed number of sections")
    //            return nil
    //        }
    //        let model = models[indexPath.section][indexPath.row].model
    //        return model
    //    }
}