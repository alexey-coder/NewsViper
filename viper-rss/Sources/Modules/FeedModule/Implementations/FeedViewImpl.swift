//
//  FeedViewImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

final class FeedViewImpl: BaseController<FeedUI> {
    var presenter: FeedPresenter
    
    private let alertService: AlertService
    
    init(
        presenter: FeedPresenter,
        alertService: AlertService) {
        self.presenter = presenter
        self.alertService = alertService
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.tableView.delegate = self
        ui.tableView.dataSource = self
        setupSegmentControl()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        presenter.viewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationItem.titleView = ui.segmentControl
        if let progMaxY = navigationController?.navigationBar.frame.maxY {
            ui.progressView.frame = CGRect(
                x: .zero,
                y: progMaxY,
                width: view.bounds.width,
                height: 2)
        }
        ui.tableView.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDissaper()
    }
    
    @objc private func segmentControleToggled(_ segmentedControl: UISegmentedControl) {
        presenter.switchMode()
    }

    private func setupSegmentControl() {
        for mode in presenter.getModes().enumerated() {
            ui.segmentControl.insertSegment(withTitle: mode.element, at: mode.offset, animated: false)
        }
        ui.segmentControl.selectedSegmentIndex = presenter.getCurrentMode() ? 1 : 0
        ui.segmentControl.addTarget(self, action: #selector(segmentControleToggled(_:)), for: .valueChanged)
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        setupNavBar(LocalizedImpl<FeedModuleLocalizedKeys>(.feedNavBarTitle).text)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let progMaxY = navigationController?.navigationBar.frame.maxY {
            ui.progressView.frame.origin.y = progMaxY
        }
    }
}

extension FeedViewImpl: FeedView {
    func showIndicator() {
    }
    
    func hideIndicator() {
    }
    
    func show(progress: Double) {
        ui.progressView.progress = Float(progress)
    }
    
    func showAlert(with message: String) {
        alertService.showAlert(vc: self, message: message)
    }
    
    func reloadData() {
        ui.tableView.reloadData()
    }
}

extension FeedViewImpl: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.getHeightFor(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = presenter.getNumberOfRows()
        if rows == 0 {
            ui.tableView.setEmptyMessage(LocalizedImpl<FeedModuleLocalizedKeys>(.emptyTableMessage).text)
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = presenter.getViewModel(by: indexPath) else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedCellImpl.reuseIdentifier, for: indexPath) as! FeedCellImpl
        cell.configure(with: viewModel)
        return cell
    }
}

extension FeedViewImpl: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didRowSelected(row: indexPath.row)
    }
}
