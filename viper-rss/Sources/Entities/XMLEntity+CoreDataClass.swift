//
//  XMLEntity+CoreDataClass.swift
//  viper-rss
//
//  Created by user on 02.04.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(XMLEntity)
public class XMLEntity: NSManagedObject {
    func toSwiftModel() -> RSSEntity {
        return RSSEntity(
            title: self.title ?? "",
            description: self.text ?? "",
            pubdate: String(describing: self.date),
            link: self.link ?? "",
            imgUrl: self.imgUrl ?? "",
            postId: self.id ?? "",
            source: self.source ?? "",
            isReaded: self.isReaded)
    }
}
