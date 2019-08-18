//
//  BillDetailTableViewController.swift
//  MissionControl
//
//  Created by juan renteria on 8/1/19.
//  Copyright © 2019 juan renteria. All rights reserved.
//

import UIKit
import PickerViewCell

//TODO format amount due
//TODO User should not be able to save a new item with an empty variable
//TODO Date label should start up with todays date for new bill date
class BillDetailTableViewController: UITableViewController {

    @IBOutlet weak var billNameTextField: UITextField!
    //TODO update label name
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var amountDueTextField: UITextField!
    @IBOutlet weak var paidLabel: UILabel!
    
    @IBOutlet weak var pastPaymentDateLabel: UILabel!
    @IBOutlet weak var pastPaidAmountLabel: UILabel!
    
    let datePicker = UIDatePicker()
    var bill: Bill?
    var isAutoPayment = false
    var upcomingDate = Date()
    let maxLength = 20
    let isPaidYesOrNoArray = ["YES", "NO"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dismiss keyboard when user taps on the screen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveBillUnwind" else { return }
        
        let name = billNameTextField.text
        let upcomingPaymentDate = upcomingDate
        if( paidLabel.text == "YES"){
            isAutoPayment = true
        }
        let amountDue = Double(amountDueTextField.text!)
    
        bill = Bill(name: name!, upcomingPaymentDate: upcomingPaymentDate, isPaid: isAutoPayment, amoutDue: amountDue!, paymentHistory: [PaymentHistory]())
        
    }
    
    // Dismiss keyboard when user taps or drags screen
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer)
    {
        view.endEditing(true)
        gestureRecognizer.cancelsTouchesInView = false
        tableView.keyboardDismissMode = .onDrag
    }

    // Limits the amount of characters the user can enter
    @IBAction func checkMaxAmountDueCharacters(_ sender: UITextField){
        if (sender.text!.count > maxLength){
            sender.deleteBackward()
        }
    }
    
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
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

// MARK:  - DatePickerTableCellDelegate

extension BillDetailTableViewController: DatePickerTableCellDelegate {
    
    func onDateChange(_ sender: UIDatePicker, cell: DatePickerTableViewCell){
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
