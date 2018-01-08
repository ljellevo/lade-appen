//
//  SegueToFavorites.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 08.01.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import UIKit

class CustomPushSegue : NSObject, UIViewControllerAnimatedTransitioning {
    var duration: TimeInterval = 0.4
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        
        containerView.addSubview(toView)
        print("push")
        if transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? Favorites != nil {
            print("favorites")
            toView.frame = CGRect(x: -containerView.bounds.width, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
        
            let timingFunction = CAMediaTimingFunction(controlPoints: 0/6, 0.8, 3/6, 1.0)
            CATransaction.begin()
            CATransaction.setAnimationTimingFunction(timingFunction)
            UIView.animate(withDuration: duration, animations: {
                toView.frame = containerView.frame
            }, completion: { _ in
                transitionContext.completeTransition(true)
            } )
            CATransaction.commit()
        } else {
            print("profile")
            toView.frame = CGRect(x: containerView.bounds.width, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
            
            let timingFunction = CAMediaTimingFunction(controlPoints: 0/6, 0.8, 3/6, 1.0)
            CATransaction.begin()
            CATransaction.setAnimationTimingFunction(timingFunction)
            UIView.animate(withDuration: duration, animations: {
                toView.frame = containerView.frame
            }, completion: { _ in
                transitionContext.completeTransition(true)
            } )
        }
    }
}


class CustomPopSegue : NSObject, UIViewControllerAnimatedTransitioning {
    var duration: TimeInterval = 0.4
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        

        if transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? Favorites != nil {
            toView.frame = CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
            let timingFunction = CAMediaTimingFunction(controlPoints: 0/6, 0.8, 3/6, 1.0)
            CATransaction.begin()
            CATransaction.setAnimationTimingFunction(timingFunction)
            UIView.animate(withDuration: duration, animations: {
                fromView.frame = CGRect(x: -containerView.bounds.width, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
                toView.frame = containerView.frame
            }, completion: { _ in
                transitionContext.completeTransition(true)
            } )
            CATransaction.commit()
        } else {
            toView.frame = CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
            let timingFunction = CAMediaTimingFunction(controlPoints: 0/6, 0.8, 3/6, 1.0)
            CATransaction.begin()
            CATransaction.setAnimationTimingFunction(timingFunction)
            UIView.animate(withDuration: duration, animations: {
                fromView.frame = CGRect(x: containerView.bounds.width, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
                toView.frame = containerView.frame
            }, completion: { _ in
                transitionContext.completeTransition(true)
            } )
            CATransaction.commit()
        }
    }
}


class SimpleOver: NSObject, UIViewControllerAnimatedTransitioning {
    
    var popStyle: Bool = false
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.20
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if popStyle {
            
            animatePop(using: transitionContext)
            return
        }
        
        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let f = transitionContext.finalFrame(for: tz)
        
        let fOff = f.offsetBy(dx: f.width, dy: 55)
        tz.view.frame = fOff
        
        transitionContext.containerView.insertSubview(tz.view, aboveSubview: fz.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                tz.view.frame = f
        }, completion: {_ in
            transitionContext.completeTransition(true)
        })
    }
    
    func animatePop(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let f = transitionContext.initialFrame(for: fz)
        let fOffPop = f.offsetBy(dx: f.width, dy: 55)
        
        transitionContext.containerView.insertSubview(tz.view, belowSubview: fz.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fz.view.frame = fOffPop
        }, completion: {_ in
            transitionContext.completeTransition(true)
        })
    }
}

