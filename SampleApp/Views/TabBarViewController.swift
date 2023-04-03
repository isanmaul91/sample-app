//
//  TabBarViewController.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 03/04/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let home = createHomeScreen()
        let favorite = createFavoriteScreen()
        
        home.tabBarItem.image = UIImage(systemName: "house.fill")
        favorite.tabBarItem.image = UIImage(systemName: "heart.fill")
        
        home.title = "Home"
        favorite.title = "Favorite"
        
        tabBar.tintColor = UIColor(red: 0.29, green: 0.33, blue: 0.55, alpha: 1.00)
        setViewControllers([home, favorite], animated: true)
        modalPresentationStyle = .fullScreen
    }
    
    func createHomeScreen() -> UINavigationController {
        let storyboard: UIStoryboard = .init(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Home")
        return UINavigationController(rootViewController: vc)
    }
    
    func createFavoriteScreen() -> UINavigationController {
        let storyboard: UIStoryboard = .init(name: "Favorite", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Favorite")
        return UINavigationController(rootViewController: vc)
    }
}
