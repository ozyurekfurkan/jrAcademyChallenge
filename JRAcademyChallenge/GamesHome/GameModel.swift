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
  var name: String
  var backgroundImage: String?
  var metacritic: Int?
  var genres: [Genre]?
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case backgroundImage = "background_image"
    case metacritic
    case genres
  }
}

// MARK: - Genre
struct Genre: Codable {
  var name: String?
  enum CodingKeys: String, CodingKey {
    case name
  }
}
