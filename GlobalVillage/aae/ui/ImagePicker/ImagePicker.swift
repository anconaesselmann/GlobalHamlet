import UIKit

@IBDesignable class ImagePicker: UIView, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let api = ApiController()
    var tapGesture:UITapGestureRecognizer!
    var view:UIView!
    let imagePicker = UIImagePickerController()
    var delegate:UIViewController!
    var removeImageCallback:(()->Void)?
    var imageUploadCallback:(((ApiResponse?)->Void)->Void)?
    var loadImageCallback:(((UIImage?)->Void)->Void)? {
        didSet {
            if loadImageCallback != nil {
                noImageLabel.hidden = true
                loadImageCallback!(finishedLoadingImage)
            }
        }
    }
    @IBInspectable var resizeToMaxSide:Int? {
        didSet {
            print("@IBInspectable var resizeToMaxSide set to \(resizeToMaxSide)")
        }
    }
    @IBInspectable var aspectRatio:Int? {
        didSet {
            print("@IBInspectable var aspectRatio set to \(aspectRatio)")
        }
    }
    @IBInspectable var noImageLabelText:String? {
        didSet {
            noImageLabel.text = noImageLabelText
        }
    }
    var imageUrl:String? {
        didSet {
            guard imageUrl != nil else {return}
            loadImageCallback = _loadImageFromUrlCallback
        }
    }
    var imageUploadUrl:String? {
        didSet {
            guard imageUploadUrl != nil else {return}
            imageUploadCallback = _uploadImageWithImageUploadUrl
        }
    }
    var imagePostArgumentName = "fileToUpload"
    private func _loadImageFromUrlCallback(callback:(UIImage?)->Void) {
        print("Load image called")
        guard let url = imageUrl else {return}
        let api = ApiController()
        api.imageRequest(url) {image in
            print("received image from api")
            callback(image)
        }
    }
    
    func getJpegImage() -> NSData? {
        guard let image = image else {
            return nil
        }
        return UIImageJPEGRepresentation(image, 0.7);
    }
    
    private func _uploadImageWithImageUploadUrl(callback:(ApiResponse?)->Void) {
        print("upload image called")
        guard let url = imageUploadUrl else {return}
        //        loadingView.start()
        guard let data = getJpegImage() else {
            print("image data is nil")
            return
        }
        let arguments = [String:String]()
        let fileData  = ["fileToUpload": data]
        let fileNames = ["profilePicture.jpg"]
        let mimeTypes = ["image/jpeg"]
        api.multiPartFormDataRequest(
            url,
            arguments: arguments,
            fileData: fileData,
            fileNames: fileNames,
            mimeTypes: mimeTypes) {response in
                print("received response from server after image upload")
                callback(response)
        }
//        api.imageRequest(url) {image in
//            print("received image from api")
//            callback(image)
//        }
    }
    func finishedLoadingImage(imageResponse:UIImage?) {
        guard let response = imageResponse else {
            noImageLabel.hidden = false
            return
        }
        image = response
        print("Finished loading image")
    }
    func finishedUploadingCallback(response:AnyObject?) {
//        guard let response = imageResponse else {
//            noImageLabel.hidden = false
//            return
//        }
//        image = response
        print("Finished uploading image with response \(response)")
        print(response?.response)
    }
    @IBOutlet weak private var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .ScaleAspectFit
        }
    }
    var image:UIImage?  {
        didSet {
            if image != nil {
                if removeImageButton != nil {
                    removeImageButton.hidden = false
                }
            }
            if imageView != nil {
                imageView.image = image
            }
        }
    }
    
    @IBOutlet weak var noImageLabel: UILabel!
    @IBOutlet weak var removeImageButton: UIButton!
    @IBAction func removeImageButton(sender: AnyObject) {
        print("Deleted image")
        image = nil
        removeImageButton.hidden = true
        noImageLabel.hidden = false
        guard let callback = removeImageCallback else {
            return
        }
        callback()
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = getViewFromNib("ImagePicker")
        super.addSubview(view)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let view = getViewFromNib("ImagePicker")
        addSubview(view)
        setup()
    }
    func setup() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(ImagePicker._tap(_:)));
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        imagePicker.delegate      = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType    = .PhotoLibrary
        removeImageButton.hidden  = true
    }
    func _tap(sender:UITapGestureRecognizer?) {
        print("Tapped")
        delegate.presentViewController(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ImagePicker {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("Received image from image picker")
            
            var temp = pickedImage
            if let aspectRatio = aspectRatio {
                print("enforcing aspect ratio of \(aspectRatio)")
                temp = temp.crop(toAspectRatio: CGFloat(aspectRatio))
            } else {
                print("not enforcing aspect ratio constraints")
            }
            if let resizeToMaxSide = resizeToMaxSide {
                print("resizing to max side length of \(resizeToMaxSide)")
                temp = temp.resizePreservingAspectRatio(toSize: CGFloat(resizeToMaxSide))
            } else {
                print("not resizing to max side length")
            }
            image = temp
            if imageUploadCallback != nil {
                imageUploadCallback!(finishedUploadingCallback)
            }
        }
        delegate.dismissViewControllerAnimated(true, completion: nil)
    }
}
