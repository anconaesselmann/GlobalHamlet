import UIKit
import SpriteKit

class MoreViewController: DICTableViewController, APIControllerDelegateProtocol {
    var api:ApiController!
    var url:String!
    
    override func initWithArgs(args:[AnyObject]) {
        api = args[0] as ApiController
        url = args[1] as String
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier? == "logoutTableViewCell" {
            api.delegate = self
            api.request(url + "/login/logout")
        }
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        performSegueWithIdentifier("segueToFirstLaunchView", sender: self)
    }
}