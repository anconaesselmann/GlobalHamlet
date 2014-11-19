import UIKit

class FirstLaunchViewController: DICViewController {
    @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func signIn(sender: AnyObject) {
        
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

