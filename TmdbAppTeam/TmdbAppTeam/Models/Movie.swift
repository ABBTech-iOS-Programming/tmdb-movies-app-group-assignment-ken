//
//  Movie.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//

struct Movie: Decodable {

    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let genreIds: [Int]
    let originalLanguage: String
    let adult: Bool
    let video: Bool
    let mediaType: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case adult
        case video
        case popularity

        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case mediaType = "media_type"
    }
}
