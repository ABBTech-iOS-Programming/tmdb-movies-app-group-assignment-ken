//
//  WatchList.swift
//  TmdbAppTeam
//
//  Created by Durdana on 09.01.26.
//
import Foundation

struct WatchList: Codable {
    let mediaType: String = "movie"
    let mediaId: Int
    let watchlist: Bool
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaId = "media_id"
        case watchlist
    }
}
