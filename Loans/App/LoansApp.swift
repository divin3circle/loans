//
//  LoansApp.swift
//  Loans
//
//  Created by Sylus Abel on 22/05/2026.
//

import SwiftData
import SwiftUI

@main
struct LoansApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: SavedLoanApplication.self)
    }
}
