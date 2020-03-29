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
    
    let rssParser: RSSParserServiceProtocol
    let alertService: AlertServiceProtocol
    let feedCellLayoutCalculator: LayoutCalculatorProtocol
    var isFullMode: Bool = false
    var viewModels: [FeedViewModelImpl]?
        
    init(
        rssParser: RSSParserServiceProtocol,
        alertService: AlertServiceProtocol,
        feedCellLayoutCalculator: LayoutCalculatorProtocol) {
        self.rssParser = rssParser
        self.alertService = alertService
        self.feedCellLayoutCalculator = feedCellLayoutCalculator
        prepareViewmodels()
    }
    
    func prepareViewmodels() {
        let sources = Sources.allCases
        sources.forEach { source in
            DispatchQueue.global().async {
                self.prepareViewModels(for: source)
            }
        }
    }
    
    func prepareViewModels(for source: Sources) {
        let ppp = RSSParserServiceImpl()
        ppp.parseFeed(
            url: source.getLink(),
            successCompletion: { [weak self] entity in
                guard let self = self else {
                    return
                }
                self.downloadImageFrom(entity.imgUrl) { [weak self] image in
                    guard let self = self else {
                        return
                    }
                    let sizes = self.feedCellLayoutCalculator.mesureCellHeight(
                        title: entity.title, description: entity.description, date: entity.pubdate)
                    let viewModel = FeedViewModelImpl(
                        newsTitleText: entity.title,
                        newsShortDescription: entity.description,
                        image: image,
                        date: entity.pubdate,
                        isFullMode: self.isFullMode,
                        cellHeightFullMode: sizes.cellHeightFullMode,
                        cellHeightSimpleMode: sizes.cellHeightSimpleMode,
                        titleHeight: sizes.titleHeight,
                        descriptionHeight: sizes.descriptionHeight,
                        source: source.description)
                    DispatchQueue.main.async {
                        if self.viewModels == nil {
                            self.viewModels = [viewModel]
                        } else {
                            self.viewModels?.append(viewModel)
                        }
                        self.view?.reloadData()
                    }
                }
            }, errorCompletion: { error in
                print("\(error)")
        })
    }
    
    let imageCache = NSCache<NSString, AnyObject>()
    
    func downloadImageFrom(_ url: String, downloadedImage: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: url) else {
            return
        }
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            downloadedImage(cachedImage)
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data) //💩
                    self.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                    downloadedImage(imageToCache)
                }
            }.resume()
        }
    }
}

extension FeedPresenterImpl: FeedPresenterProtocol {
    func getModes() -> [String] {
        var modes = [String]()
        Modes.allCases.forEach {
            modes.append($0.description)
        }
        return modes
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
    
    func didRowSelected(_ row: Int) {
        print("selected \(row)")
    }
    
    func viewDidAppear() {
        
    }
}
