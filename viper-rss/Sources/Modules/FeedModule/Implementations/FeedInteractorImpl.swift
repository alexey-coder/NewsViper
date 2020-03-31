//
//  FeedInteractorImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit //remove this

class FeedInteractorImpl {
    weak var presenter: FeedPresenterProtocol?
    
    private let rssParser: RSSParserServiceProtocol
    
    init(rssParser: RSSParserServiceProtocol) {
        self.rssParser = rssParser
    }
}

extension FeedInteractorImpl: FeedInteractorProtocol {
    func requestEntities(from sourses: [Sources]) {
        sourses.forEach { source in
            let parser = RSSParserServiceImpl() // TODO!
            parser.parseFeed(
                url: source.getLink(),
                successCompletion: { [weak self] entity in
                    self?.presenter?.prepareViewModel(for: entity, and: source.description)
                }, errorCompletion: { error in
                    self.presenter?.showAlert(message: error.localizedDescription)
            })
        }
    }
}
