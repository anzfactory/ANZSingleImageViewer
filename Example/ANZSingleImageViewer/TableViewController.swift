//
//  TableViewController.swift
//  ANZSingleImageViewer_Example
//
//  Created by sasato on 2018/09/28.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

import ANZSingleImageViewer

class TableViewController: UITableViewController {
    
    private let photos: [UIImage] = [
        #imageLiteral(resourceName: "unsplash_1074559"),
        #imageLiteral(resourceName: "unsplash_1073353"),
        #imageLiteral(resourceName: "unsplash_1074138"),
        #imageLiteral(resourceName: "unsplash_1072059")
    ]
    
    var selectedImageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "SingleImageViewer"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(type(of: self).didTapClose))
        
        clearsSelectionOnViewWillAppear = false
        tableView.rowHeight = 200
        tableView.estimatedRowHeight = 0
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "CELL")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! TableViewCell

        cell.delegate = self
        cell.configure(image: photos[indexPath.row])

        return cell
    }
}

@objc
extension TableViewController {
    
    private func didTapClose() {
        
        dismiss(animated: true, completion: nil)
    }
}

extension TableViewController {
    
    private func openImageViewer(imageView: UIImageView) {
        
        guard let image = imageView.image else {
            return
        }
        
        ANZSingleImageViewer.showImage(image, toParent: self)
    }
}

extension TableViewController: TableViewCellDelegate {
    
    func cellTappedImageView(_ imageView: UIImageView) {
        selectedImageView = imageView
        openImageViewer(imageView: imageView)
    }
}

class TableViewCell: UITableViewCell {
    
    weak var delegate: TableViewCellDelegate?
    
    private let filledImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(type(of: self).didTapImageView(gesture:)))
        filledImageView.addGestureRecognizer(tapGesture)
        contentView.addSubview(filledImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        filledImageView.frame = CGRect(
            origin: .zero,
            size: contentView.bounds.size
        )
    }
}

extension TableViewCell {
    
    func configure(image: UIImage) {
        
        filledImageView.image = image
    }
}

@objc
extension TableViewCell {
    
    private func didTapImageView(gesture: UIGestureRecognizer) {
        
        delegate?.cellTappedImageView(filledImageView)
    }
}

protocol TableViewCellDelegate: NSObjectProtocol {
    
    func cellTappedImageView(_ imageView: UIImageView)
}
