import UIKit
import MobileCoreServices

class CreateRegisteredViewController: DICViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    var api:ApiController!
    var url:String!
    var loadingView:LoadingIndicator!
    var ownDetails:OwnDetails!
    var imageData:NSData?
    var activeTextField:UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var phoneNbrLabel: UITextField!
    @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var zipLabel: UITextField!
    @IBOutlet weak var stateLabel: UITextField!
    @IBOutlet weak var countryLabel: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBAction func saveAction(sender: AnyObject) {
        uploadChanges()
        dismissKeyboard()
    }
    
    override func initWithArgs(args:[AnyObject]) {
        api = args[0] as! ApiController
        url = args[1] as! String
        loadingView = LoadingIndicator(del: self)
        
        ownDetails = OwnDetails()
        
        let ari = AsynchronousResourceInstantiator(target: ownDetails, callback: updateViewAfterAsynchronousRequestResults)
        api.delegate = ari
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserData()
        
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func loadUserData() {
        loadingView.start()
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
    
    @IBAction func imageButton(sender: AnyObject) {
        takePhoto(sender)
    }
    func takePhoto(sender: AnyObject) {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraDevice = UIImagePickerControllerCameraDevice.Front
            let mediaTypes: Array<AnyObject> = [kUTTypeImage]
            picker.mediaTypes = mediaTypes as! [String]
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
        }
        else{
            NSLog("No Camera.")
        }
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        imageData = UIImageJPEGRepresentation(image, 0.6);
        self.profilePicture!.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func uploadCompleted(result: NSDictionary) {
        print(result)
        loadUserData()
    }
    func uploadChanges() {
        loadingView.start()
        let arguments = [
            "firstName": firstNameLabel.text!,
            "lastName": lastNameLabel.text!,
            "phoneNbr": phoneNbrLabel.text!,
            "address": addressLabel.text!,
            "city": cityLabel.text!,
            "zip": zipLabel.text!,
            "state": stateLabel.text!,
            "country": countryLabel.text!
        ]
        var fileData:[String: NSData]?
        var fileNames:[String]?
        var mimeTypes:[String]?
        if imageData != nil {
            print("image data not nil")
            fileData = ["fileToUpload": imageData!]
            fileNames = ["profilePicture.jpg"]
            mimeTypes = ["image/jpeg"]
        }
        api.multiPartFormDataRequest(
            url + "/user/submit_edit",
            arguments: arguments,
            fileData: fileData,
            fileNames: fileNames,
            mimeTypes: mimeTypes,
            handler: uploadCompleted
        )
    }
    
    func dismissKeyboard() {
        firstNameLabel.resignFirstResponder()
        lastNameLabel.resignFirstResponder()
        phoneNbrLabel.resignFirstResponder()
        addressLabel.resignFirstResponder()
        cityLabel.resignFirstResponder()
        zipLabel.resignFirstResponder()
        stateLabel.resignFirstResponder()
        countryLabel.resignFirstResponder()
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        let nc = self.navigationController
        if nc != nil {
            let scrollPoint:CGPoint = CGPointMake(0, textField.frame.origin.y - (firstNameLabel.frame.origin.y + nc!.navigationBar.frame.origin.y + nc!.navigationBar.bounds.height))
            scrollView.setContentOffset(scrollPoint, animated:true)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let nc = self.navigationController
        if nc != nil {
            let scrollPoint:CGPoint = CGPointMake(0, -(nc!.navigationBar.frame.origin.y + nc!.navigationBar.bounds.height))
            scrollView.setContentOffset(scrollPoint, animated:true)
        }
    }



}

