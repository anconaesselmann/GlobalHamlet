import UIKit

protocol SlideViewDelegate {
    func leftSlideAction(sender: DirectionalPanGestureRecognizer?)
    func rightSlideAction(sender: DirectionalPanGestureRecognizer?)
}

@IBDesignable class SlideView:UIView, UIGestureRecognizerDelegate {
    var view:UIView!;
    var delegate:SlideViewDelegate!
    var directionalPanGesture: DirectionalPanGestureRecognizer!
    var initialPoint:CGPoint?
    
    @IBOutlet weak var topView:   UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView:  UIView!
    
    @IBInspectable var rightColor:UIColor!
        {didSet{rightView.backgroundColor=rightColor}}
    @IBInspectable var leftColor:UIColor!
        {didSet{leftView.backgroundColor = leftColor}}
    @IBInspectable var topColor:UIColor!
        {didSet{topView.backgroundColor = topColor}}
    @IBInspectable var displacementTriggerValue:Int = 150
        {didSet{directionalPanGesture.displacementTriggerValue = CGFloat(displacementTriggerValue)}}
    
    func addSubViewFromNib(nibName:String) -> UIView {
        let view = getViewFromNib("PostCellContentView")
        addSubviewToTopView(view)
        return view
    }
    func addSubviewToTopView(view: UIView) {
        view.frame = topView.bounds
        topView.addSubview(view)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = getViewFromNib("SlideView")
        super.addSubview(view)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let view = getViewFromNib("SlideView")
        addSubview(view)
        setup()
    }
    func setup() {
        directionalPanGesture = DirectionalPanGestureRecognizer(target: self, action: #selector(SlideView._pan(_:)))
        directionalPanGesture.delegate = self
        view.addGestureRecognizer(directionalPanGesture)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return gestureRecognizer is DirectionalPanGestureRecognizer
    }
    func _pan(sender: DirectionalPanGestureRecognizer?) {
        guard let state = sender?.state else {return}
        switch state {
        case .Began: initialPoint = topView.center
        case .Ended:
            guard initialPoint != nil else {return}
            topView.center = initialPoint!
            initialPoint = nil
            let displacement = sender!.displacementDelta
            if sender!.triggerValueReached {
                if displacement < 0 {
                    delegate.leftSlideAction(sender)
                } else {
                    delegate.rightSlideAction(sender)
                }
            }
        case .Failed, .Cancelled:
            print("Has failed or canceled")
            guard initialPoint != nil else {return}
            topView.center = initialPoint!
            initialPoint = nil
        case .Changed:
            print("Changed")
            guard let displacementDelta = sender?.displacementDelta
                else {return}
            topView.center.x += displacementDelta
        default: print("Default????? \(state.hashValue)")
        }
    }
}