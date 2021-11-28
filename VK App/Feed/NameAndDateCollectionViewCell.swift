//
//  NameAndDateCollectionViewCell.swift
//  VK App
//
//  Created by Lev Bazhkov on 02.08.2021.
//

import UIKit

final class NameAndDateCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "NameAndDateCollectionViewCell"
    
    var groupImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .systemBackground
        return image
    }()
    
    var groupName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.backgroundColor = .systemBackground
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(12)
        label.backgroundColor = .systemBackground
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        groupImage.layer.borderWidth = 2
        groupImage.layer.borderColor = UIColor.darkGrayCGColor
        contentView.addSubview(groupImage)
        contentView.addSubview(groupName)
        contentView.addSubview(dateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setFrameForSourceOfNews()
    }
    
    func setupCell(image: UIImage, name: String, date: String) {
        groupName.text = name
        groupImage.image = image
        dateLabel.text = date
    }
    
    func setFrameForSourceOfNews() {
        groupImage.frame = CGRect(x: 0,
                                  y: 0,
                                  width: 50,
                                  height: 50)
        groupImage.layer.cornerRadius = groupImage.frame.size.width/2
        groupImage.clipsToBounds = true
        groupName.frame = CGRect(x: floor(groupImage.frame.maxX + 5),
                                 y: 0,
                                 width: ceil(contentView.frame.width - groupImage.frame.width - dateLabel.frame.width),
                                 height: 50)
        dateLabel.frame = CGRect(x: floor(contentView.frame.maxX - 110),
                                 y: floor(2),
                                 width: 110,
                                 height: 50)
    }
}
