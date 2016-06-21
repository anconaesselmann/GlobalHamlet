import UIKit

extension UIView {
    func getViewFromNib(nibName:String) -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib    = UINib(nibName: nibName, bundle: bundle)
        let view   = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        return view
    }
}