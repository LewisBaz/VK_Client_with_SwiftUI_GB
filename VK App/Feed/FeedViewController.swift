//
//  FeedViewController.swift
//  VK App
//
//  Created by Lev Bazhkov on 15.08.2021.
//

import UIKit

final class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var feedCollectionView: UICollectionView?
    private var news = [VKFeed]()
    private var groups = [VKFeedGroup]()
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy 'в' HH:mm"
        return df
    }()
    private var refreshControl: UIRefreshControl = UIRefreshControl()
    private var nextFrom = ""
    private var isLoading = false
    private var serviceProxy = ServiceProxy(networkService: NetworkService())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = view.frame.width
        
        let group = DispatchGroup()

                  group.enter()
                        serviceProxy.getFeedNewsAndGroups { [weak self] news, groups, nextFrom in
                        guard let self = self else { return }
                        self.news = news
                        self.nextFrom = nextFrom
                        self.groups = groups
                        self.reloadNews(news: news, width: width)
                        self.feedCollectionView!.reloadData()
                        group.leave()
                    }

                group.notify(queue: .main) { [weak self] in
                    guard let self = self else { return }
                    self.feedCollectionView!.reloadData()
                }
        
        let view = UIView()
        view.backgroundColor = .systemBackground
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumLineSpacing = 5
        feedCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        feedCollectionView?.register(NameAndDateCollectionViewCell.self, forCellWithReuseIdentifier: NameAndDateCollectionViewCell.reuseIdentifier)
        feedCollectionView?.register(TextCollectionViewCell.self, forCellWithReuseIdentifier: TextCollectionViewCell.reuseIdentifier)
        feedCollectionView?.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        feedCollectionView?.register(ControlsCollectionViewCell.self, forCellWithReuseIdentifier: ControlsCollectionViewCell.reuseIdentifier)
        feedCollectionView?.register(EmptyCell.self, forCellWithReuseIdentifier: EmptyCell.reuseIdentifier)

        feedCollectionView?.backgroundColor = .systemBackground
                
        feedCollectionView?.dataSource = self
        feedCollectionView?.delegate = self
        feedCollectionView?.prefetchDataSource = self
        feedCollectionView?.reloadData()
        
        view.addSubview(feedCollectionView!)
        setupRefreshControl()
        self.view = view
    }

    func reloadNews(news: [VKFeed], width: CGFloat) {
        DispatchQueue.global().async {
            news.forEach({ $0.calculateTextHeight(width: width) })
            news.forEach({ $0.calculateImageHeight(width: width) })
            DispatchQueue.main.async {
                self.news = news
            }
        }
    }
    func reloadNewsGroups(news: [VKFeed], groups: [VKFeedGroup], width: CGFloat) {
        DispatchQueue.global().async {
            news.forEach({ $0.calculateTextHeight(width: width) })
            news.forEach({ $0.calculateImageHeight(width: width) })
            DispatchQueue.main.async {
                self.news = news
                self.groups = groups
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier:EmptyCell.reuseIdentifier, for: indexPath) as! EmptyCell
        let nameAndDateCell = collectionView.dequeueReusableCell(withReuseIdentifier: NameAndDateCollectionViewCell.reuseIdentifier, for: indexPath) as! NameAndDateCollectionViewCell
        let textCell = collectionView.dequeueReusableCell(withReuseIdentifier:TextCollectionViewCell.reuseIdentifier, for: indexPath) as! TextCollectionViewCell
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier:ImageCollectionViewCell.reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        let controlsCell = collectionView.dequeueReusableCell(withReuseIdentifier:ControlsCollectionViewCell.reuseIdentifier, for:indexPath) as! ControlsCollectionViewCell
        
        switch indexPath.item {
        case 0:
            var index = 0
            func setGroupName() {
                guard let groupName = self.groups[index].groupName else { return }
                guard let groupImage = self.groups[index].groupImage else { return }
                guard let date = self.news[indexPath.section].date else { return }
                nameAndDateCell.groupName.text = "\(groupName)"
                nameAndDateCell.groupImage.sd_setImage(with: URL(string: groupImage), placeholderImage: UIImage())
                let dateToShow = Date(timeIntervalSince1970: Double(date)!)
                let dateString = self.dateFormatter.string(from: dateToShow)
                nameAndDateCell.dateLabel.text = dateString
            }
            for _ in self.groups {
                if self.news[indexPath.section].sourceId == "-" + self.groups[index].groupId! {
                    setGroupName()
                } else {
                    index += 1
                    setGroupName()
                }
            }
            return nameAndDateCell
        case 1:
            if news[indexPath.section].text != "" {
                textCell.setText(news: news[indexPath.section])
                textCell.newsTextButton.tag = indexPath.section
                textCell.newsTextButton.addTarget(self, action: #selector(expand), for: .touchUpInside)
                return textCell
            } else {
                return emptyCell
            }
            case 2:
                let image = self.news[indexPath.section].image
                let imageFromLink = self.news[indexPath.section].imageFromLink
                let imageFromRepost = self.news[indexPath.section].imageFromRepost
                let imageFromLinkRepost = self.news[indexPath.section].imageFromLinkRepost
                let imageFromAd = self.news[indexPath.section].imageFromAd
                let imageFromVideo = self.news[indexPath.section].imageFromVideo
                
                if image == nil && imageFromLink == nil && imageFromRepost == nil && imageFromLinkRepost == nil && imageFromAd == nil && imageFromVideo == nil {
                    return emptyCell
                } else {
                    if image != nil {
                        imageCell.setImage(news: news[indexPath.section])
                    } else if imageFromRepost != nil {
                        imageCell.setImageFromRepost(news: news[indexPath.section])
                    } else if imageFromLink != nil {
                        imageCell.setImageFromLink(news: news[indexPath.section])
                    } else if imageFromLinkRepost != nil {
                        imageCell.setImageFromLinkRepost(news: news[indexPath.section])
                    } else if imageFromAd != nil {
                        imageCell.setImageFromAd(news: news[indexPath.section])
                    } else if imageFromVideo != nil {
                        imageCell.setImageFromVideo(news: news[indexPath.section])
                    }
                    return imageCell
                }
            case 3:
                if news[indexPath.section].isLiked == "true" {
                    controlsCell.likeControl.isLiked = true
                } else {
                    controlsCell.likeControl.isLiked = false
                }

                controlsCell.likeControl.likeCount = Int(news[indexPath.section].likesCount ?? "0") ?? 0
                controlsCell.commentsControl.commentsCount = Int(news[indexPath.section].commentsCount ?? "0") ?? 0
                controlsCell.shareControl.sharesCount = Int(news[indexPath.section].repostsCount ?? "0") ?? 0
                controlsCell.viewsCountControl.viewsCount = Int(news[indexPath.section].viewsCount ?? "0") ?? 0

                return controlsCell
        default:
            return UICollectionViewCell()
        }
    }
    
    var indexOfExpendedCell: Int = 0
    @objc func expand(sender: TextCollectionViewCell) {
        indexOfExpendedCell = sender.tag
        self.news[indexOfExpendedCell].isExpandent = !self.news[indexOfExpendedCell].isExpandent
        
        if !self.news[indexOfExpendedCell].isExpandent {
            //sender.newsTextButton.setTitle("Больше", for: .normal)
            self.feedCollectionView?.reloadData()
        } else {
            //sender.newsTextButton.setTitle("Меньше", for: .normal)
            self.feedCollectionView?.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let insets: CGFloat = 10
        let newsText = news[indexPath.section].text
        let newsTextHeight = news[indexPath.section].textHeight
        let textSize: CGSize
        let cell = TextCollectionViewCell()
        
        if newsText?.count == 0 {
            textSize = CGSize(width: 0, height: 0)
        } else if newsText!.count < cell.maxTextCount {
            textSize = CGSize(width: (feedCollectionView?.frame.width)! - insets, height: newsTextHeight + 20)
        } else if newsText!.count > cell.maxTextCount && news[indexPath.section].isExpandent && indexPath.section == indexOfExpendedCell {
            textSize = CGSize(width: (feedCollectionView?.frame.width)! - insets, height: newsTextHeight + 40)
        } else {
            textSize = CGSize(width: (feedCollectionView?.frame.width)! - insets, height: 100)
        }
        
        let newsImageHeight = news[indexPath.section].imageHight
        let imageSize: CGSize
        imageSize = CGSize(width: (feedCollectionView?.frame.width)! - insets, height: newsImageHeight)

        if indexPath.item == 0 {
            return CGSize(width: (feedCollectionView?.frame.width)! - insets, height: 50)
        } else if indexPath.item == 1 {
            return textSize
        } else if indexPath.item == 2 {
            return imageSize
        } else if indexPath.item == 3 {
            return CGSize(width: (feedCollectionView?.frame.width)! - insets, height: 30)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    fileprivate func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление списка...")
        refreshControl.tintColor = .red
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        self.feedCollectionView?.addSubview(refreshControl)
        self.feedCollectionView?.refreshControl = refreshControl
       }

    @objc func refreshNews() {
        self.refreshControl.beginRefreshing()
        let mostFreshNewsDate = self.news.first?.date ?? String(Date().timeIntervalSince1970)
        serviceProxy.getFeedNewsAndGroupsWithDate(startTime: Int(mostFreshNewsDate)! + 1, completion: { [weak self] news, groups in
            guard let self = self else { return }
            let width = self.view.frame.width
            guard news.count > 0 else { return }
            guard groups.count > 0 else { return }
            self.news = news + self.news
            self.groups = groups + self.groups
            self.news.removeLast(news.count)
            self.reloadNews(news: self.news, width: width)
            let indexPath = IndexPath(item: 0, section: 0)
            self.feedCollectionView?.insertItems(at: [indexPath])
            self.feedCollectionView!.reloadData()
        })
        self.refreshControl.endRefreshing()
    }
}

extension FeedViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
       guard let maxSection = indexPaths.map({ $0.section }).max() else { return }
       if maxSection > news.count - 3,
           !isLoading {
           isLoading = true
           serviceProxy.newsRequest(startFrom: nextFrom) { [weak self] (news, groups, nextFrom) in
               guard let self = self else { return }
               let width = self.view.frame.width
               let indexSet = IndexSet(integersIn: self.news.count ..< self.news.count + news.count)
               self.news.append(contentsOf: news)
               self.groups.append(contentsOf: groups)
               self.nextFrom = nextFrom
               self.reloadNewsGroups(news: self.news, groups: self.groups, width: width)
               self.feedCollectionView?.insertSections(indexSet)
               self.feedCollectionView!.reloadData()
               self.isLoading = false
           }
       }
   }
}


