import UIKit

@objc protocol CodeGeneratorProtocol {
    func getImageFromString(string: NSString) -> UIImage
    func getConstrainedImage(string: NSString, view: UIView, imageView: UIImageView?)  -> UIImage
}