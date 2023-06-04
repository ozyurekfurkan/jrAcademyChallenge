//
//  LoadingFooterView.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 4.06.2023.
//

import UIKit
import SnapKit

class LoadingFooterView: UIView {
  private let labelView: UILabel = UILabel()
  private let activityIndicatorView: UIActivityIndicatorView = {
    let indicatorView = UIActivityIndicatorView(style: .gray)
    indicatorView.startAnimating()
    return indicatorView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupViews()
  }
  
  private func setupViews() {
    addSubview(labelView)
    addSubview(activityIndicatorView)
    
    activityIndicatorView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.width.equalTo(20)
      make.height.equalTo(20)
      make.centerX.equalToSuperview()
    }
    
    labelView.snp.makeConstraints { make in
      make.top.equalTo(activityIndicatorView.snp.bottom).offset(6)
      make.bottom.equalToSuperview().offset(10)
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    labelView.font = UIFont.systemFont(ofSize: 13)
    labelView.text = "loading"
    labelView.textColor = .gray
  }
}
