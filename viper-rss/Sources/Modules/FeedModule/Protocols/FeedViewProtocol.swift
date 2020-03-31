//
//  FeedView.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

protocol FeedViewProtocol: UIViewController {
    var presenter: FeedPresenterProtocol? { get set }
    func reloadData()
    func showAlert(with message: String)
    
    
    
    // MARK: Event update lifecycle
    func displayStartEventUpdates()
    func displayStopEventUpdates()
    // MARK: Event section updates
    func displayInsertedSection(section: IndexSet)
    func displayDeletedSection(section: IndexSet)
    func displayUpdatedSection(section: IndexSet)
    func displayMovedSection(from: IndexSet, to: IndexSet)
    // MARK: Event row updates
    func displayInsertedRowAt(row: IndexPath)
    func displayDeletedRowAt(row: IndexPath)
    func displayUpdatedRowAt(row: IndexPath, withDisplayedEvent displayedEvent: RSSEntity)
    func displayMovedRow(from: IndexPath, to: IndexPath, withDisplayedEvent displayedEvent: RSSEntity)
}
