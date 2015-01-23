import UIKit

class DICViewController: UIViewController, DICControllerProtocol {
    var dic: DICProtocol!
    let _diHelper = DIHelper()
    
    func initWithArgs(args:[AnyObject]) {}

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        _diHelper.segueInjection(dic, segue: segue)
    }
}