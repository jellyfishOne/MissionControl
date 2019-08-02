//
//  BillDetailTableViewController.swift
//  MissionControl
//
//  Created by juan renteria on 8/1/19.
//  Copyright © 2019 juan renteria. All rights reserved.
//

import UIKit
import PickerViewCell

class BillDetailTableViewController: UITableViewController {

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var paidLabel: UILabel!
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        // Dismiss keyboard when user taps on the screen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    // Dismiss keyboard when user taps or drags screen
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer)
    {
        view.endEditing(true)
        gestureRecognizer.cancelsTouchesInView = false
        tableView.keyboardDismissMode = .onDrag
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        return 2
    }
    
}

// MARK: - PickerTableCellDelegate
extension BillDetailTableViewController: PickerTableCellDelegate {
    
    func onPickerOpen(_ cell: IsPaidPickerTableViewCell) {
        paidLabel.text = label.text!.isEmpty ? "YES" : paidLabel.text
        paidLabel.textColor = UIColor.red
    }
    
    func onPickerClose(_ cell: IsPaidPickerTableViewCell) {
        paidLabel.textColor = UIColor.gray
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int, forCell cell: IsPaidPickerTableViewCell) -> String? {
        return row == 0 ? "YES" : "NO"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int, forCell cell: IsPaidPickerTableViewCell) {
        paidLabel.text = row == 0 ? "YES" : "NO"
    }
    
}
