//
//  AssetsHelper.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

public protocol AssetsConvertible {}

public extension AssetsConvertible where Self: RawRepresentable, Self.RawValue == String {
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}

public extension UIImage {
    convenience init?<T: RawRepresentable>(asset: T) where T.RawValue == String {
        self.init(named: asset.rawValue)
    }
}

public enum AssetsHelper {
    
    public enum tabBarIconsActive: String, AssetsConvertible {
        case catalogTabbarActive   = "catalogTabbarActive"
        case menuTabbarActive      = "menuTabbarActive"
    }
    
    public enum tabBarIcons: String, AssetsConvertible {
        case catalogTabbar   = "catalogTabbar"
        case menuTabbar      = "menuTabbar"
    }
}
