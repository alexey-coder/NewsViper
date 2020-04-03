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
    
    private let alertService: AlertServiceProtocol
    
    init(alertService: AlertServiceProtocol) {
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
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        presenter?.viewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationItem.titleView = ui.segmentControl
        ui.tableView.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDissaper()
    }
    
    @objc private func segmentControleToggled(_ segmentedControl: UISegmentedControl) {
        presenter?.switchMode()
    }
    
    @objc private func refreshData(_ sender: Any) {
        presenter?.retrieveNetworkData()
    }

    private func setupSegmentControl() {
        guard let presenter = presenter else {
            return
        }
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
}

extension FeedViewImpl: FeedViewProtocol {
    
    func showAlert(with message: String) {
        alertService.showAlert(vc: self, message: message)
    }
    
    func reloadData() {
        ui.tableView.reloadData()
    }
}


extension FeedViewImpl: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.getHeightFor(row: indexPath.row) ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = presenter?.getNumberOfRows() else {
            return 0
        }
        if rows == 0 {
            ui.tableView.setEmptyMessage(LocalizedImpl<FeedModuleLocalizedKeys>(.emptyTableMessage).text)
        }
        return rows
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didRowSelected(row: indexPath.row)
    }
}
