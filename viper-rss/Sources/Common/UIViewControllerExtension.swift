//
//  UIViewControllerExtension.swift
//  viper-rss
//
//  Created by user on 27.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

private struct Metrics {
    struct Colors {
        static let navBarTitleColor = ColorHelper.controllersTitleColor
    }
    
    struct Fonts {
        static let navBartitleFont = FontHelper.Bold.of(size: 20)
    }
}

extension UIViewController {
    func setupNavBar(_ title: String) {
        navigationItem.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Metrics.Colors.navBarTitleColor,
            NSAttributedString.Key.font: Metrics.Fonts.navBartitleFont!
        ]
    }
}
