//
//  XMLEntity+CoreDataProperties.swift
//  viper-rss
//
//  Created by user on 02.04.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//
//

import Foundation
import CoreData


extension XMLEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<XMLEntity> {
        return NSFetchRequest<XMLEntity>(entityName: "XMLEntity")
    }

    @NSManaged public var date: String?
    @NSManaged public var id: String?
    @NSManaged public var imgUrl: String?
    @NSManaged public var link: String?
    @NSManaged public var source: String?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var isReaded: Bool

}
