//
//  SavedLoanApplication.swift
//  Loans
//
//  Created by Sylus Abel on 22/05/2026.
//

import Foundation
import SwiftData

@Model
final class SavedLoanApplication {
    var loanTitle: String
    var loanImage: String
    var amount: Double
    var interestAmount: Double
    var totalPayable: Double
    var monthlyPayment: Double
    var periodMonths: Int
    var disbursementAccount: String
    var nextRepaymentDate: Date
    var createdAt: Date
    var isSubmitted: Bool = true

    init(
        loanTitle: String,
        loanImage: String,
        amount: Double,
        interestAmount: Double,
        totalPayable: Double,
        monthlyPayment: Double,
        periodMonths: Int,
        disbursementAccount: String,
        nextRepaymentDate: Date,
        createdAt: Date = Date(),
        isSubmitted: Bool = true
    ) {
        self.loanTitle = loanTitle
        self.loanImage = loanImage
        self.amount = amount
        self.interestAmount = interestAmount
        self.totalPayable = totalPayable
        self.monthlyPayment = monthlyPayment
        self.periodMonths = periodMonths
        self.disbursementAccount = disbursementAccount
        self.nextRepaymentDate = nextRepaymentDate
        self.createdAt = createdAt
        self.isSubmitted = isSubmitted
    }
}
