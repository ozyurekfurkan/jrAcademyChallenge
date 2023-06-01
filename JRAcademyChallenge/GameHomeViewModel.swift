//
//  GameHomeViewModel.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 1.06.2023.
//

import Foundation

protocol IGameHomeViewModel {
  func fetchItems()
  
  var games: [GameModel] { get set }
  var gameService: IGameService { get }
  var gameOutPut: GamesOutPut? { get }
  func setDelegate(output: GamesOutPut)
}
final class GameHomeViewModel: IGameHomeViewModel {
  var gameOutPut: GamesOutPut?
  var urlString = "https://api.rawg.io/api/games?key=3be8af6ebf124ffe81d90f514e59856c"
  func setDelegate(output: GamesOutPut) {
    gameOutPut = output
  }
  var games: [GameModel] = []
  let gameService: IGameService
  
  init() {
      gameService = GameService()
  }
  
  func fetchItems() {
    gameService.fetchAllDatas(url: urlString) { gameModels in
        if let gameModels = gameModels {
          self.games = gameModels
          self.gameOutPut?.saveDatas(values: self.games)
        } else {
            print("Failed to fetch game models.")
        }
    }
  }
}
