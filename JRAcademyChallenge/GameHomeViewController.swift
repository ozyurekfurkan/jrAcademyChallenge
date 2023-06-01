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

protocol GamesOutPut {
  func saveDatas(values: [GameModel])
}

class GameHomeViewController: UIViewController {
  
  private let tableView: UITableView = UITableView()
  private let labelTitle: UILabel = UILabel()
  private let searchBar = UISearchBar()
  private lazy var results: [GameModel] = []
  
  var viewModel: GameHomeViewModel = GameHomeViewModel()
  
  override func viewDidLoad() {
    self.view.backgroundColor = .white
    fetchGameData()
  }
  
  func fetchGameData() {
      configure()
      viewModel.setDelegate(output: self)
      viewModel.fetchItems()

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

extension GameHomeViewController: GamesOutPut {
    func saveDatas(values: [GameModel]) {
        results = values
        tableView.reloadData()
    }
}

extension GameHomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameView.identifier, for: indexPath) as! GameView
        cell.configureCell(model: results[indexPath.row])
        return cell
    }
}
