//
//  AvailableLoanCard.swift
//  Loans
//
//  Created by Sylus Abel on 22/05/2026.
//

import SwiftUI

struct AvailableLoanCard: View {
    let loan: AvailableLoans
    let minHeight: CGFloat
    let onGoHome: () -> Void
    let onApply: (() -> Void)?

    init(
        loan: AvailableLoans,
        minHeight: CGFloat = 180,
        onGoHome: @escaping () -> Void = {},
        onApply: (() -> Void)? = nil
    ) {
        self.loan = loan
        self.minHeight = minHeight
        self.onGoHome = onGoHome
        self.onApply = onApply
    }

    @ViewBuilder
    private var applyButton: some View {
        if let onApply {
            Button(action: onApply) {
                applyButtonLabel
            }
        } else {
            NavigationLink {
                ApplyLoanView(loan: loan, onGoHome: onGoHome)
            } label: {
                applyButtonLabel
            }
        }
    }

    private var applyButtonLabel: some View {
        HStack(spacing: 6) {
            Text("Apply Now")
            Image(systemName: "chevron.right")
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(loan.title)
                    .font(.title2)
                    .bold()

                Text(loan.description)
                    .font(.body)

                applyButton
                    .frame(width: 140, height: 34)
                    .background(.white.opacity(0.18))
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)

            Spacer()

            Image(loan.image)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding(.trailing, 12)
        }
        .frame(maxWidth: .infinity, minHeight: minHeight)
        .background(
            LinearGradient(
                colors: [.black, loan.color],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(20)
    }
}

#Preview {
    AvailableLoanCard(loan: AvailableLoans.mock[0])
}
