//
//  EmptyView.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 6.06.2023.
//

import UIKit
import Carbon
import SnapKit
import Kingfisher

struct GameDetailComponent: IdentifiableComponent {
  var game: GameDetailModel?
  var id: String = "gameDetail"
  
  func shouldContentUpdate(with next: GameDetailComponent) -> Bool {
    return false
  }
  
  func render(in content: GameDetailView) {
    if let urlString = game?.backgroundImage {
      let url = URL(string: urlString)
      let resizeProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 375, height: 291))
      let imageLoadingOptions: KingfisherOptionsInfo = [
        .processor(resizeProcessor),
        .scaleFactor(UIScreen.main.scale),
        .transition(.fade(0.2)),
      ]
      content.gameImage.kf.setImage(with: url,options: imageLoadingOptions)
    }
    content.gameTitle.text = game?.name
    content.gameDescriptionTitle.text = "Game Description"
    content.gameDescriptionText.text = game?.description
    content.gameDescriptionText.font = UIFont.systemFont(ofSize: 10)
    content.gameDescriptionText.numberOfLines = 4
    if let gamedecription = game?.description {
      let attributedText = NSMutableAttributedString(string: gamedecription)
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineSpacing = 10

      attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
      content.gameDescriptionText.attributedText = attributedText
      content.gameDescriptionText.lineBreakMode = .byTruncatingTail
    }
    if let redditURL = game?.redditUrl, let webURL = game?.website {
      content.redditURL = redditURL
      content.webURL = webURL
      content.setupGestures()
    }
  }
  
  func referenceSize(in bounds: CGRect) -> CGSize? {
    return CGSize(width: bounds.width, height: bounds.height)
  }
  
  func renderContent() -> GameDetailView {
    return GameDetailView()
  }
}

class GameDetailView: UIView {
  var gameImage: UIImageView = UIImageView()
  var gameTitle: UILabel = UILabel()
  var gameDescriptionTitle: UILabel = UILabel()
  var gameDescriptionText: UILabel = UILabel()
  var visitReddit: UILabel = UILabel()
  var visitWebsite: UILabel = UILabel()
  var firstline: UIView = UIView()
  var secondline: UIView = UIView()
  var thirdline: UIView = UIView()
  var webURL: String?
  var redditURL: String?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
    setupGestures()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupGestures() {
      visitReddit.isUserInteractionEnabled = true
      let tapReddit = UITapGestureRecognizer(target: self, action: #selector(visitRedditTapped))
      visitReddit.addGestureRecognizer(tapReddit)
      
      visitWebsite.isUserInteractionEnabled = true
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(visitWebsiteTapped))
      visitWebsite.addGestureRecognizer(tapGesture)
      
      if let urlWeb = webURL {
        let attributedString = NSMutableAttributedString(string: "Visit website")
        attributedString.addAttribute(.link, value: urlWeb, range: NSRange(location: 0, length: "Visit website".count))
        visitWebsite.attributedText = attributedString
        visitWebsite.textColor = .black
      }
    
      if let urlReddit = redditURL {
          let attributedString = NSMutableAttributedString(string: "Visit reddit")
        attributedString.addAttribute(.link, value: urlReddit, range: NSRange(location: 0, length: "Visit reddit".count))
          visitReddit.attributedText = attributedString
      }
  }
  @objc func visitRedditTapped() {
    if let urlReddit = redditURL, let url = URL(string: urlReddit) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
  @objc func visitWebsiteTapped() {
    if let urlReddit = webURL, let url = URL(string: urlReddit) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
  
  func configure() {
    self.addSubview(gameImage)
    self.addSubview(gameTitle)
    self.addSubview(gameDescriptionTitle)
    self.addSubview(gameDescriptionText)
    self.addSubview(firstline)
    self.addSubview(secondline)
    self.addSubview(thirdline)
    self.addSubview(visitReddit)
    self.addSubview(visitWebsite)
    
  
    gameImage.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide.snp.top)
      make.right.left.equalToSuperview().offset(0)
      make.height.equalTo(291)
    }
    gameTitle.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(232)
      make.left.equalTo(gameImage.snp.left).offset(16)
      make.right.equalTo(gameImage.snp.right).offset(-16)
      make.bottom.equalTo(gameImage.snp.bottom).offset(-16)
    }
    gameTitle.textAlignment = .right
    gameTitle.font = UIFont.boldSystemFont(ofSize: 36)
    gameTitle.textColor = .white
    
    gameDescriptionTitle.snp.makeConstraints { make in
      make.top.equalTo(gameImage.snp.bottom).offset(16)
      make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-16)
      make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(16)
    }
    gameDescriptionTitle.font = UIFont.systemFont(ofSize: 20)
    
    gameDescriptionText.snp.makeConstraints { make in
      make.top.equalTo(gameDescriptionTitle.snp.bottom).offset(16)
      make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-16)
      make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(16)
    }
    
    visitReddit.snp.makeConstraints { make in
      make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-16)
      make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(16)
      make.top.equalTo(firstline.snp.bottom).offset(16)
      make.height.equalTo(25)
    }
    visitReddit.layoutIfNeeded()
    visitReddit.sizeToFit()
    visitReddit.textAlignment = .left
    visitReddit.font = UIFont.systemFont(ofSize: 17)
    visitWebsite.snp.makeConstraints { make in
      make.top.equalTo(secondline.snp.bottom).offset(16)
      make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-16)
      make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(16)
      make.height.equalTo(25)
    }
    visitWebsite.layoutIfNeeded()
    visitWebsite.sizeToFit()
    visitWebsite.textAlignment = .left
    visitWebsite.font = UIFont.systemFont(ofSize: 17)
    
    firstline.snp.makeConstraints { make in
      make.top.equalTo(gameDescriptionText.snp.bottom).offset(16)
      make.right.equalToSuperview()
      make.left.equalTo(visitReddit.snp.left)
      make.height.equalTo(0.5)
    }
    firstline.alpha = 0.5
    firstline.backgroundColor = .lightGray
    
    secondline.snp.makeConstraints { make in
      make.top.equalTo(visitReddit.snp.bottom).offset(16)
      make.right.equalToSuperview()
      make.left.equalTo(visitReddit.snp.left)
      make.height.equalTo(0.5)
    }
    secondline.alpha = 1
    secondline.backgroundColor = .lightGray
    
    thirdline.snp.makeConstraints { make in
      make.top.equalTo(visitWebsite.snp.bottom).offset(16)
      make.right.equalToSuperview()
      make.left.equalTo(visitReddit.snp.left)
      make.height.equalTo(0.5)
    }
    thirdline.alpha = 0.5
    thirdline.backgroundColor = .lightGray
  }
  
}
