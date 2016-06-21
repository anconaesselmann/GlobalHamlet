
import Foundation
import UIKit

extension UITextView {
    func adjustForKeyboard(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardViewEndFrame = self.superview!.convertRect(keyboardScreenEndFrame, fromView: self.superview!.window)
        
        
        if notification.name == UIKeyboardWillHideNotification {
            self.contentInset = UIEdgeInsetsZero
        } else {
            self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        self.scrollIndicatorInsets = self.contentInset
        
        let selectedRange = self.selectedRange
        self.scrollRangeToVisible(selectedRange)
    }
}