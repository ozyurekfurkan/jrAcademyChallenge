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
  
  func setDelegate(output: GamesOutPut) {
    gameOutPut = output
  }
  var games: [GameModel] = []
  let gameService: IGameService
  
  init() {
      gameService = GameService()
  }
  
  func fetchItems() {
      gameService.fetchAllDatas { [weak self] (response) in
          self?.games = response ?? []
          self?.gameOutPut?.saveDatas(values: self?.games ?? [])
      }
  }
}
