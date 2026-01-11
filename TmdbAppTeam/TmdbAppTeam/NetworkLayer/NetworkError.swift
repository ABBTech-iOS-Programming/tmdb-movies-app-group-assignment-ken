//
//  NetworkError.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case encodingError
    case serverError(statusCode: Int)
    case unknown(Error)
}
