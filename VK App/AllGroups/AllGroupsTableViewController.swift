//
//  AllGroupsTableViewController.swift
//  VK App
//
//  Created by Lev Bazhkov on 28.04.2021.
//

import UIKit
import SDWebImage
import Firebase

final class AllGroupsTableViewController: UITableViewController {
    
    private let serviceProxy = ServiceProxy(networkService: NetworkService())
    var allGroups = [VKGroup]()
    private var firebaseGroups = [FirebaseVKGroup]()
    private let ref = Database.database().reference(withPath: "groups")
    private let modelFactory = GroupCellModelFactory()
    var viewModels: [GroupCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.observe(.value, with: { snapshot in
                var firebaseGroups: [FirebaseVKGroup] = []
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                       let group = FirebaseVKGroup(snapshot: snapshot) {
                        firebaseGroups.append(group)
                    }
                }
                    self.firebaseGroups = firebaseGroups
                    self.tableView.reloadData()
            
//            firebaseGroups.forEach({
//                //print($0.name, $0.id)
//            })
        })
        
        let group = DispatchGroup()

                group.enter()
                    serviceProxy.getGroupsSearch { [weak self] groups in
                    guard let self = self else { return }
                    self.allGroups = groups
                    self.viewModels = self.modelFactory.constructViewModels(from: groups)
                    self.tableView.reloadData()
                    group.leave()
                }
                group.notify(queue: .main) { [weak self] in
                    guard let self = self else { return }
                    self.tableView.reloadData()
                }
    }
    
//    @IBAction func addGroupToFB(sender: Any) {
//
//        let groupToAdd = allGroups[]
//
//        guard let groupName = groupToAdd.name  else { return }
//        guard let groupId = Int(groupToAdd.id!) else { return }
//        let group = FirebaseVKGroup(name: groupName, id: groupId)
//        let groupRef = self.ref.child(groupName.lowercased())
//        groupRef.setValue(group.toAnyObject())
//    }
         
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllGroupsTableViewCell.reuseIdentifier, for: indexPath) as! AllGroupsTableViewCell
        let group = allGroups[indexPath.row]
        
        cell.groupName.text = group.name
        cell.groupImage?.sd_setImage(with: URL(string: group.photo100!), placeholderImage: UIImage())
        cell.configure(with: viewModels[indexPath.row])
        cell.selectionStyle = .none
      
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let groupToAdd = allGroups[indexPath.row]
        guard let groupName = groupToAdd.name  else { return }
        guard let groupId = Int(groupToAdd.id!) else { return }
        let group = FirebaseVKGroup(name: groupName, id: groupId)
        let groupRef = ref.child(groupName.lowercased())
        groupRef.setValue(group.toAnyObject())
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
