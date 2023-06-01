//
//  Service.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 1.06.2023.
//

import Foundation
import Alamofire

enum GameServiceEndPoint: String {

    case BASE_URL = "https://api.rawg.io/api"
    case PATH = "/games?key=3be8af6ebf124ffe81d90f514e59856c"

    static func path() -> String {
        return "\(BASE_URL.rawValue)\(PATH.rawValue)"
    }
}

protocol IGameService {
    func fetchAllDatas(response: @escaping ([GameModel]?) -> Void)
}


struct GameService: IGameService {

    func fetchAllDatas(response: @escaping ([GameModel]?) -> Void) {
        AF.request(GameServiceEndPoint.path()).responseDecodable(of: WelcomePageResponse.self) { (model) in
            guard let data = model.value else {
                response(nil)
                return
            }
            print(data.results)
            response(data.results)
        }
    }

}
