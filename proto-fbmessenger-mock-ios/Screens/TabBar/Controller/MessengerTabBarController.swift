//
//  MessengerTabBarController.swift
//  proto-fbmessenger-mock-ios
//
//  Created by Santosh Krishnamurthy on 4/9/23.
//

import UIKit

class MessengerTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() -> Void {
        // First View Controller
        let recentMessagesController = FriendsController(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: recentMessagesController)
        navController.tabBarItem.title = "Recent"
        navController.tabBarItem.image = UIImage(named: "icons8-skunk-96")
        
        let secondVC = setupDummyViewController(title: "Second")
        let thirdVC = setupDummyViewController(title: "Third")
        let fourthVC = setupDummyViewController(title: "Fourth")
        let fifthVC = setupDummyViewController(title: "Fifth")
        
        viewControllers = [navController, secondVC, thirdVC, fourthVC, fifthVC]
        tabBar.tintColor = .orange
    }
    
    func setupDummyViewController(title: String) -> UIViewController {
        // second controller
        let vc = UIViewController()
        let navC = UINavigationController(rootViewController: vc)
        navC.tabBarItem.title = title
        return navC

    }

}
