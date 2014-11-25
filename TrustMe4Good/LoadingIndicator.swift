import Foundation
import UIKit

class LoadingIndicator: UIImageView {
    var loadingImages = [UIImage]()
    var delegateView:UIView!
    
    init(view:UIView) {
        delegateView = view
        super.init(frame:CGRectMake(0, 0, 100, 100))
        
        view.addSubview(self)
        center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2);
        
        for i in 0...7 {
            let imageName = "loading_\(i)"
            loadingImages.append(UIImage(named: imageName)!)
        }
        animationImages = loadingImages
        animationDuration = 1.2
        startAnimating()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stop() {
        stopAnimating()
        removeFromSuperview()
    }
}