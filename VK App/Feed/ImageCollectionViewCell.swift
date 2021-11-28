//
//  ImageCollectionViewCell.swift
//  VK App
//
//  Created by Lev Bazhkov on 02.08.2021.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
 
    static let reuseIdentifier = "ImageCollectionViewCell"
    
    var imageHeight: CGFloat = 0
    var imageWidth: CGFloat = 0
    
    var newsImage: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(newsImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setImage(news: VKFeed) {
        newsImage.sd_setImage(with: URL(string: news.image ?? ""), placeholderImage: UIImage())
        newsImage.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: news.imageHight)
    }
    func setImageFromAd(news: VKFeed) {
        newsImage.sd_setImage(with: URL(string: news.imageFromAd ?? ""), placeholderImage: UIImage())
        newsImage.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: news.imageHight)
    }
    func setImageFromLink(news: VKFeed) {
        newsImage.sd_setImage(with: URL(string: news.imageFromLink ?? ""), placeholderImage: UIImage())
        newsImage.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: news.imageHight)
    }
    func setImageFromVideo(news: VKFeed) {
        newsImage.sd_setImage(with: URL(string: news.imageFromVideo ?? ""), placeholderImage: UIImage())
        newsImage.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: news.imageHight)
    }
    func setImageFromRepost(news: VKFeed) {
        newsImage.sd_setImage(with: URL(string: news.imageFromRepost ?? ""), placeholderImage: UIImage())
        newsImage.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: news.imageHight)
    }
    func setImageFromLinkRepost(news: VKFeed) {
        newsImage.sd_setImage(with: URL(string: news.imageFromLinkRepost ?? ""), placeholderImage: UIImage())
        newsImage.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: news.imageHight)
    }
}
