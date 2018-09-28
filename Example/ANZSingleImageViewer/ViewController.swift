//
//  ViewController.swift
//  ANZSingleImageViewer
//
//  Created by anzfactory on 09/27/2018.
//  Copyright (c) 2018 anzfactory. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapButton1(_ sender: Any) {
        
        let root = SimpleViewController()
        let navVC = UINavigationController(rootViewController: root)
        present(navVC, animated: true, completion: nil)
    }
    
    @IBAction func didTapButton2(_ sender: Any) {
        
        let root = SimpleCustomTransitionViewController()
        let navVC = UINavigationController(rootViewController: root)
        present(navVC, animated: true, completion: nil)
    }
    
    @IBAction func didTapButton3(_ sender: Any) {
        
        let root = TableViewController()
        let navVC = UINavigationController(rootViewController: root)
        present(navVC, animated: true, completion: nil)
    }
    
    @IBAction func didTapButton4(_ sender: Any) {
        
        let root = TableCustomTransitionViewController()
        let navVC = UINavigationController(rootViewController: root)
        present(navVC, animated: true, completion: nil)
    }
}
