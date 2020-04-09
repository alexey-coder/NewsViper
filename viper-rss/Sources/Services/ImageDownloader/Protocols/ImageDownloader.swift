//
//  ImageDownloadService.swift
//  viper-rss
//
//  Created by user on 04.04.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

protocol ImageDownloadService {
    func image(for url: URL, completionHandler: @escaping(_ image: UIImage?) -> ())
}
