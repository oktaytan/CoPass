//
//  CircularImageView.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 1.07.2023.
//

import UIKit

class CoCircularImageView: UIImageView {

  override func layoutSubviews() {
    super.layoutSubviews()
    
    clipsToBounds = true
    layer.cornerRadius = frame.size.height / 2
  }
  
}
