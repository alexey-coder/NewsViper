//
//  FeedPresenterImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

private enum Modes: CaseIterable, CustomStringConvertible {
    case simple
    case full
    
    static let allValues: [String] = [simple.description, full.description]
    
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
    case all
    case lenta
    case gazeta
    
    static let allValues: [String] = [all.description, lenta.description, gazeta.description]
    
    var description: String {
        switch self {
        case .lenta:
            return "lenta"
        case .gazeta:
            return "gazeta"
        case .all:
            return "all"
        }
    }
    
    func getLink() -> String {
        switch self {
        case .lenta:
            return "https://lenta.ru/rss/"
        case .gazeta:
            return "https://www.gazeta.ru/export/rss/lenta.xml"
        case .all:
            return ""
        }
    }
}

class FeedPresenterImpl {
    var router: FeedRouterProtocol?
    var interactor: FeedInteractorProtocol?
    weak var view: FeedViewProtocol?
    
    private let userDefaultsStorage: UserDefaultsStorageProtocol
    private var timerWorker: TimerWorkerProtocol
    private var isFullMode: Bool = false
    private var viewModels: [FeedViewModelProtocol]?
    private var models: [RSSEntity]?
    private let viewModelFactory: FeedViewModelFactoryProtocol
    
    private var filter: Sources? {
        guard let value = userDefaultsStorage.savedSourceValue() else {
            return .all
        }
        return Sources(rawValue: value)
    }
    
    init(
        viewModelFactory: FeedViewModelFactoryProtocol,
        userDefaultsStorage: UserDefaultsStorageProtocol,
        timerWorker: TimerWorkerProtocol) {
        self.viewModelFactory = viewModelFactory
        self.userDefaultsStorage = userDefaultsStorage
        self.timerWorker = timerWorker
        self.timerWorker.onOverTimer = { [weak self] in
            self?.retrieveNetworkData()
        }
    }
    
    func retrieveNetworkData() {
        let source: [Sources]
        guard let filter = filter else {
            return
        }
        switch filter {
        case .gazeta:
            source = [.gazeta]
        case .lenta:
            source = [.lenta]
        default:
            source = [.gazeta, .lenta]
        }
        interactor?.requestEntities(from: source)
    }
}

extension FeedPresenterImpl: FeedPresenterProtocol {
    func createViewModelsFromScratch(with entities: [RSSEntity]) {
        models?.removeAll()
        viewModels?.removeAll()
        guard let filter = filter else {
            return
        }
        switch filter {
        case .all:
            entities.forEach {
                prepareViewModel(for: $0)
            }
        case .gazeta, .lenta:
            entities.filter { $0.source == filter.description }.forEach {
                prepareViewModel(for: $0)
            }
        }
        view?.reloadData()
    }
    
    func createNewViewModel(with entity: RSSEntity) {
        prepareViewModel(for: entity)
        view?.reloadData()
    }
    
    func store(entity: RSSEntity) {
        interactor?.saveInStorage(entity: entity)
    }
    
    private func prepareViewModel(for entity: RSSEntity) {
        let viewModel = viewModelFactory.produceViewModel(with: entity, fullMode: isFullMode)
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
    
    private func save(viewModel: FeedViewModelProtocol) {
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
        timerWorker.startTimer()
        retrieveNetworkData()
        filter.flatMap {
            interactor?.getAllModelsFromStore(with: $0)
        }
        view?.reloadData()
    }
    
    func viewWillDissaper() {
        timerWorker.stopTimer()
    }
    
    func getModes() -> [String] {
        return Modes.allValues
    }
    
    func getCurrentMode() -> Bool {
        return isFullMode
    }
    
    func switchMode() {
        isFullMode.toggle()
        viewModels.flatMap {
            for var vm in $0 {
                vm.isFullMode.toggle()
            }
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
        }
        return viewModels[row].cellHeightSimpleMode
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
