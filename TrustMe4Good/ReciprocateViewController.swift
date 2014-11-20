import UIKit
import Foundation

class ReciprocateViewController: DICViewController {
    var error = Error()
    var codeAndIdTuple:(id:Int, code:String)!
    var qr:QrReader!
    
    @IBOutlet weak var viewPreview: UIView!
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qr = QrReader(displayView:viewPreview, callBack: getIdAndCodeFromString)
        qr!.startReading()
    }
    
    func getIdAndCodeFromString(codeString: String) {
        let code:String = (codeString as NSString).substringToIndex(20)
        var id:Int?     = (codeString as NSString).substringFromIndex(20).toInt()
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

