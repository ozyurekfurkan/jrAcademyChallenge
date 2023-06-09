//
//  Service.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 1.06.2023.
//

import Foundation
import Alamofire

enum GameServiceEndPoint: String {
  static var BASE_URL = "https://api.rawg.io/api/games?key=d034a75038454466bec9e04d774a3336"
  case PATH = "&search={search}"
  static var DETAIL_URL = "https://api.rawg.io/api/games/{id}?key=d034a75038454466bec9e04d774a3336"
  
  static func path() -> String {
    return BASE_URL
  }
  
  static func searchPath(search: String?) -> String {
    var url = "\(BASE_URL)\(PATH.rawValue)"
    if let search = search {
      url = url.replacingOccurrences(of: "{search}", with: search)
    }
    return url
  }
  
  static func detailPath(id: String?) -> String {
    var url = "\(DETAIL_URL)"
    if let id = id {
      url = url.replacingOccurrences(of: "{id}", with: id)
    }
    return url
  }
}

protocol IGameService {
  func fetchAllDatas(url: String, response: @escaping ([GameModel]?, String?) -> Void)
  func fetchGameDetail(url: String, response: @escaping (GameDetailModel?) -> Void)
}


struct GameService: IGameService {
  func fetchAllDatas(url: String, response: @escaping ([GameModel]?, String?) -> Void) {
    AF.request(url).responseDecodable(of: WelcomePageResponse.self) { model in
      guard let data = model.value else {
        response(nil, nil)
        return
      }
      print(data.results)
      response(data.results, data.next)
    }
  }
  
  func fetchGameDetail(url: String, response: @escaping (GameDetailModel?) -> Void) {
    AF.request(url).responseDecodable(of: GameDetailModel.self) { model in
      guard let data = model.value else {
        response(nil)
        return
      }
      print(data)
      response(data)
    }
  }
}
