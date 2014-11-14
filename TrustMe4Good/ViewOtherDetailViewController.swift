import UIKit
import Foundation

class ViewOtherDetailViewController: DICViewController {
    var connectionId:Int = 0;
    var dataJsonString:String = ""
    var userName:String = ""
    @IBOutlet weak var viewOtherDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        var error:    NSError?       = nil
        let nsJsonString = dataJsonString as NSString
        let jsonData:NSData? = nsJsonString.dataUsingEncoding(NSUTF8StringEncoding) as NSData?
        
        let json:AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData!, options: nil, error: &error);
        if json is NSDictionary {
            if let alias:String? = (json as NSDictionary)["alias"] as? String {
                viewOtherDataLabel.text = alias!
                userName = alias!
            }
            //return json as NSDictionary;
        }

        //viewOtherDataLabel.text = dataJsonString
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier? == "ComposeEmailSegue" {
            _composeEmailSegue(segue)
        } else {
            println("unknown segue: \(segue.identifier?)")
        }
    }
    
    func _composeEmailSegue(segue: UIStoryboardSegue) {
        let vc:SendMessageViewController? = segue.destinationViewController as? SendMessageViewController
        if vc != nil {
            vc!.connectionId = connectionId
            vc!.toString = userName
        }
    }
    //
}