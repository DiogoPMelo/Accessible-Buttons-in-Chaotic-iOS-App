//
//  RulesView.swift
//  Accessible Buttons
//
//  Created by Diogo Melo on 19/11/25.
//

import SwiftUI

struct RulesView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var cheatMode: Bool

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text("Game Rules")
                        .font(.largeTitle.bold())
                        .padding(.bottom, 10)
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityHeading(.h1)

                    Group {
                        Text("🎯 **Objective**")
                            .font(.title2.bold())
                            .accessibilityAddTraits(.isHeader)
                            .accessibilityHeading(.h2)
                        Text("""
You are presented with a 3×3 grid of hidden tiles. Tapping any tile immediately reveals its outcome.
""")
                    }

                    Divider().padding(.vertical, 4)

                    Group {
                        Text("🎁 **Prizes & Outcomes**")
                            .font(.title2.bold())
                            .accessibilityAddTraits(.isHeader)
                            .accessibilityHeading(.h2)
                        VStack(alignment: .leading, spacing: 8) {
                            bullet("1 tile contains **€1,000,000**")
                            bullet("1 tile triggers a **Hard Shock** (symbolic)")
                            bullet("1 tile contains **€50**")
                            bullet("2 tiles contain **€10**")
                            bullet("4 tiles contain **€0**")
                        }
                    }

                    Divider().padding(.vertical, 4)

                    Group {
                        Text("🔍 **Zero-Free Mode**")
                            .font(.title2.bold())
                            .accessibilityAddTraits(.isHeader)
                            .accessibilityHeading(.h2)
                        Text("""
You can enable **Zero-Free Mode** at any time.

When enabled:
""")
                        .padding(.bottom, 8)

                        VStack(alignment: .leading, spacing: 8) {
                            bullet("The **€0 tiles disappear** from the board")
                            bullet("All money prizes are **cut in half**")
                            bullet("Hard Shock becomes a **Soft Shock**")
                        }

                        Text("""
This mode makes outcomes easier to spot, but **reduces the rewards** and **softens the penalty**.
""")
                        .padding(.top, 6)
                    }

                    Divider().padding(.vertical, 4)

                    Group {
                        Text("🏳️ **Forfeiting**")
                            .font(.title2.bold())
                            .accessibilityAddTraits(.isHeader)
                            .accessibilityHeading(.h2)
                        Text("""
If you prefer not to choose a tile, you may **forfeit**.  
The grid will be revealed, showing all outcomes.
""")
                    }

                    Spacer(minLength: 60)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(cheatMode ? "Fair" : "Cheat") { cheatMode.toggle() }
                }
            }
        }
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•").font(.title3)
            Text(text)
        }
        .accessibilityElement(children: .combine)
    }
}
