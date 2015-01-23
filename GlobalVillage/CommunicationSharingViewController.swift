import UIKit

class CommunicationSharingViewController: DICTableViewController {
    var delegate:InitiateViewController?
    
    @IBOutlet var switches: [NamedSwitch]!
    
    @IBAction func switchValueChangedAction(sender: AnyObject) {
        delegate!.connectionDetails.setSwitch(
            (sender as NamedSwitch).name,
            value: sender.isOn
        )
        println(delegate!.connectionDetails.getJson())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switches[0].name = "can_be_messaged"
        switches[1].name = "show_email"
        switches[2].name = "show_phone"
        
        delegate!.connectionDetails.linkSwitches(switches)
    }
}

