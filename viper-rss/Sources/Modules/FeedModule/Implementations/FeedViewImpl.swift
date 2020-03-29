//
//  FeedViewImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

class FeedViewImpl: BaseController<FeedUI> {
    var presenter: FeedPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.tableView.delegate = self
        ui.tableView.dataSource = self
        setupNavBar()
        setupSegmentControl()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationItem.titleView = ui.segmentControl
        ui.tableView.frame = view.frame
    }
    
    @objc func segmentControleToggled(_ segmentedControl: UISegmentedControl) {
        presenter?.switchMode()
    }
    
    private func setupSegmentControl() {
        guard let presenter = presenter else {
            return
        }
        for mode in presenter.getModes().enumerated() {
            ui.segmentControl.insertSegment(withTitle: mode.element, at: mode.offset, animated: false)
        }
        ui.segmentControl.selectedSegmentIndex = presenter.isFullMode ? 1 : 0
        ui.segmentControl.addTarget(self, action: #selector(segmentControleToggled(_:)), for: .valueChanged)
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        setupNavBar(LocalizedImpl<FeedModuleLocalizedKeys>(.feedNavBarTitle).text)
    }
}

extension FeedViewImpl: FeedViewProtocol {
    func reloadData() {
        ui.tableView.reloadData()
    }
}


extension FeedViewImpl: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.getHeightFor(row: indexPath.row) ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNumberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = presenter?.getViewModel(by: indexPath) else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedCellImpl.reuseIdentifier, for: indexPath) as! FeedCellImpl
        cell.configure(with: viewModel)
        return cell
    }
}

extension FeedViewImpl: UITableViewDelegate {
    
}
