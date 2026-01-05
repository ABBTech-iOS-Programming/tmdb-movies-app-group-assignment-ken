//
//  MovieViewModel.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//

import Foundation

final class MovieDetailViewModel {
    private let service: DefaultNetworkService
    
    let movieId: Int
    var movieDetail: MovieDetail?
    var onDataFetched: (() -> Void)?
    
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
    
    func downloadImage(completion: @escaping (Data?) -> Void) {
        guard let urlString = backImageURL, let url = URL(string: urlString) else {
        completion(nil)
        return
    }
            
    URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    completion(data)
                }
            }.resume()
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
    
    
}
