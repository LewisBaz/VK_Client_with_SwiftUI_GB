//
//  ControlsCollectionViewCell.swift
//  VK App
//
//  Created by Lev Bazhkov on 02.08.2021.
//

import UIKit

final class ControlsCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ControlsCollectionViewCell"
    
    var likeControl: HeartButtonControl = {
        let control = HeartButtonControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.backgroundColor = .systemBackground
        return control
    }()
    var commentsControl: CommentControl = {
        let control = CommentControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.backgroundColor = .systemBackground
        return control
    }()
    var shareControl: ShareControl = {
        let control = ShareControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.backgroundColor = .systemBackground
        return control
    }()
    var viewsCountControl: ViewsCountView = {
        let control = ViewsCountView()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.backgroundColor = .systemBackground
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(likeControl)
        contentView.addSubview(commentsControl)
        contentView.addSubview(shareControl)
        contentView.addSubview(viewsCountControl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setFrameForControlsView()
    }

    func setFrameForControlsView() {
        likeControl.frame = CGRect(x: 0,
                                   y: 0,
                                   width: 70,
                                   height: 30)
        commentsControl.frame = CGRect(x: floor(likeControl.frame.maxX),
                                       y: 0,
                                       width: 70,
                                       height: 30)
        shareControl.frame = CGRect(x: floor(commentsControl.frame.maxX),
                                    y: 0,
                                    width: 70,
                                    height: 30)
        viewsCountControl.frame = CGRect(x: floor(contentView.frame.width - 70),
                                         y: 0,
                                         width: 70,
                                         height: 30)
    }
}

final class EmptyCell: UICollectionViewCell {
    static let reuseIdentifier = "EmptyCell"
}
