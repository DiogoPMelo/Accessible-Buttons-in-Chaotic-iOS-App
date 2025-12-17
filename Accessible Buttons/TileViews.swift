//
//  TileViews.swift
//  Accessible Buttons
//
//  Created by Diogo Melo on 19/11/25.
//

import SwiftUI

// MARK: - Tile View
struct TileView: View {
    let display: String
        let isDimmed: Bool

    var body: some View {
        ZStack {
            // Background tile with random colors for more chaos
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [.black, .brown],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 110)
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)

            VStack(spacing: 6) {
                // Decorative clutter
                HStack {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow.opacity(0.9))
                    Spacer()
                    Image(systemName: "sparkles")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.horizontal, 8)

                Text(display)
                    .font(.system(size: 42, weight: .black))
                    .foregroundColor(.white)

                // More clutter
                HStack {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .foregroundColor(.white.opacity(0.8))
                    Image(systemName: "diamond.fill")
                        .font(.system(size: 8))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(display)
        .accessibilityAddTraits(!isDimmed ? .isButton : .isStaticText)
        .disabled(isDimmed)
    }

    // Random color generator for chaos
    func randomColor() -> Color {
        [.blue, .purple, .pink, .red, .orange, .mint].randomElement()!
    }
}

// MARK: Outcome view

struct OutcomeTile: View {
    let prize: Prize
    let revealZeros: Bool
    let isSelected: Bool
    let isDimmed: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.blue.opacity(0.25) : Color.gray.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.4), lineWidth: isSelected ? 3 : 1)
                )
                .opacity(isVisible ? 1 : 0.15)

            Text(prize.getValue(revealZeros: revealZeros))
                .font(.headline)
                .opacity(isVisible ? 1 : 0.15)
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .disabled(!isVisible)
    }

    var isVisible: Bool {

        !isDimmed
    }
}
