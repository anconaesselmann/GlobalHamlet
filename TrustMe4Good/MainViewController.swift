import UIKit

class MainViewController: DICViewController, APIControllerDelegateProtocol {
    var api: ApiController!
    var url: String!
    
    override func initWithArgs(args:[AnyObject]) {
        api = args[0] as ApiController
        url = args[1] as String
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        api.delegate = self
        api.request(url + "/login/logout")
    }
    func didReceiveAPIResults(results: NSDictionary) {
        performSegueWithIdentifier("SegueToFirstLaunchView", sender: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
}

