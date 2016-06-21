import Foundation
import UIKit

@IBDesignable class BudgetBar: UIView {
    
    var barView:UIView?
    var blackBarView:UIView?
    var rightBarView:UIView?
    var label100Percent:UILabel?
    
    @IBInspectable var barHeight = 20.0
    @IBInspectable var borderWidth = 1.0
    @IBInspectable var percentValue = 0.5
    @IBInspectable var fontSize = 12.0
    @IBInspectable var fontType = "Noteworthy-Bold"
    @IBInspectable var barOpacity = 1.0
    var soundCallbackBlack:(()->Void)!
    var soundCallbackRight:(()->Void)!
    var stopSoundCallbackBlack:(()->Void)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        opaque = false
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func drawRect(rect: CGRect) {
        drawBars()
    }
    
    func setValue(value:Double) {
        percentValue = value
        setNeedsDisplay()
    }
    func setWithAnimation(value:Double, withDuration duration:Double) {
        setWithAnimation(value, withDuration: duration) {_ in}
    }
    func setWithAnimation(value:Double, withDuration duration:Double, callbackAfterFirstAnimation:((Double)->Void)) {
        percentValue = value
        drawBars()
        guard
            let rightBarView = rightBarView,
            let blackBarView = blackBarView,
            let barView      = barView
            else {return}
        
//        let blackDuration = Double((blackBarView.frame.width / barView.frame.width)) * duration
//        let rightDuration = Double((rightBarView.frame.width / barView.frame.width)) * duration
        
        let blackDuration = duration / 2.0
        let rightDuration = duration / 2.0
        
        guard let blackAnimation = getBlackAnimation() else {return}
        setBlackFrameBeforeAnimation()
        
        if soundCallbackBlack != nil {
            soundCallbackBlack()
        }
        UIView.animateWithDuration(blackDuration, animations: blackAnimation) {[weak self] success in
            guard self != nil else {return}
            callbackAfterFirstAnimation(rightDuration)
            if self!.stopSoundCallbackBlack != nil {
                self!.stopSoundCallbackBlack()
            }
            guard let rightAnimation = self!.getRightAnimation() else {return}
            self!.setRightFrameBeforeAnimation()
            if self!.soundCallbackRight != nil {
                self!.soundCallbackRight()
            }
            UIView.animateWithDuration(rightDuration, animations: rightAnimation)
        }
    }
    func setWithAnimationBlackBar(value:Double, withDuration duration:Double) {
        percentValue = value
        drawBars()
        guard let blackAnimation = getBlackAnimation() else {return}
        setBlackFrameBeforeAnimation()
        UIView.animateWithDuration(duration, animations: blackAnimation)
    }
    private func getBlackAnimation() ->(()->Void)? {
        guard
            let blackBarView = blackBarView
        else {return nil}
        let blackFinalFrame = blackBarView.frame
        let animations = {[weak self] in
            guard self != nil else {return}
            guard let blackBarView = self!.blackBarView
                else {return}
            blackBarView.frame = blackFinalFrame
        }
        return animations
    }
    private func getRightAnimation() ->(()->Void)? {
        guard let rightBarView = rightBarView
            else {return nil}
        let rightFinalFrame   = rightBarView.frame
        let animations = {[weak self] in
            guard self != nil else {return}
            guard let rightBarView = self!.rightBarView
                else {return}
            rightBarView.frame = rightFinalFrame
        }
        return animations
    }
    private func setRightFrameBeforeAnimation() {
        guard let rightBarView = rightBarView
            else {return}
        rightBarView.hidden = false
        let rightInitialFrame = CGRect(x: rightBarView.frame.minX, y: rightBarView.frame.minY, width: 0, height: rightBarView.frame.height)
        rightBarView.frame = rightInitialFrame
    }
    private func setBlackFrameBeforeAnimation() {
        guard
            let blackBarView = blackBarView,
            let rightBarView = rightBarView
            else {return}
        rightBarView.hidden = true
        let blackInitialFrame = CGRect(x: blackBarView.frame.minX, y: blackBarView.frame.minY, width: 0, height: blackBarView.frame.height)
        blackBarView.frame = blackInitialFrame
    }
    func setWithAnimationRightBar(value:Double, withDuration duration:Double) {
        percentValue = value
        drawBars()
        guard let rightAnimation = getRightAnimation() else {return}
        setRightFrameBeforeAnimation()
        UIView.animateWithDuration(duration, animations: rightAnimation)
    }
    private func drawBars() {
        drawBarView()
        drawBlackBarView()
        drawRightBarView()
        drawLabel100Percent()
    }
    private func drawBarView() {
        if barView == nil {
            barView = UIView()
            addSubview(barView!)
        }
        barView!.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        let newFrame = CGRect(x: 0, y: CGFloat(fontSize), width: CGFloat(frame.width), height: CGFloat(barHeight))
        barView!.frame = newFrame
        
        barView!.layer.borderColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha: 1.0).CGColor
        barView!.layer.borderWidth = CGFloat(borderWidth)
    }
    private func getBlackWidth() -> CGFloat {
        if percentValue <= 1.0 {
            return frame.size.width * CGFloat(percentValue)
        } else {
            return frame.size.width / CGFloat(percentValue)
        }
    }
    private func drawBlackBarView() {
        guard let barView = barView else {return}
        if blackBarView == nil {
            blackBarView = UIView()
            barView.addSubview(blackBarView!)
        }
        blackBarView!.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(CGFloat(barOpacity))
        let newFrame = CGRect(x: 0, y: 0, width: getBlackWidth(), height: CGFloat(barHeight))
        blackBarView!.frame = newFrame
        
        blackBarView!.layer.borderColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha: 1.0).CGColor
        blackBarView!.layer.borderWidth = CGFloat(borderWidth)
    }
    private func getRightBarColor() -> UIColor {
        if percentValue <= 1.0 {
            return UIColor.greenColor()
        }
        return UIColor.redColor()
    }
    private func drawRightBarView() {
        guard let barView = barView else {return}
        if rightBarView == nil {
            rightBarView = UIView()
            barView.addSubview(rightBarView!)
        }
        rightBarView!.backgroundColor = getRightBarColor().colorWithAlphaComponent(CGFloat(barOpacity))
        let rightBarWidth = barView.frame.width - getBlackWidth()
        let newFrame = CGRect(x: getBlackWidth(), y: 0, width: rightBarWidth, height: CGFloat(barHeight))
        rightBarView!.frame = newFrame
        
        rightBarView!.layer.borderColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha: 1.0).CGColor
        rightBarView!.layer.borderWidth = CGFloat(borderWidth)
    }
    private func getLabelCenter() -> CGPoint? {
        guard let label100Percent = label100Percent else {return nil}
        let labelCenterY = fontSize / 2.0
        let labelCenterOffset = label100Percent.intrinsicContentSize().width / 2.0
        if percentValue <= 1.0 {
            return CGPoint(x: frame.width - labelCenterOffset, y: CGFloat(labelCenterY))
        } else {
            let tempX = getBlackWidth()
            let x = tempX < labelCenterOffset ? labelCenterOffset : tempX
            return CGPoint(x: x, y: CGFloat(labelCenterY))
        }
    }
    private func drawLabel100Percent() {
        if label100Percent == nil {
            label100Percent = UILabel()
            addSubview(label100Percent!)
        }
        label100Percent!.text = "100%"
        label100Percent!.font = UIFont(name: fontType, size: CGFloat(fontSize))
        label100Percent!.sizeToFit()
        guard let center = getLabelCenter() else {return}
        label100Percent!.center = center
    }
    func releaseResources() {
        if barView != nil {
            barView!.removeFromSuperview()
            barView = nil
        }
        if blackBarView != nil {
            blackBarView!.removeFromSuperview()
            blackBarView = nil
        }
        if rightBarView != nil {
            rightBarView!.removeFromSuperview()
            rightBarView = nil
        }
        if label100Percent != nil {
            label100Percent!.removeFromSuperview()
            label100Percent = nil
        }
    }
    deinit {
        print("BudgetBar deinit called")
        releaseResources()
    }
}