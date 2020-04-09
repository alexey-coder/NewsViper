//
//  DetailsViewImpl.swift
//  viper-rss
//
//  Created by user on 29.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit
import WebKit

private struct Metrics {
    struct Sizes {
        static let progressHeight: CGFloat = 2
    }
    
    struct AnimationConstants {
        static let duration: Double = 0.33
    }
}

class DetailsViewImpl: BaseController<DetailsUI> {
    var presenter: DetailsPresenter
    let alertService: AlertService
    
    private var estimatedProgressObserver: NSKeyValueObservation?
    
    init(
        presenter: DetailsPresenter,
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
        presenter.viewDidLoad()
        ui.webView.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         if let progMaxY = navigationController?.navigationBar.frame.maxY {
               ui.progressView.frame = CGRect(
                   x: .zero,
                   y: progMaxY,
                   width: view.bounds.width,
                   height: 2)
           }
           ui.webView.frame = view.bounds
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupEstimatedProgressObserver() {
        estimatedProgressObserver = ui.webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.ui.progressView.progress = Float(webView.estimatedProgress)
        }
    }
}

extension DetailsViewImpl: DetailsView {
    func showAlert(with message: String) {
        alertService.showAlert(vc: self, message: message)
    }
    
    func load(url: URL) {
        ui.webView.load(URLRequest(url: url))
        setupEstimatedProgressObserver()
    }
}

extension DetailsViewImpl: WKNavigationDelegate {
    func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UIView.transition(
            with: ui.progressView,
            duration: Metrics.AnimationConstants.duration,
            options: [.transitionCrossDissolve],
            animations: {
                self.ui.progressView.isHidden = false
        }, completion: nil)
    }
    
    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        UIView.transition(
            with: ui.progressView,
            duration: Metrics.AnimationConstants.duration,
            options: [.transitionCrossDissolve],
            animations: {
                self.ui.progressView.isHidden = true
        }, completion: nil)
    }
}
