//
//  CustomPickerView.swift
//  viper-rss
//
//  Created by user on 01.04.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

class CustomPickerView<T>: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {

    var values: [T]
    var onSelect: ((T) -> Void)
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        values.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        String(describing: values[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onSelect(values[row])
    }
        
    init(values: [T], onSelected: @escaping ((T) -> Void)) {
        self.values = values
        self.onSelect = onSelected
        super.init(frame: .zero)
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
