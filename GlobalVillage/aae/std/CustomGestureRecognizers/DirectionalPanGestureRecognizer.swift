import UIKit
import UIKit.UIGestureRecognizerSubclass

class DirectionalPanGestureRecognizer: UIGestureRecognizer {
    
    var triggerValueReached = false
    
    var tolerance = 10
    var threshold = 10
    
    var displacement:CGFloat?
    var displacementDelta:CGFloat?
    var displacementTriggerValue:CGFloat = CGFloat(150)
    
    private var initialPoint:CGPoint?
    private var currentPoint:CGPoint?
    private var prevPoint:CGPoint!
    
    // MARK: - UIGestureRecognizer
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        if touches.count != 1 {
            state = .Failed
        }
        guard let loc = getLocationInWindow(touches) else {
            return
        }
        initialPoint = loc
        prevPoint = initialPoint
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        state = .Ended
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        guard state != .Failed, let loc = getLocationInWindow(touches) else {
            print("Gesture failed")
            return
        }
        currentPoint = loc
        displacement = currentPoint!.x - initialPoint!.x
        displacementDelta = currentPoint!.x - prevPoint!.x
        prevPoint = loc
        if !touchesHasBegun() {
            guard let error = getError() where error < CGFloat(tolerance) else {
                state = .Failed
                print("error tolerance exeeded")
                return
            }
            guard let initialDisplacement = displacement where abs(Int(initialDisplacement)) > threshold else {
                print("threshold not yet reached.")
                return
            }
            state = .Began
            return
        }
        state = .Changed
        if abs(Int(displacement!)) > Int(displacementTriggerValue) {
            state = .Ended
            triggerValueReached = true
        }
    }
    override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesCancelled(touches, withEvent: event)
        state = .Cancelled
    }
    override func reset() {
        super.reset()
        state             = .Possible
        initialPoint      = nil
        currentPoint      = nil
        prevPoint         = nil
        displacement      = nil
        displacementDelta = nil
        triggerValueReached = false
    }
    
    // MARK: - Private helper functions
    
    private func getLocationInWindow(touches: Set<UITouch>) -> CGPoint? {
        guard let window = view?.window else {
            print("Could not get window from view")
            return nil
        }
        guard let loc = touches.first?.locationInView(window) else {
            print("could not get location in window")
            return nil
        }
        return loc
    }
    private func getError() -> CGFloat? {
        return currentPoint!.y - initialPoint!.y
    }
    private func getDisplacement() -> CGFloat? {
        return currentPoint!.x - initialPoint!.x
    }
    private func touchesHasBegun() -> Bool {
        return (state == .Began || state == .Changed)
    }
}

