import UIKit

@objc(QrCodeGenerator) public class QrCodeGenerator: NSObject,  CodeGeneratorProtocol {
    public func getImageFromString(string: NSString) -> UIImage {
        let stringData: NSData = string.dataUsingEncoding(NSUTF8StringEncoding)!;
        let filter: CIFilter = CIFilter(name:"CIQRCodeGenerator");
        filter.setValue(stringData, forKey: "inputMessage");
        filter.setValue("M", forKey: "inputCorrectionLevel");
        let ciImage = filter.outputImage;
        let transform:CGAffineTransform = CGAffineTransformMakeScale(12.0, 12.0);
        let output = ciImage.imageByApplyingTransform(transform);
        return UIImage(CIImage: output)!;
    }
}