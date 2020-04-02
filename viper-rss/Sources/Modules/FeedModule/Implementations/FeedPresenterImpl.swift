//
//  FeedPresenterImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

enum Modes: CaseIterable, CustomStringConvertible {
    case simple
    case full
    
    var description: String {
        switch self {
        case .simple:
            return LocalizedImpl<FeedModuleLocalizedKeys>(.simpleMode).text
        case .full:
            return LocalizedImpl<FeedModuleLocalizedKeys>(.fullMode).text
        }
    }
}

enum Sources: CaseIterable, CustomStringConvertible {
    case lenta
    case gazeta
    
    var description: String {
        switch self {
        case .lenta:
            return "lenta"
        case .gazeta:
            return "gazeta"
        }
    }
    
    func getLink() -> String {
        switch self {
        case .lenta:
            return "https://lenta.ru/rss/"
        case .gazeta:
            return "https://www.gazeta.ru/export/rss/lenta.xml"
        }
    }
}

class FeedPresenterImpl {
    var router: FeedRouterProtocol?
    var interactor: FeedInteractorProtocol?
    weak var view: FeedViewProtocol?
    
    private let feedCellLayoutCalculator: LayoutCalculatorProtocol
    private let userDefaultsStorage: UserDefaultsStorageProtocol
    private var isFullMode: Bool = false
    private var viewModels: [FeedViewModelImpl]?
    private var models: [RSSEntity]?
    private var timer: Timer?
    private var seconds: Int?
    private let defaultSeconds = 3
    
    init(
        feedCellLayoutCalculator: LayoutCalculatorProtocol,
        userDefaultsStorage: UserDefaultsStorageProtocol) {
        self.feedCellLayoutCalculator = feedCellLayoutCalculator
        self.userDefaultsStorage = userDefaultsStorage
    }
    
    private func retrieveNetworkData() {
        DispatchQueue.global().async {
            self.interactor?.requestEntities(from: [.gazeta, .lenta])
        }
    }
    
    private func startTimer() {
        let secondsFromSettings = userDefaultsStorage.savedTimerValue()
        seconds = secondsFromSettings == nil ? defaultSeconds : secondsFromSettings
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            self?.update()
        })
    }
    
    private func update() {
        guard var seconds = self.seconds else {
            return
        }
        seconds -= 1
        self.seconds = seconds
        print("timer = \(seconds)")
        if seconds <= 0 {
            stopTimer()
            startTimer()
            retrieveNetworkData()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
}

extension FeedPresenterImpl: FeedPresenterProtocol {
    
    func present(entities: [RSSEntity]) {
        entities.forEach {
            prepareViewModel(for: $0)
        }
    }
    
    func store(entity: RSSEntity) {
        interactor?.saveInStorage(entity: entity)
    }
    
    private func prepareViewModel(for entity: RSSEntity) {
        let sizes = self.feedCellLayoutCalculator.mesureCellHeight(
            title: entity.title, description: entity.description, date: entity.pubdate)
        
        let viewModel = FeedViewModelImpl(
            newsTitleText: entity.title,
            newsShortDescription: entity.description,
            date: entity.pubdate,
            isFullMode: self.isFullMode,
            cellHeightFullMode: sizes.cellHeightFullMode,
            cellHeightSimpleMode: sizes.cellHeightSimpleMode,
            titleHeight: sizes.titleHeight,
            descriptionHeight: sizes.descriptionHeight,
            source: entity.source,
            link: entity.link,
            imgLink: entity.imgUrl,
            isReaded: entity.isReaded)
        save(model: entity)
        save(viewModel: viewModel)
        view?.reloadData()
    }
    
    private func save(model: RSSEntity) {
        if models == nil {
            models = [model]
        } else {
            models?.append(model)
        }
    }
    
    private func save(viewModel: FeedViewModelImpl) {
        if viewModels == nil {
            viewModels = [viewModel]
        } else {
            viewModels?.append(viewModel)
        }
    }
    
    func showAlert(message: String) {
        DispatchQueue.main.async {
            self.view?.showAlert(with: message)
        }
    }
    
    func viewDidLoad() {
        interactor?.subscribeForUpdates()
        interactor?.getAllModelsFromStore()
        retrieveNetworkData()
    }
    
    func viewWillAppear() {
        startTimer()
        view?.reloadData()
    }
    
    func viewWillDissaper() {
        stopTimer()
    }
    
    func getModes() -> [String] {
        var modes = [String]()
        Modes.allCases.forEach {
            modes.append($0.description)
        }
        return modes
    }
    
    func getCurrentMode() -> Bool {
        return isFullMode
    }
    
    func switchMode() {
        isFullMode.toggle()
        viewModels?.forEach {
            $0.isFullMode.toggle()
        }
        view?.reloadData()
    }
    
    func didChangeMode(by value: Int) {
        self.isFullMode = value == 1 ? false : true
    }
    
    func getHeightFor(row: Int) -> CGFloat {
        guard let viewModels = self.viewModels else {
            return 0
        }
        if isFullMode {
            return viewModels[row].cellHeightFullMode
        } else {
            return viewModels[row].cellHeightSimpleMode
        }
    }
    
    func getNumberOfRows() -> Int {
        return viewModels?.count ?? 0
    }
    
    func getViewModel(by indexPath: IndexPath) -> FeedViewModelProtocol? {
        return viewModels?[indexPath.row]
    }
    
    func didRowSelected(row: Int) {
        guard let model = models?[row] else {
            return
        }
        interactor?.update(entity: model)
        viewModels?[row].isReaded = true
        router?.presentDetails(with: model.link)
    }
}
