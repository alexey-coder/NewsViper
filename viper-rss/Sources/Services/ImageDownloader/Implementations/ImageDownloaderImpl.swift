//
//  ImageDownloadServiceImpl.swift
//  viper-rss
//
//  Created by user on 04.04.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

final class ImageDownloadServiceImpl: ImageDownloadServiceProtocol {
    
    init() {}
    
    let imageCache = NSCache<NSString, AnyObject>()
    
    func image(for url: URL, completionHandler: @escaping(_ image: UIImage?) -> ()) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            completionHandler(cachedImage)
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data)
                    self.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                    completionHandler(imageToCache)
                }
            }.resume()
        }
    }
}
