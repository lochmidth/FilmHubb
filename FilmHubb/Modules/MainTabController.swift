//
//  MainTabController.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 2.10.2023.
//

import UIKit

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
        showLoader(true)
    }
    
    //MARK: - API
    
    //MARK: - Actions
    
    //MARK: - Helpers
    
    func configureViewControllers() {
        
        view.backgroundColor = .white
        
        let home = templateNavigationController(title: "Home", unselectedImage: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"), rootViewController: HomeController())
        
        let search = templateNavigationController(title: "Search", unselectedImage: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass.fill"), rootViewController: SearchController())
        
        let layout = UICollectionViewFlowLayout()
        let favorite = templateNavigationController(title: "Favorite Movies", unselectedImage: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"), rootViewController: FavoriteMoviesController(collectionViewLayout: layout))
        
        setViewControllers([home, search, favorite], animated: true)
        
        
        tabBar.isTranslucent = false
        tabBar.tintColor = .black
        
        let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemGroupedBackground
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
    }
    
    func templateNavigationController(title: String, unselectedImage: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.title = title
        return nav
        
    }
}
