//
//  Then.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation
import CoreGraphics

public protocol Then {}

extension Then where Self: AnyObject {

  public func then(_ block: (Self) throws -> Void) rethrows -> Self {
    try block(self)
    return self
  }
}

extension NSObject: Then {}
extension CGPoint: Then {}
extension CGRect: Then {}
extension CGSize: Then {}
extension CGVector: Then {}
extension Array: Then {}
extension Dictionary: Then {}
extension Set: Then {}

