//
//  EmptyView.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 6.06.2023.
//

import UIKit
import Carbon

struct EmptyViewComponent: IdentifiableComponent {
  
  var id: String = "empty"
  
  func shouldContentUpdate(with next: EmptyViewComponent) -> Bool {
    return false
  }
  
  func render(in content: Empty) {
  }
  
  func referenceSize(in bounds: CGRect) -> CGSize? {
    return CGSize(width: bounds.width, height: 41)
  }
  
  func renderContent() -> Empty {
    return Empty()
  }
}

class Empty: UIView {
  var emptyLabel: UILabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure() {
    self.addSubview(emptyLabel)
    
    emptyLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(36)
      make.right.left.equalToSuperview().offset(70)
    }
    
    emptyLabel.text = "No game has been searched."
    emptyLabel.font = UIFont.boldSystemFont(ofSize: 18)
  }
}
