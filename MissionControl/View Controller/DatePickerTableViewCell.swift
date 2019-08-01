//
//  DatePickerTableViewCell.swift
//  MissionControl
//
//  Created by juan renteria on 8/1/19.
//  Copyright © 2019 juan renteria. All rights reserved.
//

import UIKit

open class DatePickerTableViewCell: UITableViewCell {

    let picker = UIDatePicker()
    open override func awakeFromNib() {
        super.awakeFromNib()
        picker.datePickerMode = .date
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
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}


