//
//  DatePickerTableViewCell.swift
//  MissionControl
//
//  Created by juan renteria on 8/1/19.
//  Copyright © 2019 juan renteria. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {

    let picker = UIDatePicker()
    override func awakeFromNib() {
        super.awakeFromNib()
        picker.datePickerMode = .date
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }
    
    override var inputView: UIView? {
        return picker
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}


