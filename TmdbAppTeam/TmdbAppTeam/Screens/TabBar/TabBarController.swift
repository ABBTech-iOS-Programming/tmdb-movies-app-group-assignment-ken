//
//  TabBarController.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//
import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupApperanceTab()
    }

    private func setupTabs() {
        
        let moviesVC = MoviesViewController(
            viewModel: MoviesViewModel(service: DefaultNetworkService())
        )
        
        let searchVC = SearchViewController(
            viewModal: SearchViewModel()
        )
        
        let watchListVC = WatchListViewController(
            viewModel: WatchListViewModel()
        )

        let moviesNav = UINavigationController(rootViewController: moviesVC)
        
        let searchNav = UINavigationController(rootViewController: searchVC)
        
        let watchListNav = UINavigationController(rootViewController: watchListVC)

        moviesNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "home-gray"),
            selectedImage: UIImage(named: "home")
        )

        searchNav.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(named: "search"),
            selectedImage: UIImage(named: "search-blue")
        )

        watchListNav.tabBarItem = UITabBarItem(
            title: "Watchlist",
            image: UIImage(named: "bookmark"),
            selectedImage: UIImage(named: "watchlist-blue")
        )
        
        viewControllers = [moviesNav, searchNav, watchListNav]
    }
    
    func setupApperanceTab() {
        let apperance = UITabBarAppearance()
      
        apperance.configureWithOpaqueBackground()
        apperance.backgroundColor = UIColor(named: "blackMedium")
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .gray
        tabBar.isTranslucent = false
        tabBar.layer.cornerRadius = 20
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.clipsToBounds = true
        
        tabBar.standardAppearance = apperance
        tabBar.scrollEdgeAppearance = apperance
        
    }
    
    

}
