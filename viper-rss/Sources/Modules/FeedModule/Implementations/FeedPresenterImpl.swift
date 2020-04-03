//
//  FeedPresenterImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

private struct Metrics {
    struct Values {
        static let defaultSeconds = Constants.DefaultValues.timerDefault
    }
    
    struct Patterns {
        static let sourceDatePattern = Constants.Patterns.sourceDatePattern
        static let customPattern = Constants.Patterns.customPattern
    }
}

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

enum Sources: String, CaseIterable, CustomStringConvertible {
    case lenta
    case gazeta
    
    static let allValues: [String] = [lenta.description, gazeta.description]
    
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
    private let defaultSeconds = Metrics.Values.defaultSeconds
    
    private var filter: Sources? {
        guard let value = userDefaultsStorage.savedSourceValue() else {
            return nil
        }
        return Sources(rawValue: value)
    }
    
    init(
        feedCellLayoutCalculator: LayoutCalculatorProtocol,
        userDefaultsStorage: UserDefaultsStorageProtocol) {
        self.feedCellLayoutCalculator = feedCellLayoutCalculator
        self.userDefaultsStorage = userDefaultsStorage
    }
    
    func retrieveNetworkData() {
        let source: [Sources]
        if let filter = filter {
            source = [filter]
        } else {
            source = [.gazeta, .lenta]
        }
        view?.showIndicator()
        interactor?.requestEntities(from: source)
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
        if seconds <= 0 {
            stopTimer()
            startTimer()
            retrieveNetworkData()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
    
    private func foratDate(dateToConvert: String) -> String {
        let fromFormatter = DateFormatter()
        fromFormatter.dateFormat = Metrics.Patterns.sourceDatePattern
        
        let toFormetter = DateFormatter()
        toFormetter.dateFormat = Metrics.Patterns.customPattern
        
        if let date = fromFormatter.date(from: dateToConvert) {
            return toFormetter.string(from: date)
        } else {
            print("There was an error decoding the string")
            return dateToConvert
        }
    }
}

extension FeedPresenterImpl: FeedPresenterProtocol {
    func createViewModelsFromScratch(with entities: [RSSEntity]) {
        models?.removeAll()
        viewModels?.removeAll()
        guard let filter = filter else {
            entities.forEach {
                prepareViewModel(for: $0)
            }
            view?.reloadData()
            return
        }
        entities.filter { $0.source == filter.description }.forEach {
            prepareViewModel(for: $0)
        }
        self.view?.hideIndicator()
        
        view?.reloadData()
    }
    
    func createNewViewModel(with entity: RSSEntity) {
        prepareViewModel(for: entity)
        self.view?.hideIndicator()
        
        view?.reloadData()
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
            date: foratDate(dateToConvert: entity.pubdate),
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
    }
    
    func viewWillAppear() {
        startTimer()
        retrieveNetworkData()
        interactor?.getAllModelsFromStore(with: filter)
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
        router?.presentDetails(with: model.link)
    }
}
