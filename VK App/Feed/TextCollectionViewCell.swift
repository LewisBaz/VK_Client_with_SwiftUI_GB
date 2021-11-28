//
//  TextCollectionViewCell.swift
//  VK App
//
//  Created by Lev Bazhkov on 02.08.2021.
//

import UIKit

class TextCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TextCollectionViewCell"
    
    var textWidth: CGFloat = 0
    let maxTextCount = 200
    let maxTextHeigth: CGFloat = 500
    
    var newsText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var newsTextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Больше", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(newsText)
        contentView.addSubview(newsTextButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func resizeText(news: VKFeed) {
        
        if newsText.text?.count ?? 0 < maxTextCount {
            newsText.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: news.textHeight + 20)
        } else {
            switch news.isExpandent {
            case true:
                newsText.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: news.textHeight + 40)
                newsTextButton.frame = CGRect(x: floor(contentView.frame.maxX) - 50, y: floor(contentView.frame.maxY - 30), width: 50, height: 30)
            case false:
                newsText.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: 100)
                newsTextButton.frame = CGRect(x: floor(contentView.frame.maxX) - 50, y: floor(contentView.frame.maxY - 30), width: 50, height: 30)
            }
        }
}
    
    func setText(news: VKFeed) {
        newsText.text = news.text
        newsText.lineBreakMode = .byWordWrapping
        newsText.numberOfLines = 0
        newsText.sizeToFit()
        newsText.backgroundColor = .systemBackground
        resizeText(news: news)
    }
}
