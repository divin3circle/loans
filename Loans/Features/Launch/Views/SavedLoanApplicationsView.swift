//
//  SavedLoanApplicationsView.swift
//  Loans
//
//  Created by Sylus Abel on 22/05/2026.
//

import SwiftData
import SwiftUI

struct SavedLoanApplicationsView: View {
    @Query private var savedApplications: [SavedLoanApplication]
    @State private var showsBlockedAlert = false
    let viewModel: HomeViewModel
    let onGoHome: () -> Void

    private var sortedApplications: [SavedLoanApplication] {
        savedApplications
            .filter { !$0.isSubmitted }
            .sorted { $0.createdAt > $1.createdAt }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Saved Calculations")
                    .font(.title3)
                    .bold()

                Spacer()

                Text("\(sortedApplications.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if sortedApplications.isEmpty {
                Text("Saved loan calculations will appear here after you save or confirm an application.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                    )
            } else {
                VStack(spacing: 12) {
                    ForEach(sortedApplications) { application in
                        if viewModel.canOpenSavedApplication(application, savedApplications: savedApplications) {
                            NavigationLink {
                                ApplyLoanView(savedApplication: application, onGoHome: onGoHome)
                            } label: {
                                savedApplicationRow(application)
                            }
                            .buttonStyle(.plain)
                        } else {
                            Button {
                                showsBlockedAlert = true
                            } label: {
                                savedApplicationRow(application)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .alert("Active Loan Exists", isPresented: $showsBlockedAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please pay your active loan first before reopening another saved calculation.")
        }
    }

    private func savedApplicationRow(_ application: SavedLoanApplication) -> some View {
        HStack(spacing: 14) {
            Image(application.loanImage)
                .resizable()
                .scaledToFit()
                .frame(width: 52, height: 52)

            VStack(alignment: .leading, spacing: 6) {
                Text(application.loanTitle)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("\(application.isSubmitted ? "Submitted" : "Draft") • \(formattedDate(application.createdAt))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text(currencyText(application.totalPayable))
                    .font(.headline)
                    .foregroundColor(Color(red: 0.0, green: 0.32, blue: 0.25))

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
        )
    }

    private func currencyText(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        let formattedAmount = formatter.string(from: NSNumber(value: amount)) ?? "0.00"
        return "\(formattedAmount) KES"
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        SavedLoanApplicationsView(viewModel: HomeViewModel(), onGoHome: {})
    }
}
