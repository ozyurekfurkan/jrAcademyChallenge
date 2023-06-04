//
//  Service.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 1.06.2023.
//

import Foundation
import Alamofire

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
