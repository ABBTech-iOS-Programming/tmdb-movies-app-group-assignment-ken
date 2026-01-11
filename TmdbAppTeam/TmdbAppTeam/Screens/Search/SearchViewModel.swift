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
        Task {
           await fetchGenres()
        }
    }
    
    func search(query: String) async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            movies = []
            await MainActor.run {
                onResultsUpdated?()
            }
            return
        }
        
        do {
            let response: MovieListResponse = try await service.request(MovieEndpoints.search(query: query))
            self.movies = response.results
            
            await MainActor.run {
                self.onResultsUpdated?()
            }
        } catch {
            print("Search error:", error)
        }
    }
    
    private func fetchGenres() async {
        do {
            let response: GenreResponse = try await service.request(MovieEndpoints.genres)
            response.genres.forEach { self.genreMap[$0.id] = $0.name }
        } catch {
            print("Genre error:", error)
        }
    }
}
