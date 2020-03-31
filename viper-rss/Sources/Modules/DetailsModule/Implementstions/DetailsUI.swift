//
//  DetailsUI.swift
//  viper-rss
//
//  Created by user on 30.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit
import WebKit

class DetailsUI: UIView {
    
    let configuration = WKWebViewConfiguration()

    let progressView = UIProgressView(progressViewStyle: .default).then {
        $0.sizeToFit()
        $0.isHidden = true
        $0.tintColor = Constants.Colors.dateColor
    }
    
    lazy var webView = WKWebView(frame: .zero, configuration: self.configuration).then {
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(webView)
        addSubview(progressView)
        backgroundColor = Constants.Colors.backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
