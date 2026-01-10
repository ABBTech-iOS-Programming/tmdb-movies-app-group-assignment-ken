//
//  WatchListViewModel.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//
import Foundation

final class WatchListViewModel {
    private let service: NetworkService
    var movies: [Movie] = []
    var genreMap: [Int: String] = [:]
    
    var onDataUpdated: (() -> Void)?
    
    init(service: NetworkService) {
        self.service = service
    }
    
    func fetchWatchList() {
        
        service.request(MovieEndpoints.getWatchlist) { [weak self] (result: Result<WatchListResponse, NetworkError>) in
            switch result {
            case .success(let response):
                self?.movies = response.results ?? []
                self?.onDataUpdated?()
            case .failure(let error):
                print("WatchList error:", error)
            }
        }
        
    }
    
    func fetchGenresAndWatchlist() {
        service.request(MovieEndpoints.genres) { [weak self] (result: Result<GenreResponse, NetworkError>) in
            if case .success(let response) = result {
                response.genres.forEach { self?.genreMap[$0.id] = $0.name }
            }
            self?.fetchWatchList()
        }
    }
    
    
}
