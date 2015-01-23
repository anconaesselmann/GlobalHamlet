import UIKit

class DICTableViewController: UITableViewController, DICControllerProtocol {
    var dic: DICProtocol!
    let _diHelper = DIHelper()
    
    func initWithArgs(args:[AnyObject]) {}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        _diHelper.segueInjection(dic, segue: segue)
    }
}