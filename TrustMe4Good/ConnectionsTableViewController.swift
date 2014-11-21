import UIKit
import Foundation

class ConnectionsTableViewController: DICTableViewController, UpdateDelegateProtocol {
    var connections:Connections!
    var api:ApiController!
    var url:String!
    
    override func initWithArgs(args:[AnyObject]) {
        api = args[0] as ApiController
        url = args[1] as String
        connections = Connections()
        api.delegate = connections
        connections.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadConnections()
    }
    func loadConnections() {
        api.request(url + "/connection/get_all")
    }
    func updateDelegate() {
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
            let vc:ViewOtherDetailViewController? = (segue.destinationViewController as? UINavigationController)?.viewControllers[0] as? ViewOtherDetailViewController
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
}