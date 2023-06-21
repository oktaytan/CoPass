//
//  BaseView.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 19.05.2023.
//

import UIKit

class BaseView: UIView {
    
    var view: UIView!
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        xibSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      xibSetup()
    }
    
    private func xibSetup() {
      view = loadViewFromNib()
      view.frame = bounds
      view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
      return self.loadNib()
    }
}
