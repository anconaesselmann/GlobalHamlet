import Foundation
import UIKit

class LoadingIndicator: UIImageView {
    var loadingImages = [UIImage]()
    var delegate:UIViewController!
    
    init(del:UIViewController?) {
        delegate = del
        super.init(frame:CGRectMake(0, 0, 100, 100))
        
        for i in 0...7 {
            let imageName = "loading_\(i)"
            loadingImages.append(UIImage(named: imageName)!)
        }
        animationImages = loadingImages
        animationDuration = 1.2
    }
    func start() {
        if !isAnimating() {
            delegate.view.addSubview(self)
            center = CGPointMake(delegate.view.frame.size.width / 2, delegate.view.frame.size.height / 2);
            startAnimating()
            self.alpha = 0
            UIView.animateWithDuration(2.0, animations: { () -> Void in
                self.alpha = 1.0
                
            })
        }
    }
    func stop() {
        if isAnimating() {
            stopAnimating()
            removeFromSuperview()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}