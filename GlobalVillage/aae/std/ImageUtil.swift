import UIKit

extension UIImage {
    func resizePreservingAspectRatio(toSize size:CGFloat) -> UIImage{
        let currentSize = self.size
        let scaledSize  = size / UIScreen.mainScreen().scale
        let aspectRatio = currentSize.width / currentSize.height
        let newSize     = (aspectRatio > 1) ?
            CGSize(width: scaledSize, height: scaledSize / aspectRatio) : CGSize(width: scaledSize * aspectRatio, height: scaledSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    func crop(toAspectRatio aspectRatio:CGFloat) -> UIImage {
        // Create a copy of the image without the imageOrientation property so it is in its native orientation (landscape)
        let contextImage: UIImage = UIImage(CGImage: self.CGImage!)
        
        // Get the size of the contextImage
        let contextSize: CGSize = contextImage.size
        
        let posX: CGFloat
        let posY: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        // Check to see which length is the longest and create the offset based on that length, then set the width and height of our rect
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            width = contextSize.height * aspectRatio
            height = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            width = contextSize.width
            height = contextSize.width * aspectRatio
        }
        
        let rect: CGRect = CGRectMake(posX, posY, width, height)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        return image
    }
    func cropToSquare() -> UIImage {
        return self.crop(toAspectRatio: CGFloat(1))
    }
}