import UIKit

class ConnectionNavigationController: ProjectNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneButton:UIBarButtonItem = UIBarButtonItem(
            title: "done",
            style: .Plain,
            target: self,
            action: "backAction"
        )
        topViewController.navigationItem.leftBarButtonItem = doneButton;
    }
    func backAction() {
        performSegueWithIdentifier("BackFromNavigationControllerSegue", sender: nil)
    }
}