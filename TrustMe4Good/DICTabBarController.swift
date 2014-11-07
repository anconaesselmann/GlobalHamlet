import UIKit

class DICTabBarController: UITabBarController, DICControllerProtocol {
    var dic: DICProtocol!
    let _diHelper = DIHelper()
    
    func initWithArgs(args:[AnyObject]) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _diHelper.conrollerInjection(dic, controller: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        _diHelper.segueInjection(dic, segue: segue)
    }
}