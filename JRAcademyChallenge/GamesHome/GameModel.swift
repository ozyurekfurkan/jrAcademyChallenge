//
//  GameModel.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 1.06.2023.
//

import Foundation

struct WelcomePageResponse: Codable {
  var next: String?
  var results: [GameModel]
}

struct GameModel: Codable {
  let id: Int?
  let name: String
  let backgroundImage: String?
  let metacritic: Int?
  let genres: [Genre]?
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case backgroundImage = "background_image"
    case metacritic
    case genres
  }
}

// MARK: - Genre
struct Genre: Codable {
  let name: String?
  enum CodingKeys: String, CodingKey {
    case name
  }
}
