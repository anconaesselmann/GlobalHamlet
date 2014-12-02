import UIKit
import SpriteKit

class MainViewController: DICTableViewController, APIControllerDelegateProtocol {
    var activities:[Activity]!
    var api:ApiController!
    var url:String!
    var loadingView:LoadingIndicator!
    
    override func initWithArgs(args:[AnyObject]) {
        api = args[0] as ApiController
        url = args[1] as String
        
        loadingView = LoadingIndicator(del: self)
        
        activities = []
        let ari = AsynchronousArrayResourceInstantiator(
            addInstanceClosure: {(dict:[String: AnyObject]) -> Void in
                var inst = Activity()
                inst.set(dict)
                self.activities.append(inst)
            },
            callback: updateViewAfterAsynchronousRequestResults
        )
        api.delegate = ari
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
        activities = []
        loadActivities()
    }
    func loadActivities() {
        loadingView.start()
        api.request(url + "/activity/get_activity")
    }
    func updateViewAfterAsynchronousRequestResults() {
        loadingView.stop()
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:ActivityPrototypeCell = tableView.dequeueReusableCellWithIdentifier("ActivityPrototypeCell") as ActivityPrototypeCell
        if activities.count > 0 {
            var activity: Activity = activities[indexPath.row] as Activity
            cell.bodyLabel.text = activity.displayString()
            cell.dateLabel.text = activity.dateString()
            switch activity.action {
                case "received": cell.actionImage.image = UIImage(named: "message_in")
                case "sent": cell.actionImage.image = UIImage(named: "message_out")
                case "initiated": cell.actionImage.image = UIImage(named: "connection")
                case "reciprocated": cell.actionImage.image = UIImage(named: "connection")
                default: println("unknown action")
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if activities.count > 0 {
            var tappedItem = activities[indexPath.row] as Activity
            if tappedItem.category == "connections" {
                performSegueWithIdentifier("ActivityToViewDetailsSegue", sender: tappedItem)
            } else if tappedItem.category == "messages" {
                performSegueWithIdentifier("ViewMessageSegue", sender: tappedItem)
            }
            //performSegueWithIdentifier("SegueToSendMessage", sender: tappedItem)
        }
        
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