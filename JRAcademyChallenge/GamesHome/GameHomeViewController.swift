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
  func saveDataAndRender()
}

class GameHomeViewController: UIViewController {
  
  private let tableView: UITableView = UITableView()
  private let searchBar = UISearchBar()
  var searchString: String = ""
  var gameID: Int?
  var isLoadingNextPage = false
  var viewModel: GameHomeViewModel = GameHomeViewModel()
  
  
  private let renderer = Renderer(
      adapter: CustomTableViewAdapter(),
      updater: UITableViewUpdater()
  )
  
  override func viewDidLoad() {
    renderer.target = tableView
    fetchGameData()
  }
  
  func fetchGameData() {
      configure()
      viewModel.setDelegate(output: self)
      viewModel.fetchItems()
  }

  func render() {
    
    var cellNode: [CellNode] = []
    
    for game in viewModel.games {
      cellNode.append(CellNode(GameViewCellComponent(game: game)))
    }
    if viewModel.games.count > 5 {
      tableView.tableFooterView = LoadingFooterView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
    } else {
      tableView.tableFooterView = nil
    }
    let gameSection = Section(id: "gameSection", cells: cellNode)
    renderer.render(gameSection)
  }
  
  func renderEmptyView() {
    
    var cellNode: [CellNode] = []
    
    cellNode.append(CellNode(EmptyViewComponent()))
    tableView.tableFooterView = nil
    let emptySection = Section(id: "emptySection", cells: cellNode)
    renderer.render(emptySection)
  }
  
  func configure() {
    searchBar.delegate = self
    self.view.addSubview(tableView)
    self.view.addSubview(searchBar)
    configureSearchBar()
    configureTableView()
  }
  
  func navigateToDetail() {
    let vc = DetailViewController()
    vc.gameID = self.gameID
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
      navigationController.pushViewController(vc,animated: true)
    }
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
  }
}

extension GameHomeViewController: GamesOutPut {
    func saveDataAndRender() {
        render()
    }
}

extension GameHomeViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let searchText = searchBar.text?.replacingOccurrences(of: " ", with: "%20"), searchText.count >= 3 {
        viewModel.games.removeAll()
        renderEmptyView()
        viewModel.searchItems(search: searchText)
    }
    searchBar.resignFirstResponder()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     if searchText.isEmpty {
       viewModel.games.removeAll()
       renderEmptyView()
       viewModel.searchRemoved = true //reset url to base url
       viewModel.fetchItems()
     } else if let searchText = searchBar.text?.replacingOccurrences(of: " ", with: "%20"), searchText.count >= 3 {
       viewModel.games.removeAll()
       viewModel.searchItems(search: searchText)
     } else {
       renderEmptyView()
     }
  }

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
      searchBar.showsCancelButton = true
      viewModel.games.removeAll()
  }
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = false
    if searchBar.text == "" {
      viewModel.searchRemoved = true
      viewModel.games.removeAll()
      viewModel.fetchItems()
    }
  }
}

class CustomTableViewAdapter: UITableViewAdapter {
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
          print("Notification geldi")
          NotificationCenter.default.post(name: NSNotification.Name("runFetchItems"), object: nil)
        }
    }
}
