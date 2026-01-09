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

        var onResultsUpdated: (() -> Void)?

        init(service: DefaultNetworkService) {
            self.service = service
        }

        func search(query: String) {
            guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
                movies = []
                onResultsUpdated?()
                return
            }

            service.request(MovieEndpoints.search(query: query)) {
                [weak self]
                (result:Result<MovieListResponse, NetworkError>) in
                switch result
                {
                case
                .success(let response):
                    self?.movies = response.results
                    DispatchQueue.main.async {
                        self?.onResultsUpdated?()
                    }

                case
                .failure(let error):
                    print("Search error:", error)
                }
            }
        }
}
