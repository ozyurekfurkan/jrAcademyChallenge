//
//  GameHomeViewModel.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 1.06.2023.
//

import Foundation

protocol IGameHomeViewModel {
  func fetchItems(search: String?)
  
  var games: [GameModel] { get set }
  var gameService: IGameService { get }
  var gameOutPut: GamesOutPut? { get }
  func setDelegate(output: GamesOutPut)
}
final class GameHomeViewModel: IGameHomeViewModel {

  var gameOutPut: GamesOutPut?
  var isNextPageExist: Bool = false
  var nextPageUrl: String?
  var searchUrl: String?
  
  func setDelegate(output: GamesOutPut) {
    gameOutPut = output
  }
  
  var games: [GameModel] = []
  let gameService: IGameService
  
  init() {
      gameService = GameService()
  }
  
  func fetchItems(search: String?) {
    if isNextPageExist {
      GameServiceEndPoint.BASE_URL = nextPageUrl ?? ""
    }
    if let search = search {
      gameService.fetchAllDatas(url: GameServiceEndPoint.searchPath(search: search)) { gameModels,nextPage in
          if let gameModels = gameModels {
            self.games = gameModels
            self.gameOutPut?.saveDatas(values: self.games)
          } else {
              print("Failed to fetch game models.")
          }
        if let nextPage = nextPage {
          self.isNextPageExist = true
          self.nextPageUrl = nextPage
        }
      }
    } else {
      gameService.fetchAllDatas(url: GameServiceEndPoint.BASE_URL) { gameModels,nextPage in
          if let gameModels = gameModels {
            self.games = gameModels
            self.gameOutPut?.saveDatas(values: self.games)
          } else {
              print("Failed to fetch game models.")
          }
        if let nextPage = nextPage {
          self.isNextPageExist = true
          self.nextPageUrl = nextPage
        }
      }
    }
  }
}
