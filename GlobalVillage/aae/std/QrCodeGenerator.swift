import UIKit

@objc(QrCodeGenerator) public class QrCodeGenerator: NSObject,  CodeGeneratorProtocol {
    public func getImageFromString(string: NSString) -> UIImage {
        let stringData: NSData = string.dataUsingEncoding(NSUTF8StringEncoding)!;
        let filter: CIFilter = CIFilter(name:"CIQRCodeGenerator")!;
        filter.setValue(stringData, forKey: "inputMessage");
        filter.setValue("M", forKey: "inputCorrectionLevel");
        let ciImage = filter.outputImage;
        let transform:CGAffineTransform = CGAffineTransformMakeScale(12.0, 12.0);
        let output = ciImage!.imageByApplyingTransform(transform);
        return UIImage(CIImage: output);
    }
    
    
    private func constrainedImage(view: UIView, imageView: UIImageView?, image: UIImage?) {
        if let constrainedView = imageView {
            var aspectRatioConstraint: NSLayoutConstraint
            if let newImage = image {
                aspectRatioConstraint = NSLayoutConstraint(
                    item: constrainedView,
                    attribute: .Width,
                    relatedBy: .Equal,
                    toItem: constrainedView,
                    attribute: .Height,
                    multiplier: newImage.aspectRatio,
                    constant: 0)
                 view.addConstraint(aspectRatioConstraint)
            }
        }
    }
    
    public func getConstrainedImage(string: NSString, view: UIView, imageView: UIImageView?)  -> UIImage {
        let image = getImageFromString(string)
        constrainedImage(view, imageView: imageView, image: image)
        return image
    }
}




extension UIImage
{
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}