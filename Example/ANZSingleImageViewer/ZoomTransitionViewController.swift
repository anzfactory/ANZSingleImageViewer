//
//  ZoomTransitionViewController.swift
//  ANZSingleImageViewer_Example
//
//  Created by sasato on 2018/09/28.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

import ANZSingleImageViewer

class ZoomTransitionViewController: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items.shuffle()
    }
}

extension ZoomTransitionViewController: ANZSingleImageViewerSourceTransitionDelegate {
    
    func viewerTargetImageView() -> UIImageView? {
        
        return targetImageView
    }
}
