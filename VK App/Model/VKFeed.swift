//
//  VKFeed.swift
//  VK App
//
//  Created by Lev Bazhkov on 08.05.2021.
//

import UIKit
import DynamicJSON

class VKFeed {
    
    var text, textFromRepost: String?
    var likesCount, isLiked: String?
    var commentsCount, repostsCount, viewsCount: String?
    var postId, sourceId, id, date: String?
    var image, imageFromLink, imageFromRepost, imageFromLinkRepost, imageFromAd, imageFromVideo: String?
    var type: String?
    var isAd: String?
    var heightImage, heightImageFromLink, heightImageFromLinkRepost, heightImageFromRepost, heightImageFromAd, heightImageFromVideo: String?
    
    var textHeight: CGFloat = 0
    var imageHight: CGFloat = 0
    
    var isExpandent: Bool = false
    
    convenience required init(data: JSON) {
        self.init()
        self.text = data.text.string
        self.textFromRepost = data.copy_history[0].text.string
        self.likesCount = data.likes.count.string
        self.isLiked = data.likes.user_likes.string
        self.commentsCount = data.comments.count.string
        self.repostsCount = data.reposts.count.string
        self.viewsCount = data.views.count.string
        self.postId = data.attachments.post_id.string
        self.sourceId = data.source_id.string
        self.id = data.attachments.id.string
        self.date = data.date.string
        self.type = data.attachments[0].type.string
        self.isAd = data.marked_as_ads.string
        self.image = data.attachments[0].photo.sizes[4].url.string
        self.imageFromLink = data.attachments[0].link.photo.sizes[0].url.string
        self.imageFromLinkRepost = data.copy_history[0].attachments[0].link.photo.sizes[0].url.string
        self.imageFromRepost = data.copy_history[0].attachments[0].photo.sizes[3].url.string
        self.imageFromAd = data.attachments[0].doc.preview.photo.sizes[3].src.string
        self.imageFromVideo = data.attachments[0].video.image[3].url.string
        self.heightImage = data.attachments[0].photo.sizes[4].height.string
        self.heightImageFromLink = data.attachments[0].link.photo.sizes[1].height.string
        self.heightImageFromLinkRepost = data.copy_history[0].attachments[0].link.photo.sizes[1].height.string
        self.heightImageFromRepost = data.copy_history[0].attachments[0].photo.sizes[1].height.string
        self.heightImageFromAd = data.attachments[0].doc.preview.photo.sizes[5].height.string
        self.heightImageFromVideo = data.attachments[0].video.image[1].height.string
    }
    
    func calculateTextHeight(width: CGFloat, font: UIFont = .systemFont(ofSize: 15)) {
        let rect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let size = text!.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        textHeight = size.height
    }
    
    func calculateImageHeight(width: CGFloat) {
        let n = NumberFormatter().number(from: ((self.heightImage ?? self.heightImageFromLink ?? self.heightImageFromLinkRepost ?? self.heightImageFromRepost ?? self.heightImageFromAd ?? self.heightImageFromVideo) ?? ""))
        imageHight = CGFloat(truncating: n ?? 0)
    }
}

class VKFeedGroup {
    
    var groupId: String?
    var groupImage: String?
    var groupName: String?
    
    convenience required init(data: JSON) {
        self.init()
        self.groupId = data.id.string
        self.groupImage = data.photo_200.string
        self.groupName = data.name.string
    }
}
