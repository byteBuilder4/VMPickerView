//
//  VMPickerViewDelegate.swift
//  VMPickerViewDemo
//
//  Created by Vasi Margariti on 18/10/2024.
//

import UIKit


@objc public protocol VMPickerViewDataSource: AnyObject {
    func numberOfItemsInPickerView(_ pickerView: VMPickerView) -> Int
    func pickerView(_ pickerView: VMPickerView, titleForItem item: Int) -> String
}
@objc public protocol VMPickerViewDelegate: AnyObject  {
    func pickerView(pickerView: VMPickerView, didSelectItem item: Int)
}
