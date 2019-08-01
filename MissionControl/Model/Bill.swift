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
    var isAutoPayment: Bool
    var isPaid: Bool
    var amoutDue: Double
    var paymentHistory: [PaymentHistory]
}

struct PaymentHistory {
    var paymentDate: Date
    var amountPaid: Double
}
