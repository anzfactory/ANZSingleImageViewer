//
//  ANZSingleImageViewerDestinationTransitionDelegate.swift
//  ANZSingleImageViewer
//
//  Created by sasato on 2018/09/28.
//

import Foundation

protocol ANZSingleImageViewerDestinationTransitionDelegate {
    
    func viewerBackgroundColor() -> UIColor
    func viewerTargetImageView(targetImage image: UIImage?) -> UIImageView
}
