//
//  APIConstants.swift
//  TmdbAppTeam
//
//  Created by Macbook on 03.01.26.
//

import Foundation
enum APIConstants {

    static let baseURL: String = {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "TMDB_BASE_URL") as? String else {
            fatalError("URL NOT FOUND")
        }
        return value
    }()

    static let token: String = {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_TOKEN") as? String else {
            fatalError("KEY NOT FOUND")
        }
        return value
    }()
    
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
}
