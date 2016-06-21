import UIKit

public class DICViewController: UIViewController, DICControllerProtocol {
    public var dic: DICProtocol {
        get {
            let appDelegate = UIApplication.sharedApplication().delegate as! DICAppDelegate
            return appDelegate.dic
        }
        set {}
    }
    let _diHelper = DIHelper()
    
    public func initWithArgs(args:[AnyObject]) {}

    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        _diHelper.segueInjection(dic, segue: segue)
    }
}