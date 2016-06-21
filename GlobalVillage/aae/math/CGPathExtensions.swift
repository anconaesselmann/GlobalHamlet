
import Foundation
import CoreGraphics

extension CGPath {
    func forEach(@noescape body: @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        func callback(info: UnsafeMutablePointer<Void>, element: UnsafePointer<CGPathElement>) {
            let body = unsafeBitCast(info, Body.self)
            body(element.memory)
        }
        let unsafeBody = unsafeBitCast(body, UnsafeMutablePointer<Void>.self)
        CGPathApply(self, unsafeBody, callback)
    }
}
extension CGPoint {
    func distance(point:CGPoint) -> CGFloat {
        return sqrt(pow((point.x - self.x), 2) + pow((point.y - self.y),2))
    }
}
extension CGVector {
    func getLength() -> CGFloat {
        return sqrt(
            pow(self.dx, 2) +
            pow(self.dy, 2)
        )
    }
    func getUnitVector() -> CGVector {
        let length = self.getLength()
        return CGVector(dx: self.dx / length, dy: self.dy / length)
    }
    init(p1:CGPoint, p2:CGPoint) {
        self.dx = p2.x - p1.x
        self.dy = p2.y - p1.y
    }
    func scaled(factor:CGFloat) -> CGVector {
        let unit = self.getUnitVector()
        return CGVector(dx: factor * unit.dx, dy: factor * unit.dy)
    }
}
extension CGPath {
    func length() -> CGFloat {
        var last:CGPoint?
        var sum = CGFloat(0);
        forEach { element in
            let point = element.points[0]
            if last != nil {
                sum += last!.distance(point)
            }
            last = point
        }
        return sum
    }
    func getPoints() -> [CGPoint] {
        var points = [CGPoint]()
        forEach { element in
            points.append(element.points[0])
        }
        return points
    }
}