import CoreData
import UIKit

class DICAppDelegate: UIResponder, UIApplicationDelegate {
    var dic: DICProtocol = DIFactory(fileName: "config")
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        _viewControllerDiSetup()
        return true
    }
    
    func setRootViewController(storyBoardId: String) {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier(storyBoardId) as? UIViewController
        window!.rootViewController = viewController
        _viewControllerDiSetup()
        window!.makeKeyAndVisible()
    }
    
    func _viewControllerDiSetup() {
        if window != nil {
            var candidateDICViewController: DICControllerProtocol?
            
            if let navigationController = window!.rootViewController as? UINavigationController {
                candidateDICViewController = navigationController.viewControllers[0] as? DICControllerProtocol
                _diSetup(candidateDICViewController)
            }
            candidateDICViewController = window!.rootViewController as? DICControllerProtocol
            _diSetup(candidateDICViewController)
        }
    }
    
    func _diSetup(diCandidated: DICControllerProtocol?) {
        if diCandidated != nil {
            diCandidated!.dic = dic
            dic.decorate(diCandidated!)
        }
    }
}

