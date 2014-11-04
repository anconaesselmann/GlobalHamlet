import CoreData
import Foundation
import UIKit

class FirstLaunchViewController: UIViewController, ViewControllerWithContext {
    var context: NSManagedObjectContext!
    //let _web: Web!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func signIn(sender: AnyObject) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*let d = self.postRequst("http://www.api.anconaesselmann.dev/login") as NSDictionary;
        println(d["response"] as Bool)
        println(d["errorCode"] as Int)
        
        if d["response"] as Bool == true {
            //self.navigationController?.pushViewController(LoginViewController(), animated: true)
            
            let loginViewController:LoginViewController = LoginViewController()
            self.presentViewController(loginViewController, animated: true, completion: nil)
        }*/
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        println("works1")
    }
}

