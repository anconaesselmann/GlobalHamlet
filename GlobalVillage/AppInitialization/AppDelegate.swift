import CoreData
import UIKit

@UIApplicationMain
class AppDelegate: DICAppDelegate {

    override func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        super.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "AppInitializationStoryboard", bundle: nil)
        let loadingScreenViewController : LoadingScreenViewController = mainView.instantiateViewControllerWithIdentifier("LoadingScreenViewController") as! LoadingScreenViewController
        self.window!.rootViewController = loadingScreenViewController
        
        if let url = (dic.get("url") as? String) {
            print("using \(url)")
            if let api = (dic.build("api") as? ApiController) {
                let loginUrl = url + "/login"
                print("logging in with \(loginUrl)")
                api.request(loginUrl) {response in
                    print("received login results \(response)")
                    if let errorCode = response["errorCode"] as? Int {
                        print("error code: \(errorCode)")
                        if errorCode != 0 {
                            if let errorMessage = response["errorMessage"] as? String {print("Error \(errorCode) logging in: \(errorMessage)")}
                            else {print("Error \(errorCode) logging in. No error message received")}
                        } else {
                            if let response = response["response"] as? String {
                                if let booleanResponse = response.toBool() {
                                    if booleanResponse == true {
                                        print("successfully logged in with cookie")
                                        let targetStoryboardName = self.dic.get("loginSegueStoryboardName") as! String
                                        let targetStoryboard     = UIStoryboard(name: targetStoryboardName, bundle: nil)
                                        if let targetViewController = targetStoryboard.instantiateInitialViewController() {
                                            loadingScreenViewController.presentViewController(targetViewController, animated: false, completion: nil)
                                        }
                                    }
                                }
                            }
                            if let loggedIn = response["response"] as? Bool {
                                if loggedIn {

                                } else {
                                    print("cookie login did not work")
                                }
                            }
                        }
                    }
                    loadingScreenViewController.perfomrSegue(false)
                };
            }
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

