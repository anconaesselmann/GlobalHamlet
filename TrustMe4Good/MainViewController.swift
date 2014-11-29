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
        //loadActivities()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("\n\n\n\n\n\ncalled\n\n\n\n\n\n\n")
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
        var cell:ActivityPrototypeCell = tableView.dequeueReusableCellWithIdentifier("ActivityPrototypeCell") as ActivityPrototypeCell
        var activity: Activity = activities.activities[indexPath.row] as Activity
        cell.bodyLabel.text = activity.displayString()
        cell.dateLabel.text = activity.dateString()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        var tappedItem = activities.activities[indexPath.row] as Activity
        if tappedItem.category == "connections" {
            performSegueWithIdentifier("ActivityToViewDetailsSegue", sender: tappedItem)
        } else if tappedItem.category == "messages" {
            performSegueWithIdentifier("ViewMessageSegue", sender: tappedItem)
        }
        //performSegueWithIdentifier("SegueToSendMessage", sender: tappedItem)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier? == "ActivityToViewDetailsSegue" {
            var tappedItem: Activity = sender as Activity
            let vc:ViewOtherDetailViewController? = segue.destinationViewController as? ViewOtherDetailViewController
            if vc != nil {
                vc!.connectionId = tappedItem.category_id
            }
        } else if segue.identifier? == "ViewMessageSegue" {
            var tappedItem: Activity = sender as Activity
            let vc:ViewMessageViewController? = segue.destinationViewController as? ViewMessageViewController
            if vc != nil {
                vc!.messageId = tappedItem.category_id
            }
        }
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

}