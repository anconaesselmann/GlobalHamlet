import UIKit

public class LoadingScreenViewController: DICViewController {
    var api:ApiController!
    var url:String!
    var authentication = Authentication()
    
    override public func initWithArgs(args:[AnyObject]) {
        api = args[0] as! ApiController
        url = args[1] as! String
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        print(url)
        let loginUrl = url + "/login"
        print("logging in with \(loginUrl)")
        api.request(loginUrl) {results in
            let loggedIn = self.authentication.processServerResponse(results)
            if loggedIn {
                self.authentication.updateUI(self.dic.get("loginSegueStoryboardName") as! String, currentViewController: self)
            } else {
                self.performSegueWithIdentifier("LaunchFirstLaunchSegue", sender: self)
            }
        };
    }
}