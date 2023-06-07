//
//  DetailViewController.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 6.06.2023.
//

import UIKit
import Carbon
import SnapKit
import CoreData

protocol GameDetailOutPut {
  func saveDataAndRender(values: GameDetailModel)
}

class DetailViewController: UIViewController {
  
  private let tableView: UITableView = UITableView()
  var viewModel: DetailViewModel = DetailViewModel()
  var gameID: Int?
  override func viewDidLoad() {
    super.viewDidLoad()
    renderer.target = tableView
    tableView.isScrollEnabled = false
    viewModel.setDelegate(output: self)
    viewModel.gameIDString = gameID?.description
    let favoriteButton = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(favoriteButtonTapped))
    navigationItem.rightBarButtonItem = favoriteButton
    fetchGameDetail()
    
  }
  
  @objc func favoriteButtonTapped() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    guard let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContext) else {
      print("Hata: Favori varlığı bulunamadı.")
      return
    }
    var combinedGenres: String?
    if let genres = viewModel.game?.genres{
      let genreNames = genres.compactMap { $0.name }
      combinedGenres = genreNames.joined(separator: ", ")
    }
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
    fetchRequest.predicate = NSPredicate(format: "name == %@ AND image == %@ AND metacritic == %d AND genres == %@", viewModel.game?.name ?? "", viewModel.game?.backgroundImage ?? "", viewModel.game?.metacritic ?? 0, combinedGenres ?? "")
    do {
      let results = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
      print("Favori arama hatası: \(error), \(error.userInfo)")
    }
    let favorite = NSManagedObject(entity: entity, insertInto: managedContext)
    favorite.setValue(viewModel.game?.name, forKey: "name")
    favorite.setValue(viewModel.game?.backgroundImage, forKey: "image")
    favorite.setValue(viewModel.game?.metacritic, forKey: "metacritic")
    favorite.setValue(combinedGenres, forKey: "genres")
    do {
      try managedContext.save()
      navigationItem.rightBarButtonItem?.title = "Favourited"
    } catch let error as NSError {
      print("Favori kaydedilirken hata oluştu: \(error), \(error.userInfo)")
    }
    
  }
  
  private let renderer = Renderer(
    adapter: UITableViewAdapter(),
    updater: UITableViewUpdater()
  )
  
  func fetchGameDetail() {
    self.view.addSubview(tableView)
    configureTableView()
    viewModel.fetchDetail()
  }
  
  func render() {
    
    var cellNode: [CellNode] = []
    
    cellNode.append(CellNode(GameDetailComponent(game: viewModel.game)))
    
    let gameSection = Section(id: "gameSection", cells: cellNode)
    
    renderer.render(gameSection)
  }
  
  func configureTableView() {
    tableView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
    }
  }
  
}

extension DetailViewController: GameDetailOutPut {
  func saveDataAndRender(values: GameDetailModel) {
    render()
  }
}