//
//  ViewController.swift
//  ANZSingleImageViewer_Example
//
//  Created by sasato on 2018/09/28.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

import ANZSingleImageViewer

typealias ItemData = (image: UIImage, photographer: String)

class ViewController: UIViewController {
    
    private var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.estimatedRowHeight = 0
        view.rowHeight = 100
        view.register(CoverCell.self, forCellReuseIdentifier: "COVER")
        view.register(ThumbCell.self, forCellReuseIdentifier: "THUMB")
        return view
    }()
    
    var items: [ItemData] = [
        (image: #imageLiteral(resourceName: "unsplash_1072059"), photographer: "Toshi"),
        (image: #imageLiteral(resourceName: "unsplash_1074559"), photographer: "Kelly Sikkema"),
        (image: #imageLiteral(resourceName: "unsplash_1074138"), photographer: "Rich Hay"),
        (image: #imageLiteral(resourceName: "unsplash_1073353"), photographer: "Vidar Nordli-Mathisen")
    ]
    
    var targetImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
}

extension ViewController {
    
    private func setup() {
        
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.row]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "COVER", for: indexPath) as! CoverCell
            cell.delegate = self
            cell.configure(data: item)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "THUMB", for: indexPath) as! ThumbCell
            cell.delegate = self
            cell.configure(data: item)
            return cell
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return tableView.bounds.width
        } else {
            return tableView.rowHeight
        }
    }
}

extension ViewController: CellDelegate {
    
    func cellDidTapImageView(_ imageView: UIImageView) {
        
        guard let image = imageView.image else {
            return
        }
        
        targetImageView = imageView
        ANZSingleImageViewer.showImage(image, toParent: self)
    }
}

class CoverCell: UITableViewCell {
    
    weak var delegate: CellDelegate?
    
    private let coverImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let photograperLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 12.0)
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(type(of: self).didTapImageView(gesture:)))
        coverImageView.addGestureRecognizer(tapGesture)
        contentView.addSubview(coverImageView)
        contentView.addSubview(photograperLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        coverImageView.frame = contentView.bounds
        photograperLabel.frame = CGRect(
            x: 8.0,
            y: contentView.bounds.height - 28.0,
            width: contentView.bounds.width - 16.0,
            height: 20.0
        )
    }
    
    func configure(data: ItemData) {
        
        coverImageView.image = data.image
        photograperLabel.text = "photo By " + data.photographer
    }
    
    @objc private func didTapImageView(gesture: UIGestureRecognizer) {
        
        delegate?.cellDidTapImageView(coverImageView)
    }
}

class ThumbCell: UITableViewCell {
    
    weak var delegate: CellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        imageView?.clipsToBounds = true
        imageView?.contentMode = .scaleAspectFit
        imageView?.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(type(of: self).didTapImageView(gesture:)))
        imageView?.addGestureRecognizer(tapGesture)
        
        textLabel?.textColor = .black
        textLabel?.numberOfLines = 2
        textLabel?.font = .systemFont(ofSize: 12.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: ItemData) {
        
        imageView?.image = data.image
        textLabel?.text = "photo By " + data.photographer
    }
    
    @objc private func didTapImageView(gesture: UIGestureRecognizer) {
        
        delegate?.cellDidTapImageView(imageView!)
    }
}

protocol CellDelegate: NSObjectProtocol {
    
    func cellDidTapImageView(_ imageView: UIImageView)
}
