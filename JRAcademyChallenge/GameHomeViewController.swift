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
import Kingfisher

class GameHomeViewController: UIViewController {
  
  private let tableView: UITableView = UITableView()
  private let labelTitle: UILabel = UILabel()
  private let searchBar = UISearchBar()
  let apiUrl = "https://api.rawg.io/api/games?key=3be8af6ebf124ffe81d90f514e59856c"
  var result: WelcomePageResponse?
  var dataDescription = "metacritic: "
  var isFunctionRunning = false
  
  override func viewDidLoad() {
    self.view.backgroundColor = .white
    fetchGameData()
  }
  
  func fetchGameData() {
    makeRequest(url: apiUrl, method: .get) { (result: Result<WelcomePageResponse, Error>) in
        switch result {
        case .success(let response):
            self.result = response
            self.configure()
        case .failure(let error):
            print(error)
        }
    }
  }
  
  func configure() {
    tableView.register(GameView.self, forCellReuseIdentifier: GameView.identifier)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = 136

    self.view.addSubview(labelTitle)
    self.view.addSubview(tableView)
    self.view.addSubview(searchBar)
    
    configureLabelTitle()
    configureSearchBar()
    configureTableView()
  }
  
  func configureLabelTitle() {
    labelTitle.snp.makeConstraints { (make) in
        make.top.equalToSuperview().offset(90)
        make.left.equalTo(view).offset(16)
        make.right.equalTo(view).offset(-16)
    }
    self.labelTitle.font = .boldSystemFont(ofSize: 34)
    self.labelTitle.text = "GAMES"
  }
  
  func configureSearchBar() {
    searchBar.snp.makeConstraints { make in
        make.top.equalTo(labelTitle.snp.bottom).offset(9)
        make.leading.trailing.equalToSuperview()
    }
    searchBar.placeholder = "Search for the games"
  }
  
  func configureTableView() {
    tableView.snp.makeConstraints { make in
        make.top.equalTo(searchBar.snp.bottom)
          make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
          make.left.equalTo(view.snp.left)
          make.right.equalTo(view.snp.right)
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
        if let urlString = result?.results[indexPath.row].backgroundImage {
          let url = URL(string: urlString)
          cell.gameImage.kf.setImage(with: url)
        }
        return cell
    }
}
