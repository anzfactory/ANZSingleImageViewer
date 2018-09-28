//
//  TableCustomTransitionViewController.swift
//  ANZSingleImageViewer_Example
//
//  Created by sasato on 2018/09/28.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation

import ANZSingleImageViewer

class TableCustomTransitionViewController: TableViewController {
    
}

extension TableCustomTransitionViewController: ANZSingleImageViewerSourceTransitionDelegate {
    
    func viewerTargetImageView() -> UIImageView? {
        
        return selectedImageView
    }
}

