//
//  AppDelegate.swift
//  TrustMe4Good
//
//  Created by Axel Ancona Esselmann on 10/31/14.
//  Copyright (c) 2014 Axel Ancona Esselmann. All rights reserved.
//
import CoreData
import UIKit

@UIApplicationMain
class AppDelegate: DICAppDelegate, UIApplicationDelegate {

    override func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyBoardId: String = (self._isLoggedIn()) ? "MainTabBarController" : "InitialViewController"
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier(storyBoardId) as? UIViewController
        window!.rootViewController = viewController
        window!.makeKeyAndVisible()

        
        super.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func _isLoggedIn() -> Bool {
        /*let response = _web.postRequst("http://www.api.anconaesselmann.dev/login") as NSDictionary;
        println(response["response"] as Bool)
        println(response["errorCode"] as Int)

        if response["response"] as Bool != true {
            //self.performSegueWithIdentifier("isLoggedInSegueToMain", sender: self)
            return true
        }*/
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

