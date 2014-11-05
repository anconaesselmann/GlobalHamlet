import CoreData
import UIKit

class DICAppDelegate: UIResponder, UIApplicationDelegate {
    var dic: DICProtocol!
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        dic = DIFactory(fileName: "config")
        
        var candidateDICViewController: DICControllerProtocol?
        
        if let navigationController = window!.rootViewController as? UINavigationController {
            candidateDICViewController = navigationController.viewControllers[0] as? DICControllerProtocol
        } else {
            candidateDICViewController = window!.rootViewController as? DICControllerProtocol
        }
        if candidateDICViewController != nil {
            candidateDICViewController!.dic = dic
            dic.decorate(candidateDICViewController!)
        }
        
        return true
    }
}

