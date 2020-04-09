//
//  AlertServiceImpl.swift
//  viper-rss
//
//  Created by user on 27.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

class AlertServiceImpl: AlertService {
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
    
    func showAlert(vc: UIViewController, message: String?) {
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: LocalizedImpl<AlertServiceKeys>(.ok).text, style: .default)
        alertVC.addAction(alertAction)
        vc.present(alertVC, animated: true, completion: nil)
    }
        
    func showTimerPicker<T>(
        vc: UIViewController,
        values: [T],
        acceptAction: @escaping ((T) -> Void)) {
        var selected: T? = nil
        let picker = CustomPickerView(values: values) { val in
            selected = val
        }
        picker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
        alertController.view.addSubview(picker)
        let selectAction = UIAlertAction(title: LocalizedImpl<AlertServiceKeys>(.done).text, style: .default, handler: { _ in
            guard let selected = selected else {
                return
            }
            acceptAction(selected)
        })
        let cancelAction = UIAlertAction(title: LocalizedImpl<AlertServiceKeys>(.cancel).text, style: .cancel, handler: nil)
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        vc.present(alertController, animated: true)
    }
    
    init() {
        
    }
}
