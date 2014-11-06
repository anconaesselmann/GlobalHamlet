import CoreData
import UIKit

class DICAppDelegate: UIResponder, UIApplicationDelegate {
    var dic: DICProtocol = DIFactory(fileName: "config")
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        var candidateDICViewController: DICControllerProtocol?
        
        if let navigationController = window!.rootViewController as? UINavigationController {
            candidateDICViewController = navigationController.viewControllers[0] as? DICControllerProtocol
            _diSetup(candidateDICViewController)
        }
        candidateDICViewController = window!.rootViewController as? DICControllerProtocol
        _diSetup(candidateDICViewController)
        
        
        return true
    }
    func _diSetup(diCandidated: DICControllerProtocol?) {
        if diCandidated != nil {
            diCandidated!.dic = dic
            dic.decorate(diCandidated!)
        }
    }
}

