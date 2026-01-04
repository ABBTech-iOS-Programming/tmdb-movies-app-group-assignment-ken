//
//  MovieListResponse.swift
//  TmdbAppTeam
//
//  Created by Macbook on 03.01.26.
//


struct MovieListResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
