//
//  AlertServiceImpl.swift
//  viper-rss
//
//  Created by user on 27.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation
import UIKit

class AlertServiceImpl: AlertServiceProtocol {
    func showDialogAlert(
        vc: UIViewController,
        title: String, message: String?,
        acceptAction: @escaping (() -> Void)) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let declineAction = UIAlertAction(title: LocalizedImpl<AlertServiceKeys>(.no).text, style: .cancel)
        let acceptAction = UIAlertAction(title: LocalizedImpl<AlertServiceKeys>(.yes).text, style: .default) { _ in
            acceptAction()
        }
        [acceptAction, declineAction].forEach { alertVC.addAction($0) }
        vc.present(alertVC, animated: true)
    }
    
    func showAlert(vc: UIViewController, title: String, message: String?) {
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: title, style: .default)
        alertVC.addAction(alertAction)
        vc.present(alertVC, animated: true, completion: nil)
    }
    
    init() {
        
    }
}
