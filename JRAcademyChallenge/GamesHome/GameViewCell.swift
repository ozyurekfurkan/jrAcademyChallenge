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
    return true
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
      content.metaCriticScoreLabel.text = game.metacritic?.description
    } else {
      content.metaCriticScoreLabel.text = "N/A"
    }
   
    if let urlString = game.backgroundImage {
      let url = URL(string: urlString)
      content.gameImage.kf.setImage(with: url)
    }
    
  }
  
  func referenceSize(in bounds: CGRect) -> CGSize? {
    return CGSize(width: bounds.width, height: 134)
  }
  
  func renderContent() -> GameViewCell {
    return GameViewCell()
  }
  
}

class GameViewCell: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    fatalError("init(coder:) has not been implemented")
  }
  var gameTitle: UILabel = UILabel()
  var metaCriticLabel: UILabel = UILabel()
  var metaCriticScoreLabel: UILabel = UILabel()
  var gameGenre: UILabel = UILabel()
  var gameImage: UIImageView = UIImageView()
  
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
      make.bottom.equalTo(metaCriticLabel.snp.top)
    }
    metaCriticLabel.snp.makeConstraints { make in
      make.top.equalTo(gameTitle.snp.bottom).offset(41)
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
      make.top.equalTo(metaCriticLabel.snp.bottom).offset(12)
      make.left.equalTo(metaCriticLabel.snp.left)
      make.bottom.equalTo(gameImage.snp.bottom)
      make.height.equalTo(16)
      make.width.equalTo(gameTitle.snp.width)
    }
    gameImage.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(16)
      make.top.equalToSuperview().offset(16)
      make.bottom.equalToSuperview().offset(-16)
      make.height.equalTo(120)
      make.width.equalTo(104)
    }
    gameTitle.font = UIFont.boldSystemFont(ofSize: 20)
    gameTitle.numberOfLines = 0
    metaCriticLabel.font = UIFont.boldSystemFont(ofSize: 14)
    metaCriticScoreLabel.font = UIFont.boldSystemFont(ofSize: 18)
    gameGenre.font = UIFont.boldSystemFont(ofSize: 13)
    gameGenre.textColor = .lightGray
    metaCriticScoreLabel.textColor = .red
    backgroundColor = .white
  }
  
  func configureCell(model: GameModel) {

  }
}
