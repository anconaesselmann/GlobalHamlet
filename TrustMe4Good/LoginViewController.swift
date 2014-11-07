import UIKit

class LoginViewController: DICViewController {
    var web: WebProtocol!
    var loggedIn: Bool = false
    var url: String!
    
    @IBOutlet weak var signInButton:  UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func initWithArgs(args:[AnyObject]) {
        assert(args.count == 2)
        assert(args[0] is WebProtocol)
        assert(args[1] is String)
        web = args[0] as WebProtocol
        url = args[1] as String
    }
    

    @IBAction func signInAction(sender: AnyObject) {
        var email:String?    = self.emailTextField?.text
        var password:String? = self.passwordTextField?.text
        var uuid = UIDevice().identifierForVendor.UUIDString;
        
        var args = ["userEmail": email!, "userPassword": password!, "apiCaller": "IOS8_" + uuid]
        var url: String  = "\(self.url)/login/submit"
        let d = web.postRequst(url, arguments: args) as NSDictionary
        println(d["response"] as Bool)
        println(d["errorCode"] as Int)
        if let response = d["response"] as? Bool {
            loggedIn = response
            if loggedIn {
                performSegueWithIdentifier("SegueToMain", sender: self)
            }
        } else {
            loggedIn = false
        }
        
        web.postRequst(url, arguments: args)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        
    }
}

