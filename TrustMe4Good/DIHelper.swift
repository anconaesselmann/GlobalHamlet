import UIKit
import Foundation

class DIHelper {
    func segueInjection(dic: DICProtocol?, segue: UIStoryboardSegue) {
        if  dic != nil {
            if let destinationViewController = segue.destinationViewController as? DICControllerProtocol {
                destinationViewController.dic = dic
                dic!.decorate(destinationViewController)
            } else {
                println(_stdlib_getDemangledTypeName(segue.destinationViewController) + " is not a DICController\n\n")
            }
        } else {
            println(_stdlib_getDemangledTypeName(segue.destinationViewController) + " has no dic\n\n")
        }
    }
    
    func conrollerInjection(dic: DICProtocol?, controller: UIViewController) {
        var candidateDICViewController: DICControllerProtocol?
        
        if  dic != nil {
            if let destinationViewController = controller.childViewControllers[0] as? DICControllerProtocol {
                destinationViewController.dic = dic
                dic!.decorate(destinationViewController)
            } else {
                println(_stdlib_getDemangledTypeName(controller.childViewControllers[0]) + " is not a DICController\n\n")
            }
        } else {
            println(_stdlib_getDemangledTypeName(controller) + " has no dic\n\n")
        }
    }
}