//
//  MoviesViewController.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//
import UIKit

final class MoviesViewController : UIViewController {
    
    private let viewModel : MoviesViewModel
    
    private let networkService: NetworkService
    
    init(viewModel: MoviesViewModel,networkService: NetworkService = DefaultNetworkService()) {
        self.viewModel = viewModel
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }

    func fetchTrending() {
        networkService.request(MovieEndpoints.trending) {
            (result: Result<MovieListResponse, NetworkError>) in
            
            switch result {
            case .success(let response):
                print(response.results)
            case .failure(let error):
                print("Error:", error)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTrending()
    }
     
    
}
