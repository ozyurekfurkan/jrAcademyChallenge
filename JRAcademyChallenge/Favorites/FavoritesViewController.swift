//
//  FavoritesViewController.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 4.06.2023.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {
  var managedObjectContext: NSManagedObjectContext!
  var favoriteGameList: [GameModel] = []
  var game: GameModel? = GameModel(
    id: nil,
    name: "",
    backgroundImage: nil,
    metacritic: nil,
    genres: nil
  )
  var isEmpty: Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")

        do {
            let count = try managedObjectContext.count(for: fetchRequest)
            return count == 0
        } catch {
            return true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        fetchEntities()
    }
  func fetchEntities() {
          let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
          
          do {
              let result = try managedObjectContext.fetch(fetchRequest)
            for favorite in result {
              if let name = favorite.name,
                 let image = favorite.image
                {
                game?.name = name
                game?.backgroundImage = image
              }
              if let game = game {  // Check if game is not nil
                favoriteGameList.append(game)
              }
              print(favoriteGameList)
            }
          } catch {
              print("Failed to fetch entities: \(error)")
          }
      }
}
