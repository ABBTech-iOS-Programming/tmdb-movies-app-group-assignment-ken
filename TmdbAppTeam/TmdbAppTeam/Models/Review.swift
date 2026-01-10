//
//  Review.swift
//  Test_Movie
//
//  Created by Durdana on 29.12.25.
//

struct Review: Codable {
    let author: String
    let content: String
    let authorDetails: AuthorDetails?

    enum CodingKeys: String, CodingKey {
        case author, content
        case authorDetails = "author_details"
    }
    
    var avatarURL: String? {
        guard let path = authorDetails?.avatarPath else { return nil }
        return APIConstants.imageBaseURL + path
    }
}

struct AuthorDetails: Codable {
    let avatarPath: String?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case avatarPath = "avatar_path"
        case rating
    }
}
