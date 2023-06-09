//
//  GameHomeViewModel.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 1.06.2023.
//

import Foundation

protocol IDetailViewModel {
  func fetchDetail()
  var game: GameDetailModel { get set }
  var gameService: IGameService { get }
  var gameOutPut: GameDetailOutPut? { get }
  func setDelegate(output: GameDetailOutPut)
}

final class DetailViewModel {
  var gameDetailOutPut: GameDetailOutPut?
  var urlString: String?
  var gameIDString: String?
  
  
  func setDelegate(output: GameDetailOutPut) {
    gameDetailOutPut = output
  }
  
  var game: GameDetailModel?
  let gameService: IGameService
  
  init() {
    gameService = GameService()
  }
  
  func fetchDetail() {
    self.urlString = GameServiceEndPoint.detailPath(id: gameIDString)
    if let urlString = urlString {
      gameService.fetchGameDetail(url: urlString) { gameDetailModel in
        if let gameDetailModel = gameDetailModel {
          self.game = gameDetailModel
          if let game = self.game {
            self.gameDetailOutPut?.saveDataAndRender(values: game)
          }
        } else {
          print("Failed to fetch game models.")
        }
      }
    }
  }
}
