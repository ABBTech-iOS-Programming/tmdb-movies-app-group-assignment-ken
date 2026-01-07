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
}

struct AuthorDetails: Codable {
    let avatarPath: String?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case avatarPath = "avatar_path"
        case rating
    }
}
