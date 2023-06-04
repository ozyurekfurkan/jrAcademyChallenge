//
//  Service.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 1.06.2023.
//

import Foundation
import Alamofire

enum GameServiceEndPoint: String {
  
    static var BASE_URL = "https://api.rawg.io/api/games?key=3be8af6ebf124ffe81d90f514e59856c"
    case PATH = "&search={search}"

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
}

protocol IGameService {
    func fetchAllDatas(url:String,response: @escaping ([GameModel]?,String?) -> Void)
}


struct GameService: IGameService {

  func fetchAllDatas(url:String,response: @escaping ([GameModel]?,String?) -> Void) {
          AF.request(url).responseDecodable(of: WelcomePageResponse.self) { (model) in
            guard let data = model.value else {
                response(nil,nil)
                return
            }
            print(data.results)
            response(data.results,data.next)
        }
    }

}
