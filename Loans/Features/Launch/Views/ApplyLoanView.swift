//
//  ApplyLoanView.swift
//  Loans
//
//  Created by Sylus Abel on 22/05/2026.
//

import SwiftData
import SwiftUI

struct ApplyLoanView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ApplyLoanViewModel
    let onGoHome: () -> Void

    init(loan: AvailableLoans, onGoHome: @escaping () -> Void = {}) {
        _viewModel = State(initialValue: ApplyLoanViewModel(loan: loan))
        self.onGoHome = onGoHome
    }

    init(savedApplication: SavedLoanApplication, onGoHome: @escaping () -> Void = {}) {
        _viewModel = State(initialValue: ApplyLoanViewModel(savedApplication: savedApplication))
        self.onGoHome = onGoHome
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    loanTypeSection
                    loanAmountSection
                    loanPeriodSection
                    disbursementSection
                    repaymentScheduleSection
                }
                .padding(.horizontal, 28)
                .padding(.top, 36)
                .padding(.bottom, 24)
            }

            NavigationLink {
                ApplyLoanConfirmationView(viewModel: viewModel) {
                    onGoHome()
                    dismiss()
                }
            } label: {
                Text("Apply Loan")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 58)
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 24)
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
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
                    .font(.title)
                    .foregroundColor(.black)
                    .bold()

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 28)
            .padding(.top, 18)
        }
        .frame(height: 140)
        .clipped()
        .ignoresSafeArea(edges: .top)
    }

    private var loanTypeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            fieldTitle("Loan Type")

            Menu {
                ForEach(viewModel.loanTypes, id: \.title) { loan in
                    Button(loan.title) {
                        viewModel.application.loan = loan
                    }
                }
            } label: {
                pickerField(title: viewModel.application.loan.title)
            }

            detailLine(label: "Interest:", value: viewModel.interestRateText)
        }
    }

    private var loanAmountSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            fieldTitle("Loan Amount")

            HStack(spacing: 18) {
                Text("KES")
                    .foregroundColor(.primary)

                Rectangle()
                    .fill(Color.secondary.opacity(0.6))
                    .frame(width: 1, height: 34)

                Text(viewModel.amountText)
                    .font(.headline)
            }
            .padding(.horizontal, 26)
            .frame(maxWidth: .infinity, minHeight: 68, alignment: .leading)
            .background(fieldBackground)

            detailLine(label: "Available Loan Limit:", value: viewModel.availableLimitText)
        }
    }

    private var loanPeriodSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            fieldTitle("Loan Period (months)")

            Menu {
                ForEach(viewModel.periodOptions, id: \.self) { period in
                    Button("\(period)") {
                        viewModel.application.periodMonths = period
                    }
                }
            } label: {
                pickerField(title: "\(viewModel.application.periodMonths)")
            }

            detailLine(label: "Total Amount Payable:", value: viewModel.totalPayableText)
        }
    }

    private var disbursementSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            fieldTitle("Disbursement Account")

            Menu {
                ForEach(viewModel.accountOptions, id: \.self) { account in
                    Button(account) {
                        viewModel.application.disbursementAccount = account
                    }
                }
            } label: {
                pickerField(title: viewModel.application.disbursementAccount)
            }

            detailLine(label: "Available Loan Limit:", value: viewModel.availableLimitText)
        }
    }

    private var repaymentScheduleSection: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("Repayment Schedule")
                .font(.title2)
                .bold()
                .padding(.top, 16)

            VStack(spacing: 18) {
                ForEach(viewModel.repaymentSchedule) { installment in
                    HStack(alignment: .firstTextBaseline) {
                        Text("\(installment.title) - \(viewModel.formattedDueDate(installment.dueDate))")
                            .font(.body)

                        Spacer()

                        Text(viewModel.formattedInstallmentAmount(installment.amount))
                            .font(.headline)
                            .bold()
                    }
                }
            }
        }
    }

    private func pickerField(title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            Spacer()

            Image(systemName: "chevron.down")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 26)
        .frame(maxWidth: .infinity, minHeight: 68)
        .background(fieldBackground)
    }

    private var fieldBackground: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.secondary.opacity(0.35), lineWidth: 1)
    }

    private func fieldTitle(_ title: String) -> some View {
        Text(title)
            .font(.body)
            .foregroundColor(.secondary)
    }

    private func detailLine(label: String, value: String) -> some View {
        HStack(spacing: 4) {
            Text(label)
                .foregroundColor(.secondary)

            Text(value)
                .foregroundColor(.green)
                .bold()
        }
        .font(.body)
    }
}

#Preview {
    NavigationStack {
        ApplyLoanView(loan: AvailableLoans.mock[0])
    }
}
