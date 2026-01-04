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
    }

    private func setupTabs() {
        
        let moviesVC = MoviesViewController(
            viewModel: MoviesViewModel()
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
        
        tabBar.backgroundColor = .black

        viewControllers = [moviesNav, searchNav, watchListNav]
    }

}
