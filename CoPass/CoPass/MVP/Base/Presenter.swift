//
//  BasePresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 19.05.2023.
//

import Foundation

public protocol Presenter {
  func viewDidLoad()
  func viewWillAppear()
  func viewDidAppear()
  func viewWillDisappear()
  func viewDidDisappear()
}

public extension Presenter {
  func viewWillAppear() {}
  func viewDidAppear() {}
  func viewWillDisappear() {}
  func viewDidDisappear() {}
}
