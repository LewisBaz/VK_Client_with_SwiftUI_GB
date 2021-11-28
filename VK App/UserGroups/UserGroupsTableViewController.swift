//
//  UserGroupsTableViewController.swift
//  VK App
//
//  Created by Lev Bazhkov on 28.04.2021.
//

import UIKit
import SDWebImage
import RealmSwift
import Alamofire

final class UserGroupsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContectForSearchText(searchController.searchBar.text!)
    }

    private let modelFactory = GroupCellModelFactory()
    private var viewModels: [GroupCellModel] = []
    let networkService = NetworkService()
    let databaseService = DatabaseService()
    private var filteredGroups = [GroupCellModel]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltered: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    var groupsToShow = [VKGroup]()
    var groupsForViewModels = [VKGroup]()
    var arrayOfIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groupsToShow = databaseService.readGroup()
        
        if groupsToShow.isEmpty == false {
            var index = 0
            for _ in groupsToShow {
                self.arrayOfIds.append(groupsToShow[index].id ?? "")
                index += 1
            }
        }
        
        if groupsToShow.isEmpty == true {
            let getGroupsQueue = OperationQueue()
            getGroupsQueue.qualityOfService = .userInitiated
            let request = AF.request("https://api.vk.com" + "/method/groups.get", parameters: [
                "user_id": Session.shared.userId,
                "extended": 1,
                "fields": "description",
                "access_token": Session.shared.token,
                "v": "5.131"
            ])
            let getGroupsOperation = GetDataOperation(request: request)
            getGroupsQueue.addOperation(getGroupsOperation)
            
            let parseGroups = ParseGroupsData()
            parseGroups.addDependency(getGroupsOperation)
            getGroupsQueue.addOperation(parseGroups)
            
            let reloadTableController = ReloadTableController(controller: self)
            reloadTableController.addDependency(parseGroups)
            OperationQueue.main.addOperation(reloadTableController)
            reloadTableController.completionBlock = {

                DispatchQueue.main.async {
                    self.viewModels = self.modelFactory.constructViewModels(from: parseGroups.outputData)
                    self.tableView.reloadData()
                    self.tableView.beginUpdates()
                    for group in parseGroups.outputData {
                        if !self.arrayOfIds.contains(group.id ?? "") {
                            self.databaseService.add(group: group)
                        }
                    }
                    self.tableView.endUpdates()
                }
            }
        } else {
            self.viewModels = self.modelFactory.constructViewModels(from: groupsToShow)
            self.tableView.reloadData()
        }
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltered {
            return filteredGroups.count
        }
        return viewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserGroupsTableViewCell.reuseIdentifier, for: indexPath) as! UserGroupsTableViewCell

        if isFiltered {
            cell.configure(with: filteredGroups[indexPath.row])
        } else {
            cell.configure(with: viewModels[indexPath.row])
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    // MARK: Deleting & Deselecting
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModels.remove(at: indexPath.row)
            self.databaseService.delete(group: self.groupsToShow[indexPath.row], id: self.groupsToShow[indexPath.row].id ?? "")
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Fileprivate Functions

    fileprivate func filterContectForSearchText(_ searchText: String) {
        
        filteredGroups = viewModels.filter({ (group: GroupCellModel) -> Bool in
            return group.groupName.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    // MARK: Navigation
    
    @IBAction private func addGroup(segue: UIStoryboardSegue) {
        guard
            segue.identifier == "AddGroup",
            let sourceController = segue.source as? AllGroupsTableViewController,
            let index = sourceController.tableView.indexPathForSelectedRow
        else { return }

        let group = sourceController.allGroups[index.row]
        let groupModel = sourceController.viewModels[index.row]
        if !groupsToShow.contains(group) {
            self.databaseService.add(group: group)
            self.viewModels.append(groupModel)
            tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "GroupSearch",
            let destinationController = segue.destination as? UserGroupsCollectionViewController,
            let index = tableView.indexPathForSelectedRow?.row
        else { return }
        
        let visibleGroup: GroupCellModel
        
        if isFiltered {
            visibleGroup = filteredGroups[index]
        } else {
            visibleGroup = viewModels[index]
        }
        
        destinationController.title = visibleGroup.groupName
        destinationController.group = visibleGroup
    }
}
