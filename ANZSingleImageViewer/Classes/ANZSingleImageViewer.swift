//
//  ANZSingleImageViewer.swift
//  Xcode10Project
//
//  Created by sasato on 2018/09/26.
//  Copyright © 2018年 sasato. All rights reserved.
//

import AVFoundation
import UIKit

public final class ANZSingleImageViewer: UIViewController {
    
    private static let backgroundColor: UIColor = .black
    private static let minZoomLevel: Int = 1
    private static let maxZoomLevel: Int = 4
    private static let padding: UIEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    
    var image: UIImage? {
        
        didSet {
            
            updateImage(image)
        }
    }
    
    var animator: AnimatedTransitioning?
    
    private static let bundle = Bundle(path: Bundle(for: ANZSingleImageViewer.self).path(forResource: "ANZSingleImageViewer", ofType: "bundle")!)
    
    private let bg: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0))
        view.image = UIImage(named: "bg_close", in: bundle, compatibleWith: nil)
        return view
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        button.setImage(UIImage(named: "icon_close", in: bundle, compatibleWith: nil), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        button.tintColor = .white
        button.clipsToBounds = true
        return button
    }()
    
    private let imageView: UIImageView = {
        
        let view = UIImageView(frame: .zero)
        return view
    }()
    
    private let scrollView: UIScrollView = {
        
        let view = UIScrollView(frame: .zero)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.minimumZoomScale = CGFloat(ANZSingleImageViewer.minZoomLevel)
        view.maximumZoomScale = CGFloat(ANZSingleImageViewer.maxZoomLevel)
        view.contentInset = .zero
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let image = self.image else {
            return
        }
        
        scrollView.frame = view.frame
        
        adjustContentSize(image: image, inBoundsSize: scrollView.bounds.size)
        fixButtonPosition()
    }
}

// MARK: - Public
extension ANZSingleImageViewer {
    
    @discardableResult
    public static func showImage(_ image: UIImage, toParent vc: UIViewController) -> ANZSingleImageViewer {
        
        let viewer = ANZSingleImageViewer()
        viewer.image = image
        
        if vc is ANZSingleImageViewerSourceTransitionDelegate {
            let animator = AnimatedTransitioning()
            viewer.animator = animator
        }
        
        vc.present(viewer, animated: true, completion: nil)
        
        return viewer
    }
}

// MARK: - Private
extension ANZSingleImageViewer {
    
    private func adjustContentSize(image: UIImage, inBoundsSize size: CGSize) {
        
        imageView.bounds.size = calcAspectFitSize(
            contentSize: image.size,
            inBoundsSize: size
        )
        scrollView.contentSize = imageView.bounds.size
        imageView.center = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
    }
    
    private func calcAspectFitSize(contentSize size: CGSize, inBoundsSize boundsSize: CGSize) -> CGSize {
        
        return AVMakeRect(aspectRatio: size, insideRect: CGRect(origin: .zero, size: boundsSize)).size
    }
    
    private func centerContent(contentSize: CGSize, boundsSize: CGSize) {
        
        let offsetX = max((boundsSize.width - contentSize.width) * 0.5, 0.0)
        let offsetY = max((boundsSize.height - contentSize.height) * 0.5, 0.0)
        
        imageView.center = CGPoint(
            x: contentSize.width * 0.5 + offsetX,
            y: contentSize.height * 0.5 + offsetY
        )
    }
    
    private func dismiss() {
        
        let minScale = CGFloat(type(of: self).minZoomLevel)
        
        if animator != nil && scrollView.zoomScale > minScale {
            
            UIView.animate(withDuration: 0.1, animations: {
                self.scrollView.zoomScale = minScale
            }) { _ in
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func fixButtonPosition() {
        
        var padding = type(of: self).padding
        
        if #available(iOS 11.0, *) {
            padding = UIEdgeInsets(
                top: padding.top + view.safeAreaInsets.top,
                left: padding.left + view.safeAreaInsets.left,
                bottom: padding.bottom + view.safeAreaInsets.bottom,
                right: padding.right + view.safeAreaInsets.right
            )
        }
        
        button.frame.origin = CGPoint(
            x: view.bounds.width - button.frame.width - padding.right,
            y: padding.top
        )
        
        bg.center = button.center
    }
    
    private func setup() {
        
        if let animator = self.animator {
            transitioningDelegate = animator
        } else {
            modalTransitionStyle = .crossDissolve
            modalPresentationStyle = .overFullScreen
        }
        
        modalPresentationCapturesStatusBarAppearance = true
        
        view.backgroundColor = type(of: self).backgroundColor
        view.addSubview(scrollView)
        view.addSubview(bg)
        view.addSubview(button)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(type(of: self).didDoubleTapView(gesture:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        
        button.addTarget(self, action: #selector(type(of: self).didTapButton(_:)), for: .touchUpInside)
    }
    
    private func updateImage(_ image: UIImage?) {
        
        imageView.image = image
    }
    
    private func updateZoomScale() {
        
        let currentScale = Int(scrollView.zoomScale)
        for level in type(of: self).minZoomLevel ..< type(of: self).maxZoomLevel where currentScale == level {
            scrollView.setZoomScale(CGFloat(level + 1), animated: true)
            return
        }
        
        scrollView.setZoomScale(CGFloat(type(of: self).minZoomLevel), animated: true)
    }
}

// MARK: - Selector
@objc
extension ANZSingleImageViewer {
    
    private func didDoubleTapView(gesture: UITapGestureRecognizer) {
        
        updateZoomScale()
    }
    
    private func didTapButton(_ button: UIButton) {
        
        dismiss()
    }
}

// MARK: - UIScrollViewDelegate
extension ANZSingleImageViewer: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        centerContent(contentSize: scrollView.contentSize, boundsSize: scrollView.bounds.size)
    }
}

// MARK: - ANZSingleImageViewerDestinationTransitionDelegate
extension ANZSingleImageViewer: ANZSingleImageViewerDestinationTransitionDelegate {
    
    public func viewerBackgroundColor() -> UIColor {
        
        return type(of: self).backgroundColor
    }
    
    public func viewerTargetImageView(targetImage image: UIImage?) -> UIImageView {
        
        if let image = image {
            adjustContentSize(image: image, inBoundsSize: view.bounds.size)
        }
        
        return imageView
    }
}
