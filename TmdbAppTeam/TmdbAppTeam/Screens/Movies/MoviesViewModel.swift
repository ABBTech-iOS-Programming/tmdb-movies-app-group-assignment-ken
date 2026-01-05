//
//  MoviesViewModel.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//
import Foundation

final class MoviesViewModel {
    private let service : DefaultNetworkService
    var movies: [Movie] = []
    
    var onMoviesUpdated: (() -> Void)?
    
    init(service: DefaultNetworkService) {
        self.service = service
    }
    
    func fetchTrendingMovies() {
        service.request(MovieEndpoints.trending) { [weak self] (result: Result<MovieListResponse, NetworkError>) in
            switch result {
            case .success(let response):
                self?.movies = response.results
                DispatchQueue.main.async {
                    self?.onMoviesUpdated?()
                }
                print(response.results)
            case .failure(let error):
                print("LOG: Error:", error)
            }
        }
    }
}
