//
//  GameHomeViewController.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 31.05.2023.
//

import Foundation
import UIKit
import SnapKit

class GameHomeViewController: UIViewController {
  var tableView: UITableView = UITableView()
  var data: [String] = [
      "GRAND THEFT AUTO V",
      "Game Label 2",
      "Game Label 3"
  ]
  var dataDescription = "metacritic: "
  var dataScore = "96"
  var gameGenre = "Action, shooter"
  var gameTestImage = "rdr2"
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
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
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameView.identifier, for: indexPath) as! GameView
        cell.gameTitle.text = data[indexPath.row]
        cell.metaCriticLabel.text = dataDescription
        cell.metaCriticScoreLabel.text = dataScore
        cell.gameGenre.text = gameGenre
        cell.gameImage.image = UIImage(named: gameTestImage)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      136
    }
}
