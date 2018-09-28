//
//  SimpleCustomTransitionViewController.swift
//  ANZSingleImageViewer_Example
//
//  Created by sasato on 2018/09/28.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation

import ANZSingleImageViewer

class SimpleCustomTransitionViewController: SimpleViewController {
    
}

extension SimpleCustomTransitionViewController: ANZSingleImageViewerSourceTransitionDelegate {
    
    func viewerTargetImageView() -> UIImageView? {
        
        return selectedImageView
    }
}
