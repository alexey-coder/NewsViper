//
//  FeedPresenterProtocol.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

protocol FeedPresenter: class {
    var router: FeedRouter { get set }
    var interactor: FeedInteractor { get set }
    var view: FeedView? { get set }
    
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDissaper()
    func getHeightFor(row: Int) -> CGFloat
    func getNumberOfRows() -> Int
    func getViewModel(by indexPath: IndexPath) -> FeedViewModel?
    func didRowSelected(row: Int)
    func getModes() -> [String]
    func didChangeMode(by value: Int)
    func getCurrentMode() -> Bool
    func switchMode()
    func showAlert(message: String)
    func retrieveNetworkData()
    
    func createViewModelsFromScratch(with entities: [RSSEntity])
    func createNewViewModel(with entity: RSSEntity)
}
