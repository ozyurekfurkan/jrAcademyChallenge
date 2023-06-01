//
//  GameModel.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 1.06.2023.
//

import Foundation

struct WelcomePageResponse: Codable {
    var results: [GameModel]
}

struct GameModel: Codable {
    let id: Int?
    let name, released: String?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop, metacritic, playtime: Int?
    let parentPlatforms: [ParentPlatform]?
    let genres: [Genre]?

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage
        case rating
        case ratingTop
        case metacritic, playtime
        case parentPlatforms
        case genres
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int?
    let name, slug: String?
    let gamesCount: Int?
    let imageBackground: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount
        case imageBackground
    }
}

// MARK: - ParentPlatform
struct ParentPlatform: Codable {
    let platform: Platform?
}

// MARK: - Platform
struct Platform: Codable {
    let id: Int?
    let name, slug: String?
}
