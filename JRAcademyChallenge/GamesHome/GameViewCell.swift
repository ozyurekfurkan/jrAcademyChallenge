//
//  GameView.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 31.05.2023.
//

import Foundation
import SnapKit
import Carbon
import Kingfisher

struct GameViewCellComponent: IdentifiableComponent {
  
  func shouldContentUpdate(with next: GameViewCellComponent) -> Bool {
    return false
  }
  
  var game: GameModel
  var id: String {
    game.name
  }
  func render(in content: GameViewCell) {
    content.gameTitle.text = game.name
    content.metaCriticLabel.text = "metacritic: "
    if let genres = game.genres {
      let genreNames = genres.compactMap { $0.name }
      if !genreNames.isEmpty {
        let joinedGenreNames = genreNames.joined(separator: ", ")
        content.gameGenre.text = joinedGenreNames
      } else {
        content.gameGenre.text = "N/A"
      }
    }
    if let metacritic = game.metacritic {
      content.metaCriticScoreLabel.text = metacritic.description
    } else {
      content.metaCriticScoreLabel.text = "N/A"
    }
   
    if let urlString = game.backgroundImage {
      let url = URL(string: urlString)
      let resizeProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 120, height: 104))
      let imageLoadingOptions: KingfisherOptionsInfo = [
          .processor(resizeProcessor),
          .scaleFactor(UIScreen.main.scale),
          .transition(.fade(0.2)),
      ]
      content.gameImage.kf.setImage(with: url, options: imageLoadingOptions)
    }
    content.gameID = game.id ?? 0
    
  }
  
  func referenceSize(in bounds: CGRect) -> CGSize? {
    return CGSize(width: bounds.width, height: 136)
  }
  
  func renderContent() -> GameViewCell {
    return GameViewCell()
  }
}

final class GameViewCell: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.gameID = 0
    self.viewController = GameHomeViewController()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    self.addGestureRecognizer(tapGesture)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    fatalError("init(coder:) has not been implemented")
  }
  var gameID: Int?
  var viewController: GameHomeViewController?
  var gameTitle: UILabel = UILabel()
  var metaCriticLabel: UILabel = UILabel()
  var metaCriticScoreLabel: UILabel = UILabel()
  var gameGenre: UILabel = UILabel()
  var gameImage: UIImageView = UIImageView()
  
  @objc private func handleTap() {
    guard let viewController = viewController else {
       return
     }
    viewController.gameID = gameID
    viewController.navigateToDetail()
   }
  
  func configure() {
    
    self.addSubview(gameTitle)
    self.addSubview(metaCriticLabel)
    self.addSubview(metaCriticScoreLabel)
    self.addSubview(gameGenre)
    self.addSubview(gameImage)
    gameTitle.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(16)
      make.right.equalToSuperview().offset(-16)
      make.left.equalTo(gameImage.snp.right).offset(16)
    }
    metaCriticLabel.snp.makeConstraints { make in
      make.left.equalTo(gameTitle.snp.left)
      make.width.equalTo(76)
      make.height.equalTo(16)
  
    }
    metaCriticScoreLabel.snp.makeConstraints { make in
      make.left.equalTo(metaCriticLabel.snp.right)
      make.top.bottom.equalTo(metaCriticLabel)
      make.right.equalToSuperview().offset(-96)
      make.height.equalTo(metaCriticLabel.snp.height)
    }
    gameGenre.snp.makeConstraints { make in
      make.top.equalTo(metaCriticLabel.snp.bottom).offset(8)
      make.left.equalTo(metaCriticLabel.snp.left)
      make.bottom.equalTo(gameImage.snp.bottom).offset(6)
      make.height.equalTo(16)
      make.width.equalTo(gameTitle.snp.width)
    }
    gameImage.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(16)
      make.top.equalToSuperview().offset(16)
      make.bottom.equalToSuperview().offset(-16)
      make.height.equalTo(104)
      make.width.equalTo(120)
    }
    gameTitle.font = UIFont.boldSystemFont(ofSize: 20)
    gameTitle.numberOfLines = 0
    metaCriticLabel.font = UIFont.boldSystemFont(ofSize: 14)
    metaCriticScoreLabel.font = UIFont.boldSystemFont(ofSize: 18)
    gameGenre.font = UIFont.systemFont(ofSize: 13)
    gameGenre.textColor = .lightGray
    metaCriticScoreLabel.textColor = .red
    backgroundColor = .white
  }
}
