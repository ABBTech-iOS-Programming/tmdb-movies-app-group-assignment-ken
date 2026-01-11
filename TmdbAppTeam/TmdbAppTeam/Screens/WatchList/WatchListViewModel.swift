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
    
    func fetchWatchList() async {
        do {
            let response: WatchListResponse = try await service.request(MovieEndpoints.getWatchlist)
            self.movies = response.results ?? []
            
            await MainActor.run {
                self.onDataUpdated?()
            }
        } catch {
            print("WatchList error:", error)
        }
        
    }
    
    func fetchGenresAndWatchlist() async {
        
        do{
            let genreResponse: GenreResponse = try await service.request(MovieEndpoints.genres)
            genreResponse.genres.forEach { self.genreMap[$0.id] = $0.name }
            
            await fetchWatchList()
        } catch {
            print("Fetch Genre error:", error)
        }
        
        
    }
}
