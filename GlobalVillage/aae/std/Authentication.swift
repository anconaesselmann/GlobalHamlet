//
//  Authentication.swift
//  socipelago
//
//  Created by Axel Ancona Esselmann on 3/14/16.
//  Copyright © 2016 Axel Ancona Esselmann. All rights reserved.
//

import Foundation
import UIKit

class Authentication {
    var authenticated = false
    var errorMessage = "Server response has not been processed."
    
    func processServerResponse(results: ApiResponse) -> Bool {
        guard let jsonResponse = Json.unserialize(results.response) as? [String:AnyObject] else {
            let error    = "Error signing in."
            errorMessage = error
            print(errorMessage)
            print("Error \(results.errorCode) with message:\n\(results.errorMessage)")
            return false
        }
        guard let user = (JsonObjectMapper.mapTemp(json: jsonResponse, withKey: "user", toObjectInstance: User(withId: -1, andName: "")) as? User ) else {
            print("could not unwrap user from \(jsonResponse)")
            return false
        }
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setValue(user.userId, forKey: "userId")
        prefs.setValue(user.userName, forKey: "userName")
        
        authenticated = true
        print("logging in.")
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        appDelegate.loggedIn = true
        appDelegate.promotional = user.isPromotional()
        return true
    }
    
    func updateUI(targetStoryboardName: String, currentViewController: UIViewController) {
        guard authenticated else {
            print("Not logged in")
            return
        }
        let targetStoryboard     = UIStoryboard(name: targetStoryboardName, bundle: nil)
        if let targetViewController = targetStoryboard.instantiateInitialViewController() {
            currentViewController.presentViewController(targetViewController, animated: false, completion: nil)
        }
    }
}