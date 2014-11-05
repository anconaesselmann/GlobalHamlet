import CoreData
import Foundation
import UIKit

class FirstLaunchViewController: DICViewController {
    var _web: WebProtocol!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func signIn(sender: AnyObject) {
        
    }
    override func initWithArgs(args:[AnyObject]) {
        _web = args[0] as? WebProtocol
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let response = _web.postRequst("http://www.api.anconaesselmann.dev/login") as NSDictionary;
        println(response["response"] as Bool)
        println(response["errorCode"] as Int)
        
        if response["response"] as Bool != true {
            self.performSegueWithIdentifier("isLoggedInSegueToMain", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

