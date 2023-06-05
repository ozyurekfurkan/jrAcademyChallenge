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
  private let searchBar = UISearchBar()
  var searchString: String = ""
  private lazy var results: [GameModel] = []
  var isLoadingNextPage = false
  
  var viewModel: GameHomeViewModel = GameHomeViewModel()
  
  override func viewDidLoad() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    view.addGestureRecognizer(tapGesture)
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
    searchBar.delegate = self
    tableView.rowHeight = 136

    self.view.addSubview(tableView)
    self.view.addSubview(searchBar)
    
    configureSearchBar()
    configureTableView()
  }
  
  func configureSearchBar() {
    searchBar.snp.makeConstraints { make in
        make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
    tableView.separatorStyle = .none
    tableView.tableFooterView = LoadingFooterView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
  }
}

extension GameHomeViewController: GamesOutPut {
    func saveDatas(values: [GameModel]) {
        results.append(contentsOf: values)
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == results.count {
          viewModel.fetchItems()
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension GameHomeViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let searchText = searchBar.text?.replacingOccurrences(of: " ", with: "%20"), searchText.count >= 3 {
        results = []
        viewModel.searchItems(search: searchText)
        tableView.reloadData()
    }
  }
  @objc private func handleTap() {
       view.endEditing(true) // Close the keyboard
   }
}
