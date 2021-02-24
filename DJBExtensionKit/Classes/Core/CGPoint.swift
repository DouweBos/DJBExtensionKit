//
//  CGPoint.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 23/2/21.
//

import Foundation

public extension CGPoint {
    static func pointOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        let x = center.x + radius * cos(angle.radians)
        let y = center.y + radius * sin(angle.radians)
        
        return CGPoint(x: x, y: y)
    }
    
    static func pointOnRect(size: CGSize, angle: CGFloat) -> CGPoint {
        enum Quadrant {
            case a
            case b
            case c
            case d
            case e
            case f
            case g
            case h
            
            static func from(angle: CGFloat) -> Quadrant {
                let angle = angle.truncatingRemainder(dividingBy: 360.0)
                
                if angle < 45.0 {
                    return .a
                } else if angle >= 45.0 && angle < 90.0 {
                    return .b
                } else if angle >= 90.0 && angle < 135.0 {
                    return .c
                } else if angle >= 135.0 && angle < 180.0 {
                    return .d
                } else if angle >= 180.0 && angle < 225.0 {
                    return .e
                } else if angle >= 225.0 && angle < 270.0 {
                    return .f
                } else if angle >= 270.0 && angle < 315.0 {
                    return .g
                } else {
                    return .h
                }
            }
        }
        
        enum Direction {
            case top
            case right
            case bottom
            case left
            
            static func from(angle: CGFloat) -> Direction {
                let angle = angle.truncatingRemainder(dividingBy: 360.0)
                
                let direction = round(angle / 90.0)
                
                if direction == 0.0 {
                    return .top
                } else if direction == 1.0 {
                    return .right
                } else if direction == 2.0 {
                    return .bottom
                } else {
                    return .left
                }
            }
        }
        
        let angle = angle.truncatingRemainder(dividingBy: 360.0)
        
        let is90Degrees = angle.truncatingRemainder(dividingBy: 90.0) == 0.0
        
        let width = size.width
        let height = size.height
        let halfWidth = width / 2.0
        let halfHeight = height / 2.0
        
        // Since this would be infinite
        if is90Degrees {
            switch Direction.from(angle: angle) {
            case .top:
                return CGPoint(x: halfWidth, y: 0.0)
            case .right:
                return CGPoint(x: width, y: halfHeight)
            case .bottom:
                return CGPoint(x: halfWidth, y: height)
            case .left:
                return CGPoint(x: 0.0, y: halfHeight)
            }
        } else {
            switch Quadrant.from(angle: angle) {
            case .a:
                let rad = angle.radians
                let delta = halfHeight / tan(rad)
                return CGPoint(x: halfWidth + delta, y: 0.0)
            case .b:
                let rad = (90.0 - angle).radians
                let delta = halfWidth / tan(rad)
                return CGPoint(x: width, y: halfHeight - delta)
            case .c:
                let rad = (angle - 90.0).radians
                let delta = halfWidth / tan(rad)
                return CGPoint(x: width, y: halfHeight + delta)
            case .d:
                let rad = (180.0 - angle).radians
                let delta = halfHeight / tan(rad)
                return CGPoint(x: halfWidth + delta, y: height)
            case .e:
                let rad = (angle - 180.0).radians
                let delta = halfHeight / tan(rad)
                return CGPoint(x: halfWidth + delta, y: height)
            case .f:
                let rad = (270.0 - angle)
                let delta = halfWidth / tan(rad)
                return CGPoint(x: 0.0, y: halfHeight + delta)
            case .g:
                let rad = (angle - 270.0).radians
                let delta = halfWidth / tan(rad)
                return CGPoint(x: 0.0, y: halfHeight - delta)
            case .h:
                let rad = (360.0 - angle).radians
                let delta = halfHeight / tan(rad)
                return CGPoint(x: halfWidth - delta, y: 0.0)
            }
        }
    }
    
    static func angleBetweenThreePoints(center: CGPoint, firstPoint: CGPoint, secondPoint: CGPoint) -> CGFloat {
        let firstAngle = atan2(firstPoint.y - center.y, firstPoint.x - center.x)
        let secondAnlge = atan2(secondPoint.y - center.y, secondPoint.x - center.x)
        var angleDiff = firstAngle - secondAnlge
        
        if angleDiff < 0 {
            angleDiff *= -1
        }
        
        return angleDiff
    }
    
    func angleBetweenPoints(firstPoint: CGPoint, secondPoint: CGPoint) -> CGFloat {
        return CGPoint.angleBetweenThreePoints(center: self, firstPoint: firstPoint, secondPoint: secondPoint)
    }
    
    func angleToPoint(pointOnCircle: CGPoint) -> CGFloat {
        
        let originX = pointOnCircle.x - self.x
        let originY = pointOnCircle.y - self.y
        var radians = atan2(originY, originX)
        
        while radians < 0 {
            radians += CGFloat(2 * Double.pi)
        }
        
        return radians
    }
    
    static func pointOnCircleAtArcDistance(center: CGPoint,
                                           point: CGPoint,
                                           radius: CGFloat,
                                           arcDistance: CGFloat,
                                           clockwise: Bool) -> CGPoint {
        
        var angle = center.angleToPoint(pointOnCircle: point);
        
        if clockwise {
            angle = angle + (arcDistance / radius)
        } else {
            angle = angle - (arcDistance / radius)
        }
        
        return self.pointOnCircle(center: center, radius: radius, angle: angle)
        
    }
    
    func distanceToPoint(otherPoint: CGPoint) -> CGFloat {
        return sqrt(pow((otherPoint.x - x), 2) + pow((otherPoint.y - y), 2))
    }
    
    static func CGPointRound(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: CoreGraphics.round(point.x), y: CoreGraphics.round(point.y))
    }
    
    static func intersectingPointsOfCircles(firstCenter: CGPoint, secondCenter: CGPoint, firstRadius: CGFloat, secondRadius: CGFloat ) -> (firstPoint: CGPoint?, secondPoint: CGPoint?) {
        
        let distance = firstCenter.distanceToPoint(otherPoint: secondCenter)
        let m = firstRadius + secondRadius
        var n = firstRadius - secondRadius
        
        if n < 0 {
            n = n * -1
        }
        
        //no intersection
        if distance > m {
            return (firstPoint: nil, secondPoint: nil)
        }
        
        //circle is inside other circle
        if distance < n {
            return (firstPoint: nil, secondPoint: nil)
        }
        
        //same circle
        if distance == 0 && firstRadius == secondRadius {
            return (firstPoint: nil, secondPoint: nil)
        }
        
        let a = ((firstRadius * firstRadius) - (secondRadius * secondRadius) + (distance * distance)) / (2 * distance)
        let h = sqrt(firstRadius * firstRadius - a * a)
        
        var p = CGPoint.zero
        p.x = firstCenter.x + (a / distance) * (secondCenter.x - firstCenter.x)
        p.y = firstCenter.y + (a / distance) * (secondCenter.y - firstCenter.y)
        
        //only one point intersecting
        if distance == firstRadius + secondRadius {
            return (firstPoint: p, secondPoint: nil)
        }
        
        var p1 = CGPoint.zero
        var p2 = CGPoint.zero
        
        p1.x = p.x + (h / distance) * (secondCenter.y - firstCenter.y)
        p1.y = p.y - (h / distance) * (secondCenter.x - firstCenter.x)
        
        p2.x = p.x - (h / distance) * (secondCenter.y - firstCenter.y)
        p2.y = p.y + (h / distance) * (secondCenter.x - firstCenter.x)
        
        //return both points
        return (firstPoint: p1, secondPoint: p2)
    }
}
