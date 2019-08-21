//
//  BillDetailTableViewController.swift
//  MissionControl
//
//  Created by juan renteria on 8/1/19.
//  Copyright © 2019 juan renteria. All rights reserved.
//

import UIKit
import PickerViewCell

class BillDetailTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var billNameTextField: UITextField!
    //TODO update label name
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var amountDueTextField: UITextField!
    @IBOutlet weak var paidLabel: UILabel!
    
    @IBOutlet weak var pastPaymentDateLabel: UILabel!
    @IBOutlet weak var pastPaidAmountLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    let datePicker = UIDatePicker()
    var bill: Bill?
    var isAutoPayment = false
    var upcomingDate = Date()
    let maxLength = 20
    let isPaidYesOrNoArray = ["YES", "NO"]
    
    // MARK: - viewDidLoad functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Make amountDueTextField delegate
        amountDueTextField.delegate = self
        
        //Save button is disabled when user is creating new bill
        updateSaveButtonState()
        
        //Default label states
        paidLabel.text = isPaidYesOrNoArray[1]
        label.text = Bill.dateFormatter.string(from: Date())
        
        // Dismiss keyboard when user taps on the screen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    // MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveBillUnwind" else { return }
        
        let name = billNameTextField.text
        let upcomingPaymentDate = upcomingDate
        if( paidLabel.text == "YES"){
            isAutoPayment = true
        }
        let amountDue = Double(amountDueTextField.text!)
    
        bill = Bill(name: name!, upcomingPaymentDate: upcomingPaymentDate, isPaid: isAutoPayment, amountDue: amountDue!, paymentHistory: [PaymentHistory]())
        
    }
    
    // MARK: - @Obj functions
    
    // Dismiss keyboard when user taps or drags screen
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer)
    {
        view.endEditing(true)
        gestureRecognizer.cancelsTouchesInView = false
        tableView.keyboardDismissMode = .onDrag
    }

    // MARK: - @IBAction functions
    
    @IBAction func billNameEditingChanged(_ sender: UITextField) {
        // Prevents a user from creating a Bill
        // without a name
        updateSaveButtonState()
    }
    // Limits the amount of characters the user can enter
    @IBAction func checkMaxAmountDueCharacters(_ sender: UITextField){
        if (sender.text!.count > maxLength){
            sender.deleteBackward()
        }
        updateSaveButtonState()
    }
    
    // MARK: - table view functions
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //TODO if payment history is empty, only returns one section
        //TODO Else it returns two sections, and section updates labels
        //with most recent payment.
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? DatePickerTableViewCell {
            cell.delegate = self
            if !cell.isFirstResponder {
                _ = cell.becomeFirstResponder()
               
            }
        }  else if let cell = tableView.cellForRow(at: indexPath) as? IsPaidPickerTableViewCell {
            cell.delegate = self
            cell.dataSource = self
            if !cell.isFirstResponder {
                _ = cell.becomeFirstResponder()
            }
        }
    }
    
    // MARK: - Helper functions
    
    // Updates Save button depending on whether or not all categories have been
    // completed by the user.
    func updateSaveButtonState(){
       
        let billNameText = billNameTextField.text ?? ""
        let amountDueText = amountDueTextField.text ?? ""
    
        if(!billNameText.isEmpty && !amountDueText.isEmpty){
            saveButton.isEnabled = true
            
        } else {
            saveButton.isEnabled = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // User pressed the delete-key to remove a character, this is always valid, return true to allow change
        if string.isEmpty { return true }
        
        // Build the full current string: TextField right now only contains the
        // previous valid value. Use provided info to build up the new version.
        // Can't just concat the two strings because the user might've moved the
        // cursor and delete something in the middle.
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Use our string extensions to check if the string is a valid double and
        // only has the specified amount of decimal places.
        return replacementText.isValidDouble(maxDecimalPlaces: 2)
    }
}

// MARK:  - AmountDueTextField Delegate

extension String {
    func isValidDouble(maxDecimalPlaces: Int) -> Bool {
        // Use NumberFormatter to check if we can turn the string into a number
        // and to get the locale specific decimal separator.
        let formatter = NumberFormatter()
        formatter.allowsFloats = true // Default is true
        let decimalSeparator = formatter.decimalSeparator ?? "."  // Gets the locale specific decimal separator. If for some reason there is none we assume "." is used as separator.
        
        // Check if we can create a valid number. (The formatter creates a NSNumber, but
        // every NSNumber is a valid double, so we're good!)
        if formatter.number(from: self) != nil {
            // Split our string at the decimal separator
            let split = self.components(separatedBy: decimalSeparator)
            
            // Depending on whether there was a decimalSeparator we may have one
            // or two parts now. If it is two then the second part is the one after
            // the separator, aka the digits we care about.
            // If there was no separator then the user hasn't entered a decimal
            // number yet and we treat the string as empty, succeeding the check
            let digits = split.count == 2 ? split.last ?? "" : ""
            
            // Finally check if we're <= the allowed digits
            return digits.count <= maxDecimalPlaces
        }
        
        return false // couldn't turn string into a valid number
    }
}

// MARK:  - DatePickerTableCellDelegate

extension BillDetailTableViewController: DatePickerTableCellDelegate {
    
    func onDateChange(_ sender: UIDatePicker, cell: DatePickerTableViewCell){
        sender.minimumDate = Date()
        upcomingDate = sender.date
        label.text = Bill.dateFormatter.string(from: sender.date)
    }
    
    func onDatePickerOpen(_ cell: DatePickerTableViewCell){
        
    }
}

// MARK: - IsPaidPickerDataSource

extension BillDetailTableViewController: PickerTableCellDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView, forCell cell: IsPaidPickerTableViewCell) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int, forCell cell: IsPaidPickerTableViewCell) -> Int {
        return isPaidYesOrNoArray.count
    }
    
}

// MARK: - PickerTableCellDelegate
extension BillDetailTableViewController: PickerTableCellDelegate {
    
    func onPickerOpen(_ cell: IsPaidPickerTableViewCell) {
        paidLabel.text = paidLabel.text!.isEmpty ? "YES" : paidLabel.text
        paidLabel.textColor = UIColor.red
    }
    
    func onPickerClose(_ cell: IsPaidPickerTableViewCell) {
        paidLabel.textColor = UIColor.gray
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int, forCell cell: IsPaidPickerTableViewCell) -> String? {
        return isPaidYesOrNoArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int, forCell cell: IsPaidPickerTableViewCell) {
        paidLabel.text = isPaidYesOrNoArray[row]
    }
    
}

/*
  credit to https://www.markusbodner.com/ 
 */
