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
  var isNextPageExist = false
  var searchRemoved = false
  var nextPageUrl: String?
  var urlString: String?
  
  private func registerNotificationObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleFetchItemsNotification), name: NSNotification.Name("runFetchItems"), object: nil)
  }
  
  @objc private func handleFetchItemsNotification() {
    if !games.isEmpty {
      fetchItems()
    }
  }
  
  
  func setDelegate(output: GamesOutPut) {
    gameOutPut = output
  }
  
  var games: [GameModel] = []
  let gameService: IGameService
  
  init() {
    gameService = GameService()
    registerNotificationObserver()
  }
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  func fetchItems() {
    if searchRemoved {
      self.urlString = GameServiceEndPoint.BASE_URL
      searchRemoved = false
    } else if let isNextPageExist = nextPageUrl {
      self.urlString = isNextPageExist
    } else {
      self.urlString = GameServiceEndPoint.BASE_URL
    }
    if let urlString = urlString {
      gameService.fetchAllDatas(url: urlString) { gameModels, nextPage in
        if let gameModels = gameModels {
          self.games.append(contentsOf: gameModels)
          self.gameOutPut?.saveDataAndRender()
        } else {
          print("Failed to fetch game models.")
        }
        if let nextPage = nextPage {
          self.isNextPageExist = true
          print("MADE REQUEST")
          self.nextPageUrl = nextPage
        }
      }
    }
  }
  
  func searchItems(search: String?) {
    if let isNextPageExist = nextPageUrl {
      self.urlString = isNextPageExist
    } else {
      self.urlString = GameServiceEndPoint.BASE_URL
    }
    if let search = search {
      gameService.fetchAllDatas(url: GameServiceEndPoint.searchPath(search: search)) { gameModels, nextPage in
        if let gameModels = gameModels {
          self.games.append(contentsOf: gameModels)
          self.gameOutPut?.saveDataAndRender()
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
