import UIKit

class MainViewController: DICViewController {
    var web: WebProtocol!
    var url: String!
    
    override func initWithArgs(args:[AnyObject]) {
        assert(args.count == 2)
        assert(args[0] is WebProtocol)
        assert(args[1] is String)
        web = args[0] as WebProtocol
        url = args[1] as String
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "SegueToFirstLaunchView" {
            web.postRequst(url + "/login/logout")
        }
    }
}

