import UIKit

class CreateRegisteredViewController: DICViewController {
    var api:ApiController!
    var url:String!
    var loadingView:LoadingIndicator!
    var ownDetails:OwnDetails!
    
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var phoneNbrLabel: UITextField!
    @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var zipLabel: UITextField!
    @IBOutlet weak var stateLabel: UITextField!
    @IBOutlet weak var countryLabel: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func initWithArgs(args:[AnyObject]) {
        api = args[0] as ApiController
        url = args[1] as String
        loadingView = LoadingIndicator(del: self)
        
        ownDetails = OwnDetails()
        
        let ari = AsynchronousResourceInstantiator(target: ownDetails, callback: updateViewAfterAsynchronousRequestResults)
        api.delegate = ari
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        api.request(url + "/user")
    }
    
    func updateViewAfterAsynchronousRequestResults() {
        firstNameLabel.text = ownDetails!.firstName
        lastNameLabel.text  = ownDetails!.lastName
        phoneNbrLabel.text  = ownDetails!.phoneNbr
        addressLabel.text   = ownDetails!.address
        cityLabel.text      = ownDetails!.city
        zipLabel.text       = ownDetails!.zip
        stateLabel.text     = ownDetails!.state
        countryLabel.text   = ownDetails!.country
        
        let imageUrlString = url + ownDetails.imageUrl
        api.imageRequest(imageUrlString, handler: imageReceived);
    }
    

    func imageReceived(image:UIImage) {
        self.profilePicture!.image = image
        loadingView.stop()
    }
}

