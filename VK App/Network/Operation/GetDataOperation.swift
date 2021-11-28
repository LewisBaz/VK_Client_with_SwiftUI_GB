//
//  GetDataOperation.swift
//  VK App
//
//  Created by Lev Bazhkov on 08.08.2021.
//

import UIKit
import Alamofire
import DynamicJSON
import RealmSwift

class GetDataOperation: AsyncOperation {

    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    private var request: DataRequest
    var data: Data?
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
        }
    }
    
    init(request: DataRequest) {
        self.request = request
    }
}

class ParseGroupsData: Operation {
    
    var outputData: [VKGroup] = []
    
    override func main() {
        guard let getGroupsData = dependencies.first as? GetDataOperation,
              let data = getGroupsData.data else { return }
        guard let items = JSON(data).response.items.array else { return }
        let groups: [VKGroup] = items.map { VKGroup(data: $0) }
        outputData = groups
    }
}

class ReloadTableController: Operation {
    var controller: UserGroupsTableViewController
    
    init(controller: UserGroupsTableViewController) {
        self.controller = controller
    }
    
    override func main() {
        guard let parseData = dependencies.first as? ParseGroupsData else { return }
        controller.groupsToShow = parseData.outputData
        controller.tableView.reloadData()
    }
}


