//
//  ContentView.swift
//  Loans
//
//  Created by Sylus Abel on 22/05/2026.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    @State private var viewModel = HomeViewModel()
    @State private var showsActiveLoanAlert = false
    @Query private var savedApplications: [SavedLoanApplication]

    private var activeApplication: SavedLoanApplication? {
        viewModel.activeApplication(from: savedApplications)
    }

    private var otherLoans: [AvailableLoans] {
        viewModel.otherLoans(from: savedApplications)
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 28) {
                    header()
                    activeLoansSection()
                    savedApplicationsSection()
                    otherLoansSection()
                }
                .padding(.bottom, 32)
            }
            .background(Color.white)
            .ignoresSafeArea(edges: .top)
            .alert("Active Loan Exists", isPresented: $showsActiveLoanAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please pay your initial loan first before applying for another loan.")
            }
        }
    }

    private func header() -> some View {
        ZStack {
            Image("header")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()

            LinearGradient(
                colors: [.black.opacity(0.42), .black.opacity(0.16)],
                startPoint: .leading,
                endPoint: .trailing
            )

            HStack(spacing: 18) {
                Image("user")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 68, height: 68)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 6) {
                    Text("Hello There!")
                        .font(.headline)
                        .bold()

                    Text("Boost your income today!")
                        .font(.headline)
                }
                .foregroundColor(.white)

                Spacer()
            }
            .padding(.horizontal, 32)
            .padding(.top, 52)
        }
        .frame(height: 126)
        .clipped()
    }

    private func activeLoansSection() -> some View {
        VStack(spacing: 24) {
            Text("Active Loans")
                .font(.title2)
                .foregroundColor(.primary)

            activeLoanCard()
        }
        .padding(.horizontal, 28)
    }

    @ViewBuilder
    private func activeLoanCard() -> some View {
        if let activeApplication {
            VStack(spacing: 24) {
                VStack(spacing: 6) {
                    Text("\(activeApplication.loanTitle) Balance")
                        .font(.title3)
                        .bold()
                        .foregroundColor(Color(red: 0.0, green: 0.32, blue: 0.25))

                    Text(viewModel.currencyText(activeApplication.totalPayable))
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(Color(red: 0.0, green: 0.32, blue: 0.25))
                        .minimumScaleFactor(0.75)
                        .lineLimit(1)
                }

                HStack(spacing: 28) {
                    VStack(spacing: 8) {
                        Text("Monthly Payment")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text(viewModel.currencyText(activeApplication.monthlyPayment))
                            .font(.body)
                            .bold()
                    }
                    .frame(maxWidth: .infinity)

                    Rectangle()
                        .fill(Color.secondary.opacity(0.55))
                        .frame(width: 1, height: 76)

                    VStack(spacing: 8) {
                        Text("Interest")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text(viewModel.currencyText(activeApplication.interestAmount))
                            .font(.body)
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.14), radius: 8, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.secondary.opacity(0.18), lineWidth: 1)
            )
        } else {
            Text("No active loans yet")
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, minHeight: 120)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.secondary.opacity(0.18), lineWidth: 1)
                )
        }
    }
    

    private func handleOtherLoanApply() {
        if viewModel.hasActiveLoan(in: savedApplications) {
            showsActiveLoanAlert = true
        }
    }

    private func savedApplicationsSection() -> some View {
        SavedLoanApplicationsView(viewModel: viewModel) {
            path = NavigationPath()
        }
        .padding(.horizontal, 28)
    }

    private func otherLoansSection() -> some View {
        VStack(spacing: 24) {
            Rectangle()
                .fill(Color.secondary.opacity(0.35))
                .frame(height: 1)
                .padding(.horizontal, 64)

            Text("Other Loans Available")
                .font(.title2)
                .foregroundColor(.primary)

            VStack(spacing: 24) {
                ForEach(otherLoans, id: \.title) { loan in
                    AvailableLoanCard(
                        loan: loan,
                        minHeight: 176,
                        onGoHome: {
                            path = NavigationPath()
                        },
                        onApply: viewModel.hasActiveLoan(in: savedApplications) ? {
                            handleOtherLoanApply()
                        } : nil
                    )
                }
            }
        }
        .padding(.horizontal, 28)
    }
}

#Preview {
    ContentView()
}
