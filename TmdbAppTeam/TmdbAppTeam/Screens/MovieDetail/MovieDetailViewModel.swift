//
//  MovieViewModel.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.

import Foundation

final class MovieDetailViewModel {
    private let service: DefaultNetworkService
    
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
    
    var avatarURL: String? {
        guard let path = reviews.first?.authorDetails?.avatarPath else { return nil }
        return APIConstants.imageBaseURL + path
    }
    
    func fetchMovieDetails() {
        service.request(MovieEndpoints.details(id: movieId)) { [weak self] (result: Result<MovieDetail, NetworkError>) in
            switch result {
            case .success(let detail):
                self?.movieDetail = detail
                
                DispatchQueue.main.async {
                    self?.onDataFetched?()
                }
            case .failure(let error):
                print("LOG Error:", error)
            }
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
    
    func fetchMovieReview() {
        service.request(MovieEndpoints.reviews(id: movieId)) { [weak self] (result: Result<ReviewListResponse, NetworkError>) in
            switch result {
            case .success(let response):
                self?.reviews = response.results
                
                DispatchQueue.main.async {
                    self?.onReviewsFetched?()
                }
            case .failure(let error):
                print("LOG Review Error:", error)
            }
        }
    }
    
}
