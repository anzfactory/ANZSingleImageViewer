//
//  SimpleViewController.swift
//  ANZSingleImageViewer_Example
//
//  Created by sasato on 2018/09/27.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

import ANZSingleImageViewer

class SimpleViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "unsplash_1073353"))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 50, y: 50, width: 200, height: 150)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let imageView2: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "unsplash_1072059"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 200, y: 400, width: 200, height: 150)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var selectedImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "SingleImageViewer"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(type(of: self).didTapClose))
        
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(type(of: self).didTapImageView(gesture:)))
        imageView.addGestureRecognizer(tapGesture)
        view.addSubview(imageView)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(type(of: self).didTapImageView(gesture:)))
        imageView2.addGestureRecognizer(tapGesture2)
        view.addSubview(imageView2)
    }
}

@objc
extension SimpleViewController {
    
    private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    private func didTapImageView(gesture: UITapGestureRecognizer) {
        
        guard let selectedImageView = gesture.view as? UIImageView else {
            return
        }
        openImageViewer(targetImageView: selectedImageView)
    }
}

extension SimpleViewController {
    
    private func openImageViewer(targetImageView imageView: UIImageView) {
        
        guard let image = imageView.image else {
            return
        }
        selectedImageView = imageView
        ANZSingleImageViewer.showImage(image, toParent: self)
    }
}
