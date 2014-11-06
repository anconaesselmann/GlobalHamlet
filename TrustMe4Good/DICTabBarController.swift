import UIKit

class DICTabBarController: UITabBarController, DICControllerProtocol {
    var dic: DICProtocol!
    let _diHelper = DIHelper()
    
    func initWithArgs(args:[AnyObject]) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _diHelper.conrollerInjection(dic, controller: self)
        /*var candidateDICViewController: DICControllerProtocol?
        
        if  dic != nil {
            if let destinationViewController = childViewControllers[0] as? DICControllerProtocol {
                destinationViewController.dic = self.dic
                dic.decorate(destinationViewController)
            } else {
                println(_stdlib_getDemangledTypeName(childViewControllers[0]) + " is not a DICController\n\n")
            }
        } else {
            println(_stdlib_getDemangledTypeName(self) + " has no dic\n\n")
        }*/
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        _diHelper.segueInjection(dic, segue: segue)
    }
}