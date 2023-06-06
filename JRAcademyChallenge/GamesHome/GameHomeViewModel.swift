//
//  GameHomeViewModel.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 1.06.2023.
//

import Foundation

protocol IGameHomeViewModel {
  func searchItems(search: String?)
  func fetchItems()
  var games: [GameModel] { get set }
  var gameService: IGameService { get }
  var gameOutPut: GamesOutPut? { get }
  func setDelegate(output: GamesOutPut)
}

final class GameHomeViewModel: IGameHomeViewModel {
  
  var gameOutPut: GamesOutPut?
  var isNextPageExist: Bool = false
  var searchRemoved: Bool = false
  var nextPageUrl: String?
  var urlString: String?
  
  
  func setDelegate(output: GamesOutPut) {
    gameOutPut = output
  }
  
  var games: [GameModel] = []
  let gameService: IGameService
  
  init() {
    gameService = GameService()
  }
  
  func fetchItems() {
    if searchRemoved {
      self.urlString = GameServiceEndPoint.BASE_URL
    }
    else if isNextPageExist {
      self.urlString = nextPageUrl ?? ""
    } else {
      self.urlString = GameServiceEndPoint.BASE_URL
    }
    if let urlString = urlString {
      gameService.fetchAllDatas(url: urlString) { gameModels,nextPage in
        if let gameModels = gameModels {
          self.games = gameModels
          self.gameOutPut?.saveDataAndRender(values: self.games)
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
  
  func searchItems(search: String?) {
    if isNextPageExist {
      self.urlString = nextPageUrl ?? ""
    } else {
      self.urlString = GameServiceEndPoint.BASE_URL
    }
    if let search = search {
      gameService.fetchAllDatas(url: GameServiceEndPoint.searchPath(search: search)) { gameModels,nextPage in
        if let gameModels = gameModels {
          self.games = gameModels
          self.gameOutPut?.saveDataAndRender(values: self.games)
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
