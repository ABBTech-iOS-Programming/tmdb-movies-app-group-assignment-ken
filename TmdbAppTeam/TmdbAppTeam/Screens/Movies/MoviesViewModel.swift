//
//  MoviesViewModel.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//

import Foundation

enum MovieCategory {
    case nowPlaying
    case upcoming
    case topRated
}

final class MoviesViewModel {

    private let service: DefaultNetworkService

    var trendingMovies: [Movie] = []
    var categoryMovies: [Movie] = []

    var onMoviesUpdated: (() -> Void)?
    var onTrendingUpdated: (() -> Void)?

    init(service: DefaultNetworkService) {
        self.service = service
    }
    
    func fetchTrendingMovies() {
        service.request(MovieEndpoints.trending) {
            [weak self] (result: Result<MovieListResponse, NetworkError>) in

            switch result {
            case .success(let response):
                self?.trendingMovies = response.results
                DispatchQueue.main.async {
                    self?.onTrendingUpdated?()
                }

            case .failure(let error):
                print("Trending error:", error)
            }
        }
    }

    func fetchCategoryMovies(_ category: MovieCategory) {
        let endpoint: Endpoint

        switch category {
        case .nowPlaying:
            endpoint = MovieEndpoints.nowPlaying
        case .upcoming:
            endpoint = MovieEndpoints.upcoming
        case .topRated:
            endpoint = MovieEndpoints.topRated
        }

        service.request(endpoint) {
            [weak self] (result: Result<MovieListResponse, NetworkError>) in

            switch result {
            case .success(let response):
                self?.categoryMovies = response.results
                DispatchQueue.main.async {
                    self?.onMoviesUpdated?()
                }

            case .failure(let error):
                print("Category error:", error)
            }
        }
    }
}
