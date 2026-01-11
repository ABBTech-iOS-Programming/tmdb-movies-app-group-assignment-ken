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
    case popular
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
    
    func fetchTrendingMovies() async {
        
        do {
            let response: MovieListResponse = try await service.request(MovieEndpoints.trending)
            self.trendingMovies = response.results
            
            await MainActor.run {
                self.onTrendingUpdated?()
            }
            
        }catch {
            print("Trending error:", error)
        }
    }
    
    func fetchCategoryMovies(_ category: MovieCategory) async {
        let endpoint: Endpoint
        
        switch category {
        case .nowPlaying:
            endpoint = MovieEndpoints.nowPlaying
        case .upcoming:
            endpoint = MovieEndpoints.upcoming
        case .topRated:
            endpoint = MovieEndpoints.topRated
        case .popular:
            endpoint = MovieEndpoints.popular
        }
        
        
        do {
            let response: MovieListResponse = try await service.request(endpoint)
            self.categoryMovies = response.results
            
            await MainActor.run {
                self.onMoviesUpdated?()
            }
        } catch {
            print("Category error:", error)
        }
    }
    
    
    func fetchListMovies() async -> [Movie]{
        
        do {
            let response: MovieListResponse = try await service.request(MovieEndpoints.getWatchlist)
            return response.results
        } catch {
            print("LOG: Watchlist error \(error)")
            return []
        }
        
    }
}
