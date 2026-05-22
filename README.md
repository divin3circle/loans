# Loan App Submission

## Architecture
The app uses a lightweight MVVM structure inside the Launch feature, with SwiftUI views handling layout/navigation, view models handling presentation decisions and calculation-facing state, value models representing loan inputs/results, and SwiftData providing persistence for confirmed loan applications. The loan calculation logic is isolated in a reusable LoanCalculator using Decimal, while ApplyLoanViewModel prepares values for the apply/confirmation flow and HomeViewModel handles home-screen selection logic such as active loans and available loans.

## Assumptions
Assumptions made: I assumed a fixed annual interest rate of 15% p.a, a default loan amount of 10,000 KES, fixed account options, and mock loan products as the source of available loans. We also assumed the latest confirmed saved loan should be treated as the active loan on the home screen.

## TradeOffs
Trade-offs chosen: I used SwiftData as a simple persistence layer instead of Core Data or custom file storage because it fits my currect stack SwiftUI much better and it's easier and simpler to use. The file storage route was abadoned because it's not "production" caliber and doesn't scale well.

## Improvements
I think i would add editable loan amount input, richer validation, a full amortization schedule with principal/interest breakdown per installment, and unit tests around the calculator and view models. We would also improve saved-loan management with delete, search, and detailed saved calculation screens.

## Intentionally simplified
I knowingly simplified authentication, real backend integration, account selection, loan eligibility, and disbursement processing into mock/static data. I also kept the saved-loan reopening flow inside the existing apply screen instead of building a separate read-only calculation detail screen:

## Un-attended features
- Dark mode comaptibility(lacked time to setup a theme mode didn't want to overthink it)
- Unit tests(ran out of time,)
- Document exports(need a bit of time to research on the best implementation of the same in swiftUI)
- Amortization(knowledge gap and time constarints)

## Setup Instructions
- Clone the app at: `https://github.com/divin3circle/loans.git`
- Open the project in xcode and launch the simulator
> No dependencies were used in this project
.
