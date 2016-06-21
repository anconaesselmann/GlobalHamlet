import UIKit
import UIKit.UIGestureRecognizerSubclass

class TrackGestureRecognizer: UIGestureRecognizer {
    
    var track = CGPathCreateMutable()
    var currentPoint:CGPoint?
    
    func hasNotBegun() -> Bool {
        return !(state == .Changed || state == .Began)
    }
    
    // MARK: - UIGestureRecognizer
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        guard touches.count == 1 else {
            state = .Failed
            return
        }
        guard let loc = getLocationInWindow(touches) else {
            return
        }
        CGPathMoveToPoint(track, nil, loc.x, loc.y)
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        if !hasNotBegun() {
            state = .Ended        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        guard let loc = getLocationInWindow(touches) else {
            state = .Failed
            return
        }
        if hasNotBegun() {
            state = .Began
        } else {
            state = .Changed
        }
        CGPathAddLineToPoint(track, nil, loc.x, loc.y)
        currentPoint = getLocationInWindow(touches)
    }
    override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesCancelled(touches, withEvent: event)
        state = .Cancelled
    }
    
    override func reset() {
        super.reset()
        state = .Possible
        track = CGPathCreateMutable()
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
}

