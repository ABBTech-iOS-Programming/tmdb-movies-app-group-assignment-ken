//
//  MovieDetail.swift
//  TmdbAppTeam
//
//  Created by Durdana on 05.01.26.
//

struct MovieDetail: Decodable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let runtime: Int?
    let genres: [Genre]? 
    
    struct Genre: Decodable {
        let name: String
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case genres
        case runtime
        
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
