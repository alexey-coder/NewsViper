//
//  SettingsViewImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

class SettingsViewImpl: BaseController<SettingsUI> {
    var presenter: SettingsPresenter
    let alertService: AlertService
    
    init(
        presenter: SettingsPresenter,
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
        ui.tableView.dataSource = self
        ui.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        setupNavBar(LocalizedImpl<SettingsModuleLocalizedKeys>(.settingsNavBarTitle).text)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ui.tableView.frame = view.bounds
    }
}

extension SettingsViewImpl: SettingsView {
    func reloadData() {
        ui.tableView.reloadData()
    }
    
    func showTimerPicker<T>(with values: [T], cellType: SettingsHelper) {
        alertService.showTimerPicker(vc: self, values: values) { [weak self] selected in
            switch cellType {
            case .timer:
                self?.presenter.setNewTimer(interval: selected as! Int)
            case .source:
                self?.presenter.setNewCategory(filter: selected as! String)
            }
        }
    }
}

extension SettingsViewImpl: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.heightForRow
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = presenter.getViewModel(by: indexPath),
            let row = SettingsHelper(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        let cell: SettingsCell
        switch row {
        case .timer:
            cell = tableView.dequeueReusableCell(withIdentifier: SettingsTimerCellImpl.reuseIdentifier, for: indexPath) as! SettingsTimerCellImpl
        case .source:
            cell = tableView.dequeueReusableCell(withIdentifier: SettingsCategoryCellImpl.reuseIdentifier, for: indexPath) as! SettingsCategoryCellImpl
        }
        cell.configure(with: viewModel)
        return cell
    }
}

extension SettingsViewImpl: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didRowSelected(indexPath.row)
    }
}
