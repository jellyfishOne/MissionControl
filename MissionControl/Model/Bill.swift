//
//  Bill.swift
//  MissionControl
//
//  Created by juan renteria on 8/1/19.
//  Copyright © 2019 juan renteria. All rights reserved.
//

import Foundation

struct Bill {
    var name: String
    var upcomingPaymentDate: Date
    var isPaid: Bool
    var amoutDue: Double
    var paymentHistory: [PaymentHistory]
    
    // Date formatter
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    // Create sample bills
    static func populateBills() -> [Bill]{
        let sampleBills = [
            Bill(name: "Bill 1", upcomingPaymentDate: Date(), isPaid: true, amoutDue: 20.0, paymentHistory: [PaymentHistory]()),
            Bill(name: "Bill 2", upcomingPaymentDate: Date(), isPaid: true, amoutDue: 20.0, paymentHistory: [PaymentHistory]()),
            Bill(name: "Bill 3", upcomingPaymentDate: Date(), isPaid: true, amoutDue: 20.0, paymentHistory: [PaymentHistory]()),
            Bill(name: "Bill 4", upcomingPaymentDate: Date(), isPaid: true, amoutDue: 20.0, paymentHistory: [PaymentHistory]()),
            Bill(name: "Bill 5", upcomingPaymentDate: Date(), isPaid: true, amoutDue: 20.0, paymentHistory: [PaymentHistory]()),
        ]
        return sampleBills
    }
}

struct PaymentHistory {
    var paymentDate: Date
    var amountPaid: Double
}
