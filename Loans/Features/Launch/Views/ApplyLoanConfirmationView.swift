//
//  ApplyLoanConfirmationView.swift
//  Loans
//
//  Created by Sylus Abel on 22/05/2026.
//

import SwiftData
import SwiftUI

struct ApplyLoanConfirmationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showsSuccess = false
    @State private var saveErrorMessage: String?
    

    let viewModel: ApplyLoanViewModel
    let onGoHome: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 34) {
                    loanDetailsSection
                    divider
                    disbursementDetailsSection
                    divider
                    repaymentDetailsSection

                    Spacer()

                    Button("Confirm") {
                        saveLoanApplication()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 58)
                    .background(Color.green)
                    .cornerRadius(8)
                }
                .padding(.horizontal, 34)
                .padding(.top, 52)
                .padding(.bottom, 34)
            }
            .background(Color.white)
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)

            if showsSuccess {
                successOverlay
            }
        }
        .alert("Save Failed", isPresented: Binding(
            get: { saveErrorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    saveErrorMessage = nil
                }
            }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(saveErrorMessage ?? "")
        }
    }

    private func saveLoanApplication() {
        let savedApplication = SavedLoanApplication(
            loanTitle: viewModel.application.loan.title,
            loanImage: viewModel.application.loan.image,
            amount: viewModel.application.amount,
            interestAmount: viewModel.interestAmount,
            totalPayable: viewModel.totalPayable,
            monthlyPayment: viewModel.monthlyPayment,
            periodMonths: viewModel.application.periodMonths,
            disbursementAccount: viewModel.application.disbursementAccount,
            nextRepaymentDate: viewModel.repaymentSchedule.first?.dueDate ?? viewModel.application.startDate
        )

        modelContext.insert(savedApplication)

        do {
            try modelContext.save()
            showsSuccess = true
        } catch {
            saveErrorMessage = "We couldn't save this loan. Please try again."
        }
    }

    private func goHome() {
        showsSuccess = false
        dismiss()

        DispatchQueue.main.async {
            onGoHome()
        }
    }

    private var topBar: some View {
        ZStack {
            Image("header")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()

            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.white)
                }

                Spacer()

                Text("Apply Loan")
                    .font(.title3)
                    .foregroundColor(.white)

                Spacer()

                Button {
                    goHome()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 28)
            .padding(.top, 18)
        }
        .frame(height: 140)
        .clipped()
        .ignoresSafeArea(edges: .top)
    }

    private var loanDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Loan Details")
            detailRow(label: "Loan Amount:", value: viewModel.amountWithCurrencyText, isHighlighted: true)
            detailRow(label: "Interest:", value: viewModel.interestAmountText)
            detailRow(label: "Total Charges:", value: viewModel.totalPayableText)
            detailRow(label: "Period:", value: viewModel.periodText)
        }
    }

    private var disbursementDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Disbursement Details")
            detailRow(label: "Account:", value: viewModel.application.disbursementAccount, isBold: true)
            detailRow(label: "Amount:", value: viewModel.amountWithCurrencyText, isBold: true)
        }
    }

    private var repaymentDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Repayment Details")
            detailRow(label: "Amount:", value: viewModel.totalPayableText, isBold: true)
            detailRow(label: "Installments:", value: "\(viewModel.application.periodMonths)")
            detailRow(label: "Next Repayment Date:", value: viewModel.nextRepaymentDateText)
        }
    }

    private var successOverlay: some View {
        ZStack {
            Color.black.opacity(0.42)
                .ignoresSafeArea()

            VStack(spacing: 28) {
                Text("Request Sent Successfully")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.green)

                Image("complete")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)

                Text("Your loan request has been\nsubmitted successfully.")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)

                Button("Go Home") {
                    goHome()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 58)
                .background(Color.green)
                .cornerRadius(8)
                .padding(.horizontal, 38)
            }
            .padding(.vertical, 36)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 28)
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.secondary.opacity(0.35))
            .frame(height: 1)
            .padding(.horizontal, 26)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .bold()
            .foregroundColor(.primary)
    }

    private func detailRow(label: String, value: String, isHighlighted: Bool = false, isBold: Bool = false) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .font(isHighlighted ? .title2 : .body)
                .fontWeight(isHighlighted || isBold ? .bold : .regular)
                .foregroundColor(isHighlighted ? Color(red: 0.18, green: 0.43, blue: 0.36) : .primary)
                .multilineTextAlignment(.trailing)
        }
        .font(.body)
    }
}

#Preview {
    NavigationStack {
        ApplyLoanConfirmationView(
            viewModel: ApplyLoanViewModel(loan: AvailableLoans.mock[0]),
            onGoHome: {}
        )
    }
}
