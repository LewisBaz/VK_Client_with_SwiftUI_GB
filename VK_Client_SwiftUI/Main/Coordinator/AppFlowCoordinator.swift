//
//  AppFlowCoordinator.swift
//  VK_Client_SwiftUI
//
//  Created by Lewis on 05.01.2022.
//

import Combine
import SwiftUI

class AppFlowCoordinator: NSObject {
    
    let loginViewModel: LoginViewModel = LoginViewModel()
    var navigationController: UINavigationController!
    let networkService = NetworkService()
    
    private var disposeBag: Set<AnyCancellable> = []
    
    override init() {
        super.init()
        let loginView = LoginView(viewModel: loginViewModel, appCoordinator: self)
        let loginViewController = UIHostingController(rootView: loginView)
        
        self.navigationController = UINavigationController(rootViewController: loginViewController)
    }
    
    func start() {
        self.loginViewModel.$isUserLoggedIn
            .sink { [unowned self] isLoggedIn in
                
                //self.navigationController.present(UIHostingController(rootView: VKLoginWebView()), animated: true, completion: nil)
                
                let icon1 = UITabBarItem(title: "Users", image: UIImage(systemName: "person.2.fill"), selectedImage: UIImage(named: "otherImage.png"))
                let icon2 = UITabBarItem(title: "Groups", image: UIImage(systemName: "square.grid.2x2.fill"), selectedImage: UIImage(named: "otherImage.png"))
                
                let usersVC = self.usersVC()
                usersVC.tabBarItem = icon1
                let groupsVC = self.groupsVC()
                groupsVC.tabBarItem = icon2
                
                if isLoggedIn == false {
                    self.navigationController.popToRootViewController(animated: true)
                } else {
//                    if Session.shared.token == "" {
//                        self.navigationController.present(UIHostingController(rootView: VKLoginWebView()), animated: true, completion: nil)
//                    } else {
                        self.navigationController.present(UIHostingController(rootView: VKLoginWebView()), animated: true, completion: nil)
                        //self.navigationController.dismiss(animated: true, completion: nil)
                    
                        let usersNavVC = self.configureNavController()
                        usersNavVC.viewControllers = [usersVC]
                        
                        let groupsNavVC = self.configureNavController()
                        groupsNavVC.viewControllers = [groupsVC]

                        let controller = UITabBarController()
                        controller.viewControllers = [usersNavVC, groupsNavVC]
                        controller.navigationItem.hidesBackButton = true
                        self.navigationController.pushViewController(controller, animated: true)
                        
                        guard let navigationController = self.navigationController else { return }
                        var navigationArray = navigationController.viewControllers
                        let temp = navigationArray.last
                        navigationArray.removeAll()
                        navigationArray.append(temp!)
                        self.navigationController?.viewControllers = navigationArray
                    //}
                }
            }
            .store(in: &disposeBag)
    }
    
    private func usersVC() -> UIViewController {
        let view = UserFriendsView(users: UsersViewModel(networkService: networkService))
        return UIHostingController(rootView: view)
    }
    
    private func groupsVC() -> UIViewController {
        let view = UserGroupsView(groups: GroupsViewModel(networkService: networkService))
        return UIHostingController(rootView: view)
    }
    
    private func configureNavController() -> UINavigationController {
        let navVC = UINavigationController()
        navVC.navigationBar.tintColor = UIColor(red: 99.0 / 255.0, green: 229.0 / 255.0, blue: 230.0 / 255.0, alpha: 1.0)
        navVC.navigationBar.prefersLargeTitles = true
        navVC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 99.0 / 255.0, green: 229.0 / 255.0, blue: 230.0 / 255.0, alpha: 1.0)]
        navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 99.0 / 255.0, green: 229.0 / 255.0, blue: 230.0 / 255.0, alpha: 1.0)]
        return navVC
    }
}
