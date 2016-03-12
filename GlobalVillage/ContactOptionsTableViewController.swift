import UIKit

class ContactOptionsTableViewController: DICTableViewController {
    var connectionId:Int = 0
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if self.tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier? == "saveToContacts" {
//            
//            
//            addToContacts(adbk, newFirstName: "a", newLastName: "AA", newPhone: "111 111 1111", newEmail: "aaa@bbb.dev")
//            
//            //performSegueWithIdentifier("EditContactSegue", sender: self)
//        }
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "editContactSegue" {
            _contactOptionsSegue(segue)
        } else {
            print("unknown segue: \(segue.identifier)")
        }
    }
    
    func _contactOptionsSegue(segue: UIStoryboardSegue) {
        let vc:SaveToContactsViewController? = segue.destinationViewController as? SaveToContactsViewController
        if vc != nil {
            vc!.connectionId = connectionId
            print(connectionId)
        }
    }
}
