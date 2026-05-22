//
//  LoanCalculator.swift
//  Loans
//
//  Created by Sylus Abel on 22/05/2026.
//

import Foundation

struct LoanCalculationInput {
    let principal: Decimal
    let annualInterestRate: Decimal
    let tenureMonths: Int
}

struct LoanCalculationResult {
    let emi: Decimal
    let totalInterest: Decimal
    let totalPayable: Decimal
}

enum LoanCalculator {
    static func calculate(input: LoanCalculationInput) -> LoanCalculationResult {
        guard input.tenureMonths > 0 else {
            return LoanCalculationResult(emi: 0, totalInterest: 0, totalPayable: input.principal.roundedCurrency)
        }

        let principal = input.principal
        let monthlyInterestRate = input.annualInterestRate / 12

        if monthlyInterestRate == 0 {
            let emi = (principal / Decimal(input.tenureMonths)).roundedCurrency
            return LoanCalculationResult(
                emi: emi,
                totalInterest: 0,
                totalPayable: principal.roundedCurrency
            )
        }

        let compoundedRate = (1 + monthlyInterestRate).raised(to: input.tenureMonths)
        let numerator = principal * monthlyInterestRate * compoundedRate
        let denominator = compoundedRate - 1
        let emi = (numerator / denominator).roundedCurrency
        let totalPayable = (emi * Decimal(input.tenureMonths)).roundedCurrency
        let totalInterest = (totalPayable - principal).roundedCurrency

        return LoanCalculationResult(
            emi: emi,
            totalInterest: totalInterest,
            totalPayable: totalPayable
        )
    }
}

private extension Decimal {
    var roundedCurrency: Decimal {
        var source = self
        var result = Decimal()
        NSDecimalRound(&result, &source, 2, .bankers)
        return result
    }

    func raised(to power: Int) -> Decimal {
        NSDecimalNumber(decimal: self).raising(toPower: power).decimalValue
    }
}
