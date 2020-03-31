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
    private var isFullMode: Bool = false
    private var viewModels: [FeedViewModelImpl]?
        
    init(feedCellLayoutCalculator: LayoutCalculatorProtocol) {
        self.feedCellLayoutCalculator = feedCellLayoutCalculator
    }
    
    private func prepareViewmodels() {
        DispatchQueue.global().async {
            self.interactor?.requestEntities(from: [.gazeta, .lenta])
        }
    }
}

extension FeedPresenterImpl: FeedPresenterProtocol {
    func prepareViewModel(for entity: RSSEntity, and source: String) {
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
            source: source,
            link: entity.link)
    }
    
    func showAlert(message: String) {
        DispatchQueue.main.async {
            self.view?.showAlert(with: message)
        }
    }
    
    func viewDidLoad() {
        prepareViewmodels()
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
        viewModels?.forEach { $0.isFullMode.toggle() }
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
        guard let link = viewModels?[row].link else {
            return
        }
        router?.presentDetails(with: link)
    }
    
    func viewDidAppear() {
        
    }
}
