import UIKit
import Foundation

class ViewOtherDetailViewController: DICViewController, APIControllerDelegateProtocol, UserDetailsDelegateProtocol {
    var connectionId:Int?;
    var dataJsonString:String = ""
    var userDetails:UserDetails!
    var api: ApiController!
    var url: String!
    
    @IBOutlet weak var viewOtherDataLabel: UILabel!
    
    override func initWithArgs(args:[AnyObject]) {
        assert(args.count == 2)
        assert(args[0] is ApiController)
        assert(args[1] is String)
        api = args[0] as ApiController
        url = args[1] as String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userDetails = UserDetails()
        userDetails!.delegate = self
        
        getOtherData()
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
            vc!.connectionId = connectionId!
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
            println(id)
            connectionId = id.toInt()
            getOtherData()
        }
    }
}