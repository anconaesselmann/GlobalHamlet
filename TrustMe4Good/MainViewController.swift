import UIKit
import SpriteKit

class MainViewController: DICTableViewController, UpdateDelegateProtocol, APIControllerDelegateProtocol {
    var activities:Activities!
    var api:ApiController!
    var url:String!
    var loadingView:LoadingIndicator!
    
    override func initWithArgs(args:[AnyObject]) {
        api = args[0] as ApiController
        url = args[1] as String
        
        loadingView = LoadingIndicator(del: self)
        activities = Activities()
        api.delegate = activities
        activities.delegate = self
        
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        api.delegate = self
        api.request(url + "/login/logout")
    }

    func didReceiveAPIResults(results: NSDictionary) {
        performSegueWithIdentifier("SegueToFirstLaunchView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = "activities"
        loadActivities()
    }
    func loadActivities() {
        loadingView.start()
        api.request(url + "/activity/get_activity")
    }
    func updateDelegate() {
        loadingView.stop()
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.activities.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ActivityPrototypeCell") as UITableViewCell
        var connection: Activity = activities.activities[indexPath.row] as Activity
        cell.textLabel.text = connection.displayString()
        /*if toDoItem.completed {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None;
        }*/
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        var tappedItem = activities.activities[indexPath.row] as Activity
        performSegueWithIdentifier("SegueToSendMessage", sender: tappedItem)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier? == "SegueToSendMessage" {
            var tappedItem: UserDetails = sender as UserDetails
            let vc:ViewOtherDetailViewController? = segue.destinationViewController as? ViewOtherDetailViewController
            if vc != nil {
                vc!.connectionId = tappedItem.connection_id
            }
            /*let vc:SendMessageViewController? = segue.destinationViewController as? SendMessageViewController
            if vc != nil {
                vc!.connectionId = tappedItem.connection_id
                vc!.toString     = tappedItem.name
            }*/
        }
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    

    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            var tappedItem = activities.activities[indexPath.row] as Activity
            
            /*func deleteConnection(alert: UIAlertAction!) -> Void {
                println(tappedItem.name)
                let args = ["connectionId": String(tappedItem.connection_id)]
                func _deleteConnectionApiResponseHandler(results: NSDictionary) {
                    if !(results["response"] as Bool) {
                        NSLog("Error deleting Connection")
                    }
                    self.activities.activities.removeAtIndex(indexPath.row)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    //tableView.reloadData()
                }
                api.postRequest(
                    url + "/connection/delete_connection",
                    arguments: args,
                    handler: _deleteConnectionApiResponseHandler
                )
            }
            
            var alert = UIAlertController(title: "Deleging \(tappedItem.name)", message: "Are you sure you would like to remove your connecton to \(tappedItem.name)? This action can not be undone and you won't be able to recieve messages from \(tappedItem.name) any more.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "delete", style: UIAlertActionStyle.Default, handler: deleteConnection))
            alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)*/
        }
    }

}