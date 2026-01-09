//
//  SearchViewModel.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//
import UIKit
final class SearchViewModel {

    private let service: DefaultNetworkService

    var movies: [Movie] = []
    
    var genreMap: [Int: String] = [:]

    var onResultsUpdated: (() -> Void)?

    init(service: DefaultNetworkService) {
        self.service = service
        fetchGenres()
    }
 
    func search(query: String) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            movies = []
            onResultsUpdated?()
            return
        }

        service.request(MovieEndpoints.search(query: query)) { [weak self]
            (result: Result<MovieListResponse, NetworkError>) in

            switch result {
            case .success(let response):
                self?.movies = response.results
                DispatchQueue.main.async {
                    self?.onResultsUpdated?()
                }

            case .failure(let error):
                print("Search error:", error)
            }
        }
    }
 
    private func fetchGenres() {
        service.request(MovieEndpoints.genres) { [weak self]
            (result: Result<GenreResponse, NetworkError>) in

            switch result {
            case .success(let response):
                response.genres.forEach {
                    self?.genreMap[$0.id] = $0.name
                }

            case .failure(let error):
                print("Genre error:", error)
            }
        }
    }
}
