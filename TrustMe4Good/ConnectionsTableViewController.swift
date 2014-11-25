import UIKit
import Foundation

class ConnectionsTableViewController: DICTableViewController, UpdateDelegateProtocol {
    var connections:Connections!
    var api:ApiController!
    var url:String!
    var loadingView:LoadingIndicator!
    
    override func initWithArgs(args:[AnyObject]) {
        api = args[0] as ApiController
        url = args[1] as String
        
        loadingView = LoadingIndicator(del: self)
        connections = Connections()
        api.delegate = connections
        connections.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "connections"
        loadConnections()
    }
    func loadConnections() {
        loadingView.start()
        api.request(url + "/connection/get_all")
    }
    func updateDelegate() {
        loadingView.stop()
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connections.connections.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ConnectionPrototypeCell") as UITableViewCell
        var connection: UserDetails = connections.connections[indexPath.row] as UserDetails
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
        var tappedItem = connections.connections[indexPath.row] as UserDetails
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
            var tappedItem = connections.connections[indexPath.row] as UserDetails
            
            func deleteConnection(alert: UIAlertAction!) -> Void {
                println(tappedItem.name)
                let args = ["connectionId": String(tappedItem.connection_id)]
                func _deleteConnectionApiResponseHandler(results: NSDictionary) {
                    if !(results["response"] as Bool) {
                        NSLog("Error deleting Connection")
                    }
                    self.connections.connections.removeAtIndex(indexPath.row)
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
            presentViewController(alert, animated: true, completion: nil)
        }
    }

}