import UIKit

class DICViewController: UIViewController, DICControllerProtocol {
    var dic: DICProtocol!
    
    func initWithArgs(args:[AnyObject]) {}

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender: sender)
        if  dic != nil {
            if let destinationViewController = segue.destinationViewController as? DICControllerProtocol {
                destinationViewController.dic = self.dic
                dic.decorate(destinationViewController)
            } else {
                println(_stdlib_getDemangledTypeName(segue.destinationViewController) + " is not a DICController\n\n")
            }
        } else {
            println(_stdlib_getDemangledTypeName(self) + " has no dic\n\n")
        }
    }
}