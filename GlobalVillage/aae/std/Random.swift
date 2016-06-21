import Foundation
import UIKit
class Random {
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    func getRandomPosition(view:UIView) -> CGPoint {
        let x = randomBetweenNumbers(0, secondNum: view.frame.size.width);
        let y = randomBetweenNumbers(0, secondNum: view.frame.size.height);
        
        return CGPointMake(x, y);
    }
}