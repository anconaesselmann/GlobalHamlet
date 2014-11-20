import UIKit
import Foundation

class ViewOtherDetailViewController: DICViewController, APIControllerDelegateProtocol, UpdateDelegateProtocol {
    var connectionId:Int?;
    var dataJsonString:String = ""
    var userDetails:UserDetails!
    var api: ApiController!
    var url: String!
    
    @IBOutlet weak var viewOtherDataLabel: UILabel!
    
    override func initWithArgs(args:[AnyObject]) {
        api = args[0] as ApiController
        url = args[1] as String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userDetails = UserDetails()
        userDetails!.delegate = self
        
        getOtherData()
    }
    func updateDelegate() {
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
            vc!.connectionId = connectionId!
            vc!.toString = userDetails!.getName()
            
            println("connectionId used for email:")
            println(connectionId!)
        }
    }
    func getOtherData() {
        if connectionId != nil && userDetails != nil {
            let arguments:[String: String] = ["id": String(connectionId!)]
            api.delegate = userDetails!
            api.postRequest(
                url + "/connection/other_details",
                arguments: arguments
            )
        }
    }

    func didReceiveAPIResults(results: NSDictionary) {
        println("ViewOtherDeails api result:")
        println(results)
        // TODO: Figure out why it crashes casting to int
        if let id:String = results["response"] as? String {
            println("Id recieved from api request")
            println(id)
            connectionId = id.toInt()
            getOtherData()
        }
    }
}