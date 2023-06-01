//
//  GameHomeViewController.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 31.05.2023.
//

import Foundation
import UIKit
import SnapKit
import Alamofire

class GameHomeViewController: UIViewController {
  var tableView: UITableView = UITableView()

  var result: WelcomePageResponse?
  var dataDescription = "metacritic: "

  var gameTestImage = "rdr2"
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchGameData()
  }
  
  func fetchGameData(){
      AF.request("https://api.rawg.io/api/games?key=3be8af6ebf124ffe81d90f514e59856c", method: .get,encoding: URLEncoding.default)
          .responseData { response in // note the change to responseData
              switch response.result {
              case .failure(let error):
                  print(error)
              case .success(let data):
                  do {
                      let decoder = JSONDecoder()
                      decoder.keyDecodingStrategy = .convertFromSnakeCase
                      self.result = try decoder.decode(WelcomePageResponse.self, from: data)
                      self.configure()
                  } catch { print(error) }
              }
      }
    tableView.reloadData()
  }
  
  func configure() {
    view.backgroundColor = .black
    self.view.addSubview(tableView)
    tableView.register(GameView.self, forCellReuseIdentifier: GameView.identifier)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundColor = .darkGray
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}

extension GameHomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result?.results.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameView.identifier, for: indexPath) as! GameView
        cell.gameTitle.text = result?.results[indexPath.row].name
        cell.metaCriticLabel.text = dataDescription
//        if let genres =  result?.results[indexPath.row].genres {
//          for genre in genres {
//            if let name = genre.name {
//              cell.gameGenre.text += name + ", "
//            }
//          }
//        }
        if let genres = result?.results[indexPath.row].genres {
            let genreNames = genres.compactMap { $0.name }
            if !genreNames.isEmpty {
                let joinedGenreNames = genreNames.joined(separator: ", ")
                cell.gameGenre.text = joinedGenreNames
            } else {
                cell.gameGenre.text = "N/A"
            }
        }
        cell.metaCriticScoreLabel.text = result?.results[indexPath.row].metacritic?.description
        cell.gameImage.image = UIImage(named: gameTestImage)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      136
    }
}
