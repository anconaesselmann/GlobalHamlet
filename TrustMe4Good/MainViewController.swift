import UIKit
import SpriteKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingView = LoadingIndicator(view: self.view)
    }
    
}

