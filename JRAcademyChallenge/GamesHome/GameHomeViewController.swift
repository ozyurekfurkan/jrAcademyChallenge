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
import Carbon

protocol GamesOutPut {
  func saveDataAndRender(values: [GameModel])
}

class GameHomeViewController: UIViewController {
  
  private let tableView: UITableView = UITableView()
  private let searchBar = UISearchBar()
  var searchString: String = ""
  private var results: [GameModel] = []
  var isLoadingNextPage = false
  
  var viewModel: GameHomeViewModel = GameHomeViewModel()
  
  override func viewDidLoad() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    view.addGestureRecognizer(tapGesture)
    renderer.target = tableView
    fetchGameData()
  }
  
  func fetchGameData() {
      configure()
      viewModel.setDelegate(output: self)
      viewModel.fetchItems()

  }
  
  private let renderer = Renderer(
      adapter: UITableViewAdapter(),
      updater: UITableViewUpdater()
  )
  
  func render() {
    
    var cellNode: [CellNode] = []
    
    for game in results {
      cellNode.append(CellNode(GameViewCellComponent(game: game)))
    }
    
    let gameSection = Section(id: "gameSection", cells: cellNode)
    renderer.render(gameSection)
  }
  
  func configure() {
    searchBar.delegate = self
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
    func saveDataAndRender(values: [GameModel]) {
        results.append(contentsOf: values)
        render()
    }
}

extension GameHomeViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let searchText = searchBar.text?.replacingOccurrences(of: " ", with: "%20"), searchText.count >= 3 {
        results = []
        viewModel.searchItems(search: searchText)
    }
  }
  @objc private func handleTap() {
       view.endEditing(true) // Close the keyboard
   }
}
