//
//  HomeViewModel.swift
//  Loans
//
//  Created by Sylus Abel on 22/05/2026.
//

import Foundation
import Observation

@Observable
final class HomeViewModel {
    let availableLoans: [AvailableLoans]

    init(availableLoans: [AvailableLoans] = AvailableLoans.mock) {
        self.availableLoans = availableLoans
    }

    func activeApplication(from savedApplications: [SavedLoanApplication]) -> SavedLoanApplication? {
        savedApplications.sorted { $0.createdAt > $1.createdAt }.first
    }

    func otherLoans(from savedApplications: [SavedLoanApplication]) -> [AvailableLoans] {
        let appliedLoanTitles = Set(savedApplications.map(\.loanTitle))
        return availableLoans.filter { !appliedLoanTitles.contains($0.title) }
    }

    func hasActiveLoan(in savedApplications: [SavedLoanApplication]) -> Bool {
        !savedApplications.isEmpty
    }

    func currencyText(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        let formattedAmount = formatter.string(from: NSNumber(value: amount)) ?? "0.00"
        return "\(formattedAmount) KES"
    }
}
