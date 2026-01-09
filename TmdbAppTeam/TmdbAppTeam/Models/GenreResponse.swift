//
//  GenreResponse.swift
//  TmdbAppTeam
//
//  Created by Macbook on 09.01.26.
//

import Foundation
struct GenreResponse: Decodable {
    let genres: [Genre]
}

struct Genre: Decodable {
    let id: Int
    let name: String
}
