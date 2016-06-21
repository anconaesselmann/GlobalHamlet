import UIKit

protocol PageViewDataSource {
    func get() -> AnyObject?
    func getPrevious() -> AnyObject?
    func getNext() -> AnyObject?
    func hasNext() -> Bool?
    func hasPrev() -> Bool?
    var length:Int {get}
    func getPage() -> UIView?
}

@IBDesignable class PageView: UIView, UIGestureRecognizerDelegate {
    var view: UIView!
    @IBOutlet weak var topView: UIView!
    var leftView:UIView!
    var rightView:UIView!
    var dataSource:PageViewDataSource!
    var currentPage:UIView?

    var delegate:UIViewController! {
        didSet {
            currentPage = dataSource.getPage()
            //            currentPage.delegate = delegate
            addSubview(currentPage!)
            bringSubviewToFront(currentPage!)
        }
    }

    
    var directionalPanGesture:DirectionalPanGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        view = getViewFromNib("PageView")
        super.addSubview(view)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        view = getViewFromNib("PageView")
        addSubview(view)
        setup()
    }
    func setup() {
        createLeftView()
        createRightView()
        directionalPanGesture = DirectionalPanGestureRecognizer(target: self, action: #selector(SlideView._pan(_:)))
        directionalPanGesture.delegate = self
        view.addGestureRecognizer(directionalPanGesture)
        directionalPanGesture.displacementTriggerValue = CGFloat(80)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return gestureRecognizer is DirectionalPanGestureRecognizer
    }
    
    
    
    func resetViews() {
        resetLeftView()
        resetRightView()
    }
    
    func createLeftView() {
        if leftView == nil {
            var rect = view.bounds
            rect.origin.x -= rect.width
            leftView = UIView(frame: rect)
            leftView!.backgroundColor = UIColor.greenColor()
            view.addSubview(leftView!)
        }
    }
    func createRightView() {
        if rightView == nil {
            var rect = view.bounds
            rect.origin.x += rect.width
            rightView = UIView(frame: rect)
            rightView!.backgroundColor = UIColor.orangeColor()
            view.addSubview(rightView!)
        }
    }
    func resetLeftView() {
        guard leftView != nil else {
            return
        }
        leftView.bounds = view.bounds
        leftView.center = view.center
        leftView.center.x = view.center.x - view.bounds.width
    }
    func resetRightView() {
        guard rightView != nil else {
            return
        }
        rightView.bounds = view.bounds
        rightView.center = view.center
        rightView.center.x = view.center.x + view.bounds.width
    }
    
    func _pan(sender: DirectionalPanGestureRecognizer?) {
        guard let state = sender?.state else {return}
        switch state {
        case .Began:
            print("Began")
            resetViews()
        case .Ended:
            let displacement = sender!.displacementDelta
            if sender!.triggerValueReached {
                if displacement < 0 {
                    leftSlideAction(sender)
                } else {
                    rightSlideAction(sender)
                }
            } else {
                resetAction()
            }
        case .Failed, .Cancelled:
            print("Has failed or canceled")
            resetAction()
        case .Changed:
            print("Changed")
            guard let displacementDelta = sender?.displacementDelta
                else {return}
            topView.center.x += displacementDelta
            leftView?.center.x += displacementDelta
            rightView?.center.x += displacementDelta
        default: print("Default????? \(state.hashValue)")
        }
    }
    func resetAction() {
        UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseOut, animations: {
            self.topView.center.x = self.view.center.x
            self.leftView?.center.x = self.view.center.x - self.view.bounds.width
            self.rightView?.center.x = self.view.center.x + self.view.bounds.width
            }, completion: { finished in
                print("done")
        })
    }
    func leftSlideAction(sender:DirectionalPanGestureRecognizer?) {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: {
            self.topView.center.x = self.view.center.x - self.view.bounds.width
            self.leftView?.center.x = self.view.center.x - 2 * self.view.bounds.width
            self.rightView?.center.x = self.view.center.x
        }, completion: { finished in
            print("done")
            self.topView.center = self.view.center
            self.resetViews()
        })
    }
    func rightSlideAction(sender:DirectionalPanGestureRecognizer?) {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: {
            self.topView.center.x = self.view.center.x + self.view.bounds.width
            self.leftView?.center.x = self.view.center.x
            self.rightView?.center.x = self.view.center.x + 2 * self.view.bounds.width
            }, completion: { finished in
                print("done")
                self.topView.center = self.view.center
                self.resetViews()
        })
    }
}
