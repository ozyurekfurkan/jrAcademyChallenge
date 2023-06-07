//
//  GameModel.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 1.06.2023.
//

import Foundation

struct GameDetailModel: Codable {
  let id: Int?
  let name: String
  let backgroundImage: String?
  let description: String?
  let redditUrl: String?
  let website: String?
  let metacritic: Int?
  let genres: [Genre]?
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case backgroundImage = "background_image"
    case description
    case metacritic
    case redditUrl = "reddit_url"
    case website
    case genres
  }
}
