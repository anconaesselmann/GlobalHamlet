import UIKit
import Foundation

class DIHelper {
    func segueInjection(dic: DICProtocol?, segue: UIStoryboardSegue) {
        guard dic != nil else {
            print(String(segue.destinationViewController.dynamicType) + " has no dic\n\n")
            return
        }
        guard let destinationViewController = segue.destinationViewController as? DICControllerProtocol else {
            print(String(segue.destinationViewController.dynamicType) + " is not a DICController\n\n")
            return
        }
        dic!.decorate(destinationViewController)
    }
    func conrollerInjection(dic: DICProtocol?, controller: UIViewController) {
        guard dic != nil else {
            print(String(controller.dynamicType) + " has no dic\n\n")
            return
        }
        for index in 0...(controller.childViewControllers.count - 1) {
            if let destinationViewController = controller.childViewControllers[index] as? DICControllerProtocol {
                dic!.decorate(destinationViewController)
            } else {
                print(String(controller.childViewControllers[index].dynamicType) + " is not a DICController\n\n")
            }
        }
    }
}