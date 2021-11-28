//
//  UserFriendsViewController.swift
//  VK App
//
//  Created by Lev Bazhkov on 28.04.2021.
//

import UIKit
import RealmSwift

final class UserFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var letterControl: LetterControl!
    
    private var firstLetters = [String]()
    private var getFuturePromise = GetFuturePromiseData()
    private let networkService = NetworkService()
    private let databaseService = DatabaseService()
    private let modelFactory = FriendCellModelFactory()
    private var viewModels: [FriendCellModel] = []
    private var usersToAddToDatabase = [VKUser]()
    private let serviceProxy = ServiceProxy(networkService: NetworkService())
    var arrayOfIds = [String]()
    var usersToShow = [VKUser]()
    var photos = [VKImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usersToShow = self.databaseService.readUser()
        
        if usersToShow.isEmpty == false {
            var index = 0
            for _ in usersToShow {
                self.arrayOfIds.append(usersToShow[index].userId ?? "")
                index += 1
            }
        }
        
        func loadControl() {
            if usersToShow.isEmpty == false {
                firstLetters = Array(Set(usersToShow.compactMap({String($0.firstName?.first ?? "*")})).sorted())
            } else {
                firstLetters = Array(Set(self.usersToAddToDatabase.compactMap({String($0.firstName?.first ?? "*")})).sorted())
            }
            letterControl.letters = firstLetters
            letterControl.setupView()
            letterControl.addTarget(self, action: #selector(letterControlUpdated), for: .valueChanged)

            tableView.register(HeaderForUser.self, forHeaderFooterViewReuseIdentifier: HeaderForUser.reuseId)
        }
        
        if usersToShow.isEmpty == true {
            getFuturePromise.getFriends(on: .global())
                .map(with: { [weak self] users in
                    guard let self = self else { return }
                    self.usersToAddToDatabase = users
                    self.viewModels = self.modelFactory.constructViewModels(from: users)
                    self.tableView.reloadData()

                    self.tableView.beginUpdates()
                        for user in users {
                            if !self.arrayOfIds.contains(user.userId ?? "") {
                                self.databaseService.add(user: user)
                            }
                        }
                    self.tableView.endUpdates()
                    loadControl()
                })
        } else {
            self.viewModels = self.modelFactory.constructViewModels(from: usersToShow)
            self.tableView.reloadData()
            loadControl()
        }
    }

    @objc private func letterControlUpdated() {
        guard let letter = letterControl.selectedLetter else { return }
        letterDidSelect(letter: letter)
    }

    func letterDidSelect(letter: String) {
        let index = usersToShow.firstIndex { (user) -> Bool in
            String((user.firstName?.first!)!) == letter
        }
        guard let indexRow = index else { return }
        tableView.scrollToRow(at: IndexPath(row: 0, section: indexRow), at: .top, animated: true)
    }
    
    // MARK: - Table view animations
        
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let scale = CGAffineTransform(scaleX: 0.7, y: 0.7)
        cell.transform = scale
        cell.alpha = 0.5
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        cell.transform = .identity
                        cell.alpha = 1
                       })
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserFriendsTableViewCell.reuseIdentifier, for: indexPath) as! UserFriendsTableViewCell
        
        let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
        cell.userImage.transform = scale
        cell.userImage.alpha = 0.5
        UIView.animate(withDuration: 3,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        cell.userImage.transform = .identity
                        cell.userImage.alpha = 1
        })
        
        cell.configure(with: viewModels[indexPath.row])
        cell.selectionStyle = .none

        return cell
    }
    
    // MARK: - Navigation
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "UserImages") as? UserImagesViewController
        
        guard let destinationController = controller else { return }
        
        let friend = viewModels[indexPath.row]
        let ownerID = friend.userId
        
        destinationController.title = friend.userFirstName + " " + friend.userLastName

        self.serviceProxy.getPhotos(for: ownerID, completion: { [weak self] photos in
                                            guard let self = self else { return }

            let realmImages = self.databaseService.readImage()
            var arrayOfIds = [String]()
            
            if realmImages.isEmpty == false {
                var index = 0
                for _ in realmImages {
                    arrayOfIds.append(realmImages[index].id ?? "")
                    index += 1
                }
            }
            
            if realmImages.count > 50 {
                let imagesToDelete = realmImages.dropLast(20)
                for image in imagesToDelete {
                    self.databaseService.delete(image: image, id: image.id ?? "")
                }
            }
            
            switch photos.count {
            case 0:
                destinationController.imageViewOne.image = UIImage(named: "noImage")
                destinationController.imageViewTwo.image = UIImage(named: "noImage")
                destinationController.likeControlOne.isHidden = true
                destinationController.likeControlTwo.isHidden = true
            case 1:
                if !arrayOfIds.contains(photos[0].id ?? "") {
                    self.databaseService.add(image: photos[0])
                }
                guard let imageOne = photos[0].image else { return }
                destinationController.imageViewOne.sd_setImage(with: URL(string: imageOne), placeholderImage: UIImage())
                if photos[0].isLiked == "true" {
                    destinationController.likeControlOne.isLiked = true
                } else {
                    destinationController.likeControlOne.isLiked = false
                }
                destinationController.likeControlOne.likeCount = Int(photos[0].count ?? "0") ?? 0
            case 2:
                if !arrayOfIds.contains(photos[0].id ?? "") {
                    self.databaseService.add(image: photos[0])
                }
                if !arrayOfIds.contains(photos[1].id ?? "") {
                    self.databaseService.add(image: photos[1])
                }
                guard let imageOne = photos[0].image else { return }
                guard let imageTwo = photos[1].image else { return }
                destinationController.imageViewOne.sd_setImage(with: URL(string: imageOne), placeholderImage: UIImage())
                if photos[0].isLiked == "true" {
                    destinationController.likeControlOne.isLiked = true
                } else {
                    destinationController.likeControlOne.isLiked = false
                }
                destinationController.likeControlOne.likeCount = Int(photos[0].count ?? "0") ?? 0
                
                destinationController.imageViewTwo.sd_setImage(with: URL(string: imageTwo), placeholderImage: UIImage())
                if photos[1].isLiked == "true" {
                    destinationController.likeControlTwo.isLiked = true
                } else {
                    destinationController.likeControlTwo.isLiked = false
                }
                destinationController.likeControlTwo.likeCount = Int(photos[1].count ?? "0") ?? 0
            default:
                return
            }
        })
            navigationController?.pushViewController(destinationController, animated: true)
    }
    
    // MARK: - Deleting

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModels.remove(at: indexPath.row)
            databaseService.delete(user: usersToShow[indexPath.row], userId: usersToShow[indexPath.row].userId ?? "")
            self.tableView.reloadData()
        }
    }
 }

    // MARK: - Extensions

extension Results {
    func toArray() -> [Element] {
      return compactMap {$0}
    }
 }
