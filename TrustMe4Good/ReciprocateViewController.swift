import UIKit
import Foundation

class ReciprocateViewController: DICViewController {
    var web: WebProtocol!
    var url: String!
    var error = Error()
    var codeAndIdTuple:(id:Int, code:String)!
    
    var qr:QrReader!
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var viewPreview: UIView!
    
    override func initWithArgs(args:[AnyObject]) {
        assert(args.count == 2)
        assert(args[0] is WebProtocol)
        assert(args[1] is String)
        web = args[0]  as WebProtocol
        url = args[1]  as String
    }
    
    /*@IBAction func submitPressed(sender: AnyObject) {
        // TODO: get codeAndId from qr-code reader
        let codeAndId = codeTextField!.text + idTextField!.text
        let codeAndIdTuple = getIdAndCodeFromString(codeAndId)
        sendCode(codeAndIdTuple.id, code: codeAndIdTuple.code)
    }*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier? == "ReciprocateSharingSegue" {
            _reciprocateSharingSegue(segue)
        } else {
            println("unknown segue: \(segue.identifier?)")
        }
    }
    
    func _reciprocateSharingSegue(segue: UIStoryboardSegue) {
        let vc:InitiateViewController? = segue.destinationViewController as? InitiateViewController
        if vc != nil {
            vc!.delegate = self
        }
        let codeAndId = codeTextField!.text + idTextField!.text
        //codeAndIdTuple = getIdAndCodeFromString(codeAndId)

        
        /*let vc:IdentitySharingViewController? = segue.destinationViewController as? IdentitySharingViewController
        if vc != nil {
            vc!.delegate = self
        }*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // move this to di container
        qr = QrReader(displayView:viewPreview, callBack: getIdAndCodeFromString)
        qr!.startReading()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getIdAndCodeFromString(codeString: String) {
        let code: String = (codeString as NSString).substringToIndex(20)
        var id: Int? = (codeString as NSString).substringFromIndex(20).toInt()
        if id == nil {
            id = -1
        }
        codeAndIdTuple = (id: id!, code: code)
        println("id" + String(id!) + " code: " + code)
        performSegueWithIdentifier("ReciprocateSharingSegue", sender: nil)
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

