import UIKit

class ImagePickerPageView: PageView, PageViewDataSource {
    override init(frame: CGRect) {
        super.init(frame: frame)
        view = getViewFromNib("ImagePickerPageView")
        super.addSubview(view)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        view = getViewFromNib("ImagePickerPageView")
        addSubview(view)
        setup()
    }
    override func setup() {
        dataSource = self
    }
    func get() -> AnyObject? {
        return "Current"
    }
    func getPrevious() -> AnyObject? {
        return "Previous"
    }
    func getNext() -> AnyObject? {
        return "Next"
    }
    func hasNext() -> Bool? {
        return true
    }
    func hasPrev() -> Bool? {
        return false
    }
    func getPage() -> UIView? {
        if delegate != nil {
            let imagePicker =  ImagePicker(frame: CGRectMake(100, 100, 300, 300))
            imagePicker.delegate = delegate
            imagePicker.noImageLabelText = "Select image"
            imagePicker.imageUrl = "http://www.socipelago.com/secure_image/get/profile/1.jpg"
            return imagePicker
        } else {
            return nil
        }
    }
    var length:Int {
        return 3
    }
}
