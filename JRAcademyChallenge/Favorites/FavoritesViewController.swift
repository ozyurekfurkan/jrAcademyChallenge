//
//  FavoritesViewController.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 4.06.2023.
//

import UIKit
import CoreData
import Foundation
import Carbon
import SnapKit

class FavoritesViewController: UIViewController {
  private let tableView = UITableView()
  var managedObjectContext: NSManagedObjectContext!
  var favoriteGameList: [GameModel] = []
  var game: GameModel? = GameModel(
    id: 0,
    name: "",
    backgroundImage: nil,
    metacritic: 0,
    genres: nil
  )
  var isEmpty: Bool {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
    
    do {
      let cout = try managedObjectContext.count(for: fetchRequest)
      return cout == 0
    } catch {
      return true
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    renderer.target = tableView
    renderer.adapter.favouritesController = self
    self.view.addSubview(tableView)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    managedObjectContext = appDelegate.persistentContainer.viewContext
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if !isEmpty {
      fetchEntities()
    } else {
      renderEmptyView()
    }
  }
  
  private let renderer = Renderer(
    adapter: CustomFavoriteTableViewAdapter(),
    updater: UITableViewUpdater()
  )
  
  func render() {
    var cellNode: [CellNode] = []
    
    for game in favoriteGameList {
      cellNode.append(CellNode(GameViewCellComponent(game: game)))
    }
    
    let gameSection = Section(id: "gameSection", cells: cellNode)
    renderer.render(gameSection)
  }
  
  func renderEmptyView() {
    var cellNode: [CellNode] = []
    
    cellNode.append(CellNode(EmptyViewComponent()))
    
    let emptySection = Section(id: "emptySection", cells: cellNode)
    renderer.render(emptySection)
  }
  
  func fetchEntities() {
    self.favoriteGameList = []
    let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
    
    do {
      let result = try managedObjectContext.fetch(fetchRequest)
      
      for favorite in result {
        if let name = favorite.name,
          let image = favorite.image,
          let genres = favorite.genres {
          let genresArray = genres.components(separatedBy: ",")
          let genreObjects = genresArray.compactMap {
            Genre(name: $0.trimmingCharacters(in: .whitespacesAndNewlines))
          }
          game?.name = name
          game?.id = Int(favorite.id)
          game?.metacritic = Int(favorite.metacritic)
          game?.backgroundImage = image
          game?.genres = genreObjects
        }
        if let game = game {
          favoriteGameList.append(game)
        }
        print(favoriteGameList)
      }
      configureTableView()
      render()
    } catch {
      print("Failed to fetch entities: \(error)")
    }
  }
  
  func configureTableView() {
    tableView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
      make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
    }
    tableView.separatorStyle = .none
  }
}

class CustomFavoriteTableViewAdapter: UITableViewAdapter {
  weak var favouritesController: FavoritesViewController?
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      let managedObjectContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
      fetchRequest.predicate = NSPredicate(format: "id == %d", favouritesController?.favoriteGameList[indexPath.row].id ?? "")
      do {
        let results = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
        if let object = results.first {
          managedObjectContext.delete(object)
          try managedObjectContext.save()
        }
      } catch let error as NSError {
        print("Could not delete data: \(error), \(error.userInfo)")
      }
      favouritesController?.fetchEntities()
      tableView.reloadData()
    }
  }
}
