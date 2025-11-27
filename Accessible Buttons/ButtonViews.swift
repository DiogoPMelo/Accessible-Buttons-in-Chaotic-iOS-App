//
//  ButtonViews.swift
//  Accessible Buttons
//
//  Created by Diogo Melo on 19/11/25.
//

import SwiftUI

// MARK: Reveal Zeros
struct ZeroFreeToggle: View {
    @Binding var revealZeros: Bool

    @State private var animateGlow = false
    @State private var animateShimmer = false

    var body: some View {
        VStack {
            Text("\(revealZeros ? "No" : "Hide") Zeros (Less risk, less reward)")
                .font(.headline)

            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            colors: revealZeros
                            ? [.orange, .red]
                            : [.gray.opacity(0.5), .gray],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 180, height: 50)
                    .shadow(color: revealZeros ? Color.orange.opacity(0.7) : .black.opacity(0.2),
                            radius: revealZeros ? 15 : 5,
                            x: 0, y: 0)
                    .scaleEffect(revealZeros ? 1.05 : 1.0)
                    .overlay(
                        shimmerOverlay
                            .opacity(revealZeros ? 1 : 0)
                    )

                Text(revealZeros ? "Enabled" : "Disabled")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
            }
            .animation(.easeInOut(duration: 0.3), value: revealZeros)
            .onTapGesture {
                if !revealZeros {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        revealZeros = true
                    }
                    animateGlowEffect()
                }
            }
        }
        .padding(.top, 10)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(revealZeros ? "No" : "Hide") Zeros (Less risk, less reward)")
        .accessibilityAddTraits(!revealZeros ? .isButton : .isStaticText)
    }

    // MARK: - Glow + Shimmer Effects

    private var shimmerOverlay: some View {
        GeometryReader { geo in
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.0),
                                 .white.opacity(0.6),
                                 .white.opacity(0.0)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: geo.size.width, height: geo.size.height)
                .offset(x: animateShimmer ? geo.size.width : -geo.size.width)
                .onAppear {
                    guard revealZeros else { return }
                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                        animateShimmer = true
                    }
                }
        }
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }

    private func animateGlowEffect() {
        animateGlow = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            animateGlow = false
        }
    }
}

// MARK: Forfeit Button
struct ForfeitButton: View {
    @Binding var showingResults: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [.black, .gray],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 260, height: 70)
                .shadow(color: .black.opacity(0.6), radius: 10, x: 0, y: 4)

            HStack(spacing: 8) {
                Image(systemName: "skull")
                    .font(.title)
                    .foregroundColor(.white.opacity(0.9))
                Text("Forfeit Challenge")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
            }
        }
        .padding(.bottom, 40)
        .onTapGesture {
            showingResults.toggle()
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: Restart button
struct RestartButton: View {
    var action: () -> Void

    var body: some View {
        ZStack {
            // Cartoonish blob background
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.pink.opacity(0.8), .purple.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 70)
                .shadow(color: .purple.opacity(0.4), radius: 12, x: 0, y: 6)

            // Decorative icons floating around
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .font(.title2)
                    .rotationEffect(.degrees(-20))
                    .offset(y: -4)

                Text("Play Again?")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .shadow(radius: 1)

                Image(systemName: "arrow.clockwise")
                    .font(.title2)
                    .rotationEffect(.degrees(20))
                    .offset(y: 4)
            }
        }
        .padding(.horizontal, 30)
        .onTapGesture {
            action()
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }
}
