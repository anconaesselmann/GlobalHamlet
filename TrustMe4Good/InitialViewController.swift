import UIKit

class InitialViewController: DICNavigationController {
    var _web: WebProtocol!
    
    override func initWithArgs(args:[AnyObject]) {
        _web = args[0] as? WebProtocol
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillLayoutSubviews() {

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}