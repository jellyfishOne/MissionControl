//
//  DatePickerTableViewCell.swift
//  MissionControl
//
//  Created by juan renteria on 8/1/19.
//  Copyright © 2019 juan renteria. All rights reserved.
//

import UIKit

open class DatePickerTableViewCell: UITableViewCell {
    
    open weak var delegate: DatePickerTableViewCellDelegate?
    public let picker = UIDatePicker()
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(DatePickerTableViewCell.onDateChanged(_:)), for: .valueChanged)
    }
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open override var canResignFirstResponder: Bool {
        return true
    }
    
    open override var inputView: UIView? {
        return picker
    }
    
    open override func becomeFirstResponder() -> Bool {
        delegate?.onDatePickerOpen(self)
        return super.becomeFirstResponder()
    }
    
    @objc func onDateChanged(_ sender: UIDatePicker){
        delegate?.onDateChange(sender, cell: self)
    }
    
}

public protocol DatePickerTableViewCellDelegate: class {
    // Called when the date changes in picker
    func onDateChange(_ sender: UIDatePicker, cell: DatePickerTableViewCell)
    
    // called when the picker is open
    func onDatePickerOpen(_ cell: DatePickerTableViewCell)
}


