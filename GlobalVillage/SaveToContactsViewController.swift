import UIKit
import MobileCoreServices
import AddressBook
import AddressBookUI

class SaveToContactsViewController: DICViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    var api:ApiController!
    var url:String!
    var loadingView:LoadingIndicator!
    var ownDetails:OwnDetails!
    var imageData:NSData?
    var activeTextField:UITextField!
    
    var connectionId:Int!
    var userDetails:UserDetails!
    var adbk:ABAddressBook?
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var phoneNbrLabel: UITextField!
    @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var zipLabel: UITextField!
    @IBOutlet weak var stateLabel: UITextField!
    @IBOutlet weak var countryLabel: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    
    func saveAction() {
        let success = addToContacts(adbk, newFirstName: firstNameLabel!.text!, newLastName: "", newPhone: phoneNbrLabel!.text, newEmail: emailLabel!.text)
        dismissKeyboard()
        if success {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            adbk = nil
            let alert = UIAlertController(title: "Error", message: "An error occured saving the contact. Make sure the application has access to the address book.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel) { (action) in
                    self.openSettings()
                })
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func openSettings() {
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    override func initWithArgs(args:[AnyObject]) {
        api = args[0] as! ApiController
        url = args[1] as! String
        loadingView = LoadingIndicator(del: self)
        
        ownDetails = OwnDetails()
        userDetails = UserDetails()
        
        let ari = AsynchronousResourceInstantiator(target: userDetails, callback: updateViewAfterAsynchronousRequestResults)
        api.delegate = ari
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserData()
        
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        
        let saveButton = UIBarButtonItem(image: UIImage(named: "navBar_send.png"), style: .Plain, target: self, action: "saveAction")
        navigationItem.setRightBarButtonItems([saveButton], animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthorization()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func loadUserData() {
        loadingView.start()
        
        if connectionId != nil {
            let arguments:[String: String] = ["id": String(connectionId!)]
            api.postRequest(
                url + "/connection/other_details",
                arguments: arguments
            )
        } else {
            print("ERROR: userId is nill")
        }
    }
    
    func updateViewAfterAsynchronousRequestResults() {
        print(userDetails)
        
        firstNameLabel.text = userDetails?.name
        emailLabel.text     = userDetails?.email
        if userDetails?.phone != nil {
            phoneNbrLabel.text  = userDetails?.phone
        }
        /*addressLabel.text   = userDetails!.address
        cityLabel.text      = userDetails!.city
        zipLabel.text       = userDetails!.zip
        stateLabel.text     = userDetails!.state
        countryLabel.text   = userDetails!.country*/
        
        // this is temporary
        loadingView.stop()
        
        // TODO: create image url (authenticated) that takes a connection id and returns the other's image!!!!!
        //let imageUrlString = url + String(connectionId!)
        //api.imageRequest(imageUrlString, handler: imageReceived);
    }
    
    
    func imageReceived(image:UIImage) {
        self.profilePicture!.image = image
        loadingView.stop()
    }
    
    /*@IBAction func imageButton(sender: AnyObject) {
        takePhoto(sender)
    }
    func takePhoto(sender: AnyObject) {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            var picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraDevice = UIImagePickerControllerCameraDevice.Front
            var mediaTypes: Array<AnyObject> = [kUTTypeImage]
            picker.mediaTypes = mediaTypes
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
        }
        else{
            NSLog("No Camera.")
        }
    }*
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        imageData = UIImageJPEGRepresentation(image, 0.6);
        self.profilePicture!.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func uploadCompleted(result: NSDictionary) {
        println(result)
        loadUserData()
    }*/
    /*func uploadChanges() {
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
            println("image data not nil")
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
    }*/
    
    func dismissKeyboard() {
        firstNameLabel.resignFirstResponder()
        emailLabel.resignFirstResponder()
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
    
    
    
    
    
    
    
    
    
    func checkAuthorization() {
        let stat = ABAddressBookGetAuthorizationStatus()
        switch stat {
        case .Denied, .Restricted:
            print("no access")
            return
        case .Authorized, .NotDetermined:
            var err : Unmanaged<CFError>? = nil
            let adbk : ABAddressBook? = ABAddressBookCreateWithOptions(nil, &err).takeRetainedValue()
            if adbk == nil {
                print(err)
                return            }
            self.adbk = adbk
            ABAddressBookRequestAccessWithCompletion(adbk) {
                (granted:Bool, err:CFError!) in
                if granted {
                } else {
                    print(err)
                }
            }
        }
    }
    
    func createMultiStringRef() -> ABMutableMultiValueRef {
        let propertyType: NSNumber = kABMultiStringPropertyType
        return Unmanaged.fromOpaque(ABMultiValueCreateMutable(propertyType.unsignedIntValue).toOpaque()).takeUnretainedValue() as NSObject as ABMultiValueRef
    }
    
    func addToContacts(adbk:ABAddressBook?, newFirstName:String, newLastName:String?, newPhone:String?, newEmail:String?) -> Bool {
        if adbk != nil {
            let newContact:ABRecordRef! = ABPersonCreate().takeRetainedValue()
            var success:Bool = false
            
            var error: Unmanaged<CFErrorRef>? = nil
            success = ABRecordSetValue(newContact, kABPersonFirstNameProperty, newFirstName, &error)
            print("setting first name was successful? \(success)")
            
            if newLastName != nil {
                success = ABRecordSetValue(newContact, kABPersonLastNameProperty, newLastName!, &error)
            }
            
            if newPhone != nil {
                let multiPhone:ABMutableMultiValueRef  = createMultiStringRef()
                
                ABMultiValueAddValueAndLabel(multiPhone, newPhone!, kABPersonPhoneMobileLabel, nil);
                ABRecordSetValue(newContact, kABPersonPhoneProperty, multiPhone,nil);
            }
            
            if newEmail != nil {
                let multiEmail:ABMutableMultiValueRef = createMultiStringRef()
                
                ABMultiValueAddValueAndLabel(multiEmail, newEmail!, kABHomeLabel, nil);
                ABRecordSetValue(newContact, kABPersonEmailProperty, multiEmail, nil);
            }
            
            print("setting last name was successful? \(success)")
            success = ABAddressBookAddRecord(adbk, newContact, &error)
            print("Adbk addRecord successful? \(success)")
            success = ABAddressBookSave(adbk, &error)
            print("Adbk Save successful? \(success)")
            print("added to contacts")
            if success {
                return true
            }
        } else {
            print("not authorized")
        }
        return false
    }
    

    
}

