//
//  MovieEndpoints.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//
import Foundation
enum MovieEndpoints: Endpoint {

    case trending
    case nowPlaying
    case popular
    case upcoming
    case topRated
    case details(id: Int)
    case search(query: String)
    case reviews(id: Int)
    case genres
    case addToWatchlist(movieId: Int, isAdding: Bool)
    case getWatchlist
    
    var baseURL: String {
        APIConstants.baseURL
    }
    
    private var accountId: Int { 22617555 }

    var path: String {
        switch self {
        case .trending:
            return "/trending/movie/day"
        case .nowPlaying:
            return "/movie/now_playing"
        case .popular:
            return "/movie/popular"
        case .upcoming:
            return "/movie/upcoming"
        case .topRated:
            return "/movie/top_rated"
        case .details(let id):
            return "/movie/\(id)"
        case .search:
            return "/search/movie"
        case .genres:
            return "/genre/movie/list"
        case .reviews(let id):
            return "/movie/\(id)/reviews"
        case .addToWatchlist:
            return "/account/\(accountId)/watchlist"
        case .getWatchlist:
            return "/account/\(accountId)/watchlist/movies"
        }
    }

    var method: HttpMethod {
        switch self {
        case .addToWatchlist:
            return .post
        default:
            return .get
        }
    }

    var headers: [String : String]? {
        [
            "Authorization": APIConstants.token,
            "Content-Type": "application/json"
        ]
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .search(let query):
            return [
                URLQueryItem(name: "query", value: query)
            ]
        default:
            return nil
        }
    }

    var httpBody: Encodable? {
        switch self {
        case .addToWatchlist(let movieId, let isAdding):
            return WatchList(mediaId: movieId, watchlist: isAdding)
        default:
            return nil
        }
        }
    }

