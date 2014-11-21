import UIKit

class ConnectionNavigationController: DICNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let anotherButton:UIBarButtonItem = UIBarButtonItem(
            title: "done",
            style: .Plain,
            target: self,
            action: "backAction"
        )
        topViewController.navigationItem.leftBarButtonItem = anotherButton;
    }
    func backAction() {
        performSegueWithIdentifier("BackFromNavigationControllerSegue", sender: nil)
    }
}