//
//  SwipeableTableViewController.swift
//  socipelago
//
//  Created by Axel Ancona Esselmann on 3/16/16.
//  Copyright © 2016 Axel Ancona Esselmann. All rights reserved.
//

import Foundation
import UIKit

class SwipeableTableViewController: DICTableViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(SwipeableTableViewController._swipe(_:)))
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left
        swipeLeftGesture.delegate = self
        tableView.addGestureRecognizer(swipeLeftGesture)
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(SwipeableTableViewController._swipe(_:)))
        swipeRightGesture.direction = UISwipeGestureRecognizerDirection.Right
        swipeRightGesture.delegate = self
        tableView.addGestureRecognizer(swipeRightGesture)
    }
    
    func swipeLeft(atIndex indexPath:NSIndexPath) {
//        print("Left swipe at \(indexPath)")
    }
    func swipeRight(atIndex indexPath:NSIndexPath) {
//        print("Right swipe at \(indexPath)")
    }
    
    func _swipe(sender: UISwipeGestureRecognizer?) {
        guard let indexPath = _getIndexPathForSwipeGesture(sender),
              let direction = sender?.direction else {
            return
        }
        switch direction {
        case UISwipeGestureRecognizerDirection.Right:
            swipeRight(atIndex: indexPath)
        case UISwipeGestureRecognizerDirection.Left:
            swipeLeft(atIndex: indexPath)
        default:
            print("Unsupported swipe direction")
        }
    }
    
    func _getIndexPathForSwipeGesture(sender: UISwipeGestureRecognizer?) -> NSIndexPath? {
        guard let location = sender?.locationInView(tableView) else {
            print("Could not get index path from swipe gesture")
            return nil
        }
        guard let indexPath = tableView.indexPathForRowAtPoint(location) else {
            print("Could not get index path from swipe gesture")
            return nil
        }
        return indexPath
    }
}