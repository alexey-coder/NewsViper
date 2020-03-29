//
//  FeedPresenterProtocol.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

protocol FeedPresenterProtocol: class {
    var router: FeedRouterProtocol? { get set }
    var interactor: FeedInteractorProtocol? { get set }
    var view: FeedViewProtocol? { get set }
    
    func viewDidAppear()
    func getHeightFor(row: Int) -> CGFloat
    func getNumberOfRows() -> Int
    func getViewModel(by indexPath: IndexPath) -> FeedViewModelProtocol?
    func didRowSelected(_ row: Int)
    func getModes() -> [String]
    func didChangeMode(by value: Int)
    var isFullMode: Bool { get set }
    func switchMode()
}
