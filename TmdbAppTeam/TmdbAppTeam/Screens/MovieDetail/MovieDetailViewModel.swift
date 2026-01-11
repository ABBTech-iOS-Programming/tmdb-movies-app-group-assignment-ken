//
//  MovieViewModel.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.

import Foundation

final class MovieDetailViewModel {
    private let service: DefaultNetworkService
    
    var isFavorite: Bool = false
    
    let movieId: Int
    var movieDetail: MovieDetail?
    var reviews: [Review] = []
    var onReviewsFetched: (() -> Void)?
    var onDataFetched: (() -> Void)?
    var onPosterUpdate: ((Data) -> Void)?
    
    var releaseYear: String {
        guard let date = movieDetail?.releaseDate else { return "N/A" }
        return String(date.prefix(4))
    }
    
    var runtimeText: String {
        guard let time = movieDetail?.runtime else { return "0 min" }
        return "\(time) min"
    }
    
    var genreText: String {
        return movieDetail?.genres?.first?.name ?? "N/A"
    }
    
    init(service: DefaultNetworkService, movieId: Int) {
        self.service = service
        self.movieId = movieId
    }
    
    var backImageURL: String? {
        guard let path = movieDetail?.backdropPath else { return nil }
        return APIConstants.imageBaseURL + path
    }
    
    var posterURL: String? {
        guard let path = movieDetail?.posterPath else { return nil }
        return APIConstants.imageBaseURL + path
    }
    
    func checkIfFavorite(watchListMovies: [Movie]) {
        self.isFavorite = watchListMovies.contains(where: { $0.id == movieId })
    }
    
    
    func fetchMovieDetails() async {
        do {
            let detail: MovieDetail = try await service.request(MovieEndpoints.details(id: movieId))
            self.movieDetail = detail
            
            await MainActor.run {
                self.onDataFetched?()
            }
        } catch {
            print("LOG Error:", error)
        }
    }
    
    func fetchPoster() {
        guard let url = posterURL else {  return }
        service.downloadImage(from: url) { [weak self] data in
            if let data = data {
                self?.onPosterUpdate?(data)
            }
        }
    }
    
    func fetchBackImage(completion: @escaping (Data?) -> Void) {
        guard let url = backImageURL else { return completion(nil) }
        service.downloadImage(from: url, completion: completion)
    }
    
    func fetchMovieReview() async {
        
        do{
            let response: ReviewListResponse = try await service.request(MovieEndpoints.reviews(id: movieId))
            self.reviews = response.results
            
            await MainActor.run {
                self.onReviewsFetched?()
            }
        } catch {
            print("LOG Review Error:", error)
        }
    }
    
    func fetchAvatarImage(from url: String, completion: @escaping (Data?) -> Void) {
        service.downloadImage(from: url, completion: completion)
    }
    
    func toggleWatchlist(isAdding: Bool) async {
        
        do {
            let watchlist : WatchList = try await service.request(MovieEndpoints.addToWatchlist(movieId: self.movieId, isAdding: isAdding))
            print("Watchlist update: Success")
        } catch {
            print("Watchlist Error:", error)
        }
    }
    
}
