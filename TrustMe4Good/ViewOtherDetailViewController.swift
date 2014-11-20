import UIKit
import Foundation

class ViewOtherDetailViewController: DICViewController, UserDetailsDelegateProtocol {
    var connectionId:Int = 0;
    var dataJsonString:String = ""
    var userDetails:UserDetails?
    @IBOutlet weak var viewOtherDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userDetails = UserDetails()
        userDetails!.delegate = self
        
        // TODO: Will be called by callback function
        userDetails!.didReceiveAPIResults(NSDictionary(dictionary: ["response":dataJsonString]))
    }
    func userDetailsHaveUpdated() {
        viewOtherDataLabel.text = userDetails!.getName()
        
        println("Printing userDetails:")
        println(userDetails!)
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
        }
    }
    //
}