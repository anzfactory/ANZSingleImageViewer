//
//  ANZSingleImageViewer+Transitioning.swift
//  Xcode10Project
//
//  Created by shingo asato on 2018/09/27.
//  Copyright © 2018年 sasato. All rights reserved.
//

import UIKit

extension ANZSingleImageViewer {

    final class AnimatedTransitioning: NSObject {
        
        private static let transitionDuration: TimeInterval = 0.3
        
        private var isForward: Bool = false
    }
}

// MARK: - Animation
extension ANZSingleImageViewer.AnimatedTransitioning {

    private func animateForward(context: UIViewControllerContextTransitioning) {
        
        guard
            let fromViewController = context.viewController(forKey: .from),
            let toViewController = context.viewController(forKey: .to)
        else {
            cancelAnimation(context: context)
            return
        }
        
        let sourceViewController = topViewController(fromViewController)
        let destinationViewController = topViewController(toViewController)
        
        guard
            let sourceData = sourceViewController as? ANZSingleImageViewerSourceTransitionDelegate,
            let destinationData = destinationViewController as? ANZSingleImageViewerDestinationTransitionDelegate,
            let sourceImageView = sourceData.viewerTargetImageView(),
            let sourceImage = sourceImageView.image
        else {
            cancelAnimation(context: context)
            return
        }
        
        let containerView = context.containerView
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        let destinationImageView = destinationData.viewerTargetImageView(targetImage: sourceImage)
        
        let bgView = UIView(frame: containerView.frame)
        bgView.backgroundColor = destinationData.viewerBackgroundColor()
        bgView.alpha = 0.0
        containerView.addSubview(bgView)
        
        let transitionImageView = UIImageView(image: sourceImage)
        transitionImageView.frame = sourceImageView.convert(sourceImageView.bounds, to: fromViewController.view)
        transitionImageView.contentMode = sourceImageView.contentMode
        containerView.addSubview(transitionImageView)
        
        sourceImageView.isHidden = true
        destinationViewController.view.isHidden = true
        
        UIView.animate(withDuration: type(of: self).transitionDuration, delay: .leastNormalMagnitude, options: [.curveEaseOut], animations: {
            
            bgView.alpha = 1.0
            transitionImageView.contentMode = destinationImageView.contentMode
            transitionImageView.frame = destinationImageView.convert(
                destinationImageView.bounds,
                to: toViewController.view
            )
            
        }) { (isFinished) in
            
            destinationViewController.view.isHidden = false
            transitionImageView.removeFromSuperview()
            bgView.removeFromSuperview()
            sourceImageView.isHidden = false
            
            self.finAnimation(context: context)
        }
    }
    
    private func animateBack(context: UIViewControllerContextTransitioning) {
        
        guard
            let fromViewController = context.viewController(forKey: .from),
            let toViewController = context.viewController(forKey: .to)
        else {
            cancelAnimation(context: context)
            return
        }
        
        let sourceViewController = topViewController(toViewController)
        let destinationViewController = topViewController(fromViewController)
        
        guard
            let sourceData = sourceViewController as? ANZSingleImageViewerSourceTransitionDelegate,
            let destinationData = destinationViewController as? ANZSingleImageViewerDestinationTransitionDelegate,
            let sourceImageView = sourceData.viewerTargetImageView()
        else {
            cancelAnimation(context: context)
            return
        }
        
        let containerView = context.containerView
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        let destinationImageView = destinationData.viewerTargetImageView(targetImage: nil)

        let transitionImageView = UIImageView(image: destinationImageView.image)
        transitionImageView.frame = destinationImageView.convert(destinationImageView.bounds, to: fromViewController.view)
        transitionImageView.contentMode = destinationImageView.contentMode
        transitionImageView.clipsToBounds = true
        containerView.addSubview(transitionImageView)

        destinationImageView.isHidden = true
        destinationViewController.view.alpha = 1.0
        sourceImageView.isHidden = true

        UIView.animate(withDuration: type(of: self).transitionDuration, delay: .leastNormalMagnitude, options: [.curveEaseIn], animations: {
            
            transitionImageView.contentMode = sourceImageView.contentMode
            transitionImageView.frame = sourceImageView.convert(
                sourceImageView.bounds,
                to: toViewController.view
            )
            destinationViewController.view.alpha = 0.0

        }) { (isFinished) in

            sourceImageView.isHidden = false
            transitionImageView.removeFromSuperview()

            self.finAnimation(context: context)
        }
    }
    
    private func cancelAnimation(context: UIViewControllerContextTransitioning) {
        
        context.cancelInteractiveTransition()
        context.completeTransition(false)
    }
    
    private func finAnimation(context: UIViewControllerContextTransitioning) {
        
        let completed: Bool
        if #available(iOS 10.0, *) {
            completed = true
        } else {
            completed = !context.transitionWasCancelled
        }
        context.completeTransition(completed)
    }
}

// MARK: - Util
extension ANZSingleImageViewer.AnimatedTransitioning {
    
    private func topViewController(_ viewController: UIViewController) -> UIViewController {
        
        if let navigationController = viewController as? UINavigationController {
            return topViewController(navigationController.children.last!)
        } else if let tabbarController = viewController as? UITabBarController {
            return topViewController(tabbarController.selectedViewController!)
        } else {
            return viewController
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ANZSingleImageViewer.AnimatedTransitioning: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isForward = true
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isForward = false
        return self
    }
}

// MARK: UIViewControllerAnimatedTransitioning
extension ANZSingleImageViewer.AnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return type(of: self).transitionDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if isForward {
            animateForward(context: transitionContext)
        } else {
            animateBack(context: transitionContext)
        }
    }
}


// MARK: - 推奨: 別ファイル


