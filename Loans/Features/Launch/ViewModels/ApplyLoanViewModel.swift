//
//  ApplyLoanViewModel.swift
//  Loans
//
//  Created by Sylus Abel on 22/05/2026.
//

import Foundation
import Observation

@Observable
final class ApplyLoanViewModel {
    var application: LoanApplication

    let loanTypes: [AvailableLoans]
    let periodOptions = [2, 3, 6, 12]
    let accountOptions = ["011090145246100", "010120030045600"]

    private let annualInterestRate = Decimal(string: "0.15") ?? 0
    private let availableLimit = Decimal(12_000)

    init(loan: AvailableLoans, loanTypes: [AvailableLoans] = AvailableLoans.mock) {
        self.loanTypes = loanTypes
        self.application = LoanApplication(
            loan: loan,
            amount: 10_000,
            periodMonths: 2,
            disbursementAccount: "011090145246100",
            startDate: Date()
        )
    }

    init(savedApplication: SavedLoanApplication, loanTypes: [AvailableLoans] = AvailableLoans.mock) {
        self.loanTypes = loanTypes
        let loan = loanTypes.first { $0.title == savedApplication.loanTitle } ?? loanTypes[0]
        self.application = LoanApplication(
            loan: loan,
            amount: savedApplication.amount,
            periodMonths: savedApplication.periodMonths,
            disbursementAccount: savedApplication.disbursementAccount,
            startDate: savedApplication.createdAt
        )
    }

    var interestRateText: String {
        "15% p.a"
    }

    var amountText: String {
        currencyText(application.amount, includeCurrencySuffix: false)
    }

    var amountWithCurrencyText: String {
        currencyText(application.amount)
    }

    var availableLimitText: String {
        currencyText(availableLimit)
    }

    var calculationResult: LoanCalculationResult {
        LoanCalculator.calculate(
            input: LoanCalculationInput(
                principal: Decimal(application.amount),
                annualInterestRate: annualInterestRate,
                tenureMonths: application.periodMonths
            )
        )
    }

    var interestAmount: Double {
        doubleValue(calculationResult.totalInterest)
    }

    var interestAmountText: String {
        currencyText(calculationResult.totalInterest)
    }

    var totalPayable: Double {
        doubleValue(calculationResult.totalPayable)
    }

    var totalPayableText: String {
        currencyText(calculationResult.totalPayable)
    }

    var periodText: String {
        application.periodMonths == 1 ? "1 Month" : "\(application.periodMonths) Months"
    }

    var nextRepaymentDateText: String {
        guard let firstInstallment = repaymentSchedule.first else {
            return ""
        }

        return formattedDueDate(firstInstallment.dueDate)
    }

    var monthlyPayment: Double {
        doubleValue(calculationResult.emi)
    }

    var repaymentSchedule: [RepaymentInstallment] {
        (1...application.periodMonths).map { month in
            RepaymentInstallment(
                title: installmentTitle(for: month),
                dueDate: dueDate(for: month),
                amount: installmentAmount
            )
        }
    }

    func formattedInstallmentAmount(_ amount: Double) -> String {
        currencyText(amount)
    }

    func formattedDueDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: date)
    }

    private var installmentAmount: Double {
        monthlyPayment
    }

    private func dueDate(for month: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: month, to: application.startDate) ?? application.startDate
    }

    private func installmentTitle(for month: Int) -> String {
        switch month {
        case 1:
            return "1st instalment"
        case 2:
            return "2nd instalment"
        case 3:
            return "3rd instalment"
        default:
            return "\(month)th instalment"
        }
    }

    private func currencyText(_ amount: Double, includeCurrencySuffix: Bool = true) -> String {
        currencyText(Decimal(amount), includeCurrencySuffix: includeCurrencySuffix)
    }

    private func currencyText(_ amount: Decimal, includeCurrencySuffix: Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        let formattedAmount = formatter.string(from: NSDecimalNumber(decimal: amount)) ?? "0.00"
        return includeCurrencySuffix ? "\(formattedAmount) KES" : formattedAmount
    }

    private func doubleValue(_ amount: Decimal) -> Double {
        NSDecimalNumber(decimal: amount).doubleValue
    }
}
