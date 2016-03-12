import UIKit
import Foundation

class ConnectionsTableViewController: DICTableViewController {
    var connections:[UserDetails]!
    var api:ApiController!
    var url:String!
    var loadingView:LoadingIndicator!
    
    override func initWithArgs(args:[AnyObject]) {
        api = args[0] as! ApiController
        url = args[1] as! String
        
        loadingView = LoadingIndicator(del: self)
        
        connections = []
        let ari = AsynchronousArrayResourceInstantiator(
            addInstanceClosure: {(dict:[String: AnyObject]) -> Void in
                let inst = UserDetails()
                inst.set(dict)
                self.connections.append(inst)
            },
            callback: updateViewAfterAsynchronousRequestResults
        )
        api.delegate = ari
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
    func updateViewAfterAsynchronousRequestResults() {
        loadingView.stop()
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connections.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ConnectionPrototypeCell = tableView.dequeueReusableCellWithIdentifier("ConnectionPrototypeCell") as! ConnectionPrototypeCell
        let connection: UserDetails = connections[indexPath.row] as UserDetails
        cell.nameLabel.text = connection.name
        cell.emailLabel.text = connection.email
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let tappedItem = connections[indexPath.row] as UserDetails
        performSegueWithIdentifier("ComposeEmailSegue", sender: tappedItem)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "SegueToSendMessage" {
            // Currently this segue is not called.
            let tappedItem: UserDetails = sender as! UserDetails
            let vc:ViewOtherDetailViewController? = segue.destinationViewController as? ViewOtherDetailViewController
            if vc != nil {
                vc!.connectionId = tappedItem.connection_id
            }
        } else if segue.identifier == "ComposeEmailSegue" {
            let tappedItem: UserDetails = sender as! UserDetails
            let vc:SendMessageViewController? = segue.destinationViewController as? SendMessageViewController
            if vc != nil {
                vc!.connectionId = tappedItem.connection_id
                vc!.toString = tappedItem.name
            }
        }
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    

    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            var tappedItem = connections[indexPath.row] as UserDetails
            
            func deleteConnection(alert: UIAlertAction!) -> Void {
                print(tappedItem.name)
                let args = ["connectionId": String(tappedItem.connection_id)]
                func _deleteConnectionApiResponseHandler(results: NSDictionary) {
                    if !(results["response"] as! Bool) {
                        NSLog("Error deleting Connection")
                    }
                    self.connections.removeAtIndex(indexPath.row)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    //tableView.reloadData()
                }
                api.postRequest(
                    url + "/connection/delete_connection",
                    arguments: args,
                    handler: _deleteConnectionApiResponseHandler
                )
            }
            
            let alert = UIAlertController(title: "Deleging \(tappedItem.name)", message: "Are you sure you would like to remove your connecton to \(tappedItem.name)? This action can not be undone and you won't be able to recieve messages from \(tappedItem.name) any more.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "delete", style: UIAlertActionStyle.Default, handler: deleteConnection))
            alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }

}