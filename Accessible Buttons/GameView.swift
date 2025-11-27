//  GameView.swift
//  Accessible Buttons
//
//  Created by Diogo Melo on 18/11/25.
//

import SwiftUI
import CoreHaptics

let lines = 3
let fixedResults: [Prize] = [.zero, .zero, .ten, .fifty, .million, .shock, .ten, .zero, .zero]

// MARK: Game View
struct GameView: View {
    private var tiles = Array(1...(lines * lines))

    @State private var engine: CHHapticEngine?
    @State private var results = fixedResults.shuffled()
    @State private var revealZeros = false
    @State private var showingResults = false
    @State private var showingRules = false
    @State private var cheatMode = false
    @State var selectedValue = 0

    var body: some View {
        VStack(spacing: 30) {

            // MARK: Header
            HStack {
                Text("The Million Euro Challenge")
                    .font(.largeTitle)
                    .bold()
                    .accessibilityAddTraits(.isHeader)

                Spacer()

                // Rules "link"
                HStack(spacing: 4) {
                    Image(systemName: "questionmark.circle")
                        .font(.title3)
                    Text("Rules")
                        .font(.title3)
                        .underline()
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.0001)) // looks tappable visually but not by structure
                )
                .onTapGesture {
                    showingRules.toggle()
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Rules")
                .accessibilityHint("Double tap to see the Game's rules")
                .accessibilityAddTraits(.isButton)
            }
            .sheet(isPresented: $showingRules) {
RulesView(cheatMode: $cheatMode)
            }
            .padding(.horizontal)
            .padding(.top)

            // MARK: 3×3 Grid
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3),
                spacing: 15
            ) {
                ForEach(tiles, id: \.self) { number in
                    if !showingResults {
                        TileView(display: tileValueFor(number), isDimmed: dimTile(number))
                                                    .onTapGesture {
                                                        if (!dimTile(number)) {
                                                            placeBet(on: number)
                                                        }
                                                    }
                                                    .accessibilityHint(cheatMode ? getValueFor(number).getValue(revealZeros: revealZeros) : "")
                    } else {
                        OutcomeTile(prize: getValueFor(number), revealZeros: revealZeros, isSelected: selectedValue == number, isDimmed: dimTile(number))
                            .accessibilityHint("Position \(number)")
                    }
                }
            }
            .padding(.horizontal)


            // MARK: Toggles
            if showingResults {
                RestartButton(action: restart)
            } else {
                ZeroFreeToggle(revealZeros: $revealZeros)

                Spacer()

                ForfeitButton(showingResults: $showingResults)
            }
        }
        .onAppear(perform: prepareHaptics)
    }

    func getValueFor(_ number: Int) -> Prize {

        results[number - 1]
    }

    func tileValueFor(_ number: Int) -> String {

        let value = getValueFor(number)

        switch (showingResults, revealZeros) {
            case (true, _):
                return value.getValue(revealZeros: revealZeros)
            case (false, true):
                return value == .zero ?
                value.getValue(revealZeros: revealZeros) :
"\(number)"
            default:
return "\(number)"
        }
    }

    func dimTile(_ number: Int) -> Bool {

        let value = getValueFor(number)
        return (showingResults && value != .million && value != .shock) ||
        revealZeros && value == .zero
    }

    func placeBet(on number: Int) {

        selectedValue = number
        let value = getValueFor(number)
        showingResults = true

        if value == .million {
victoryVibe()
        } else if value == .shock {
            shockSimulation(revealZeros)
        } else {
            hapticFailure()
        }
    }

    func restart () {

        selectedValue = 0
        showingResults = false
        revealZeros = false
        results.shuffle()
    }

    func hapticSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    func hapticFailure() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    func victoryVibe() {

        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        for i in stride(from: 0.5, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i + 0.2)
            events.append(event)
        }


        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }

    func shockSimulation(_ softened: Bool ) {

        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

                for i in stride(from: 1, to: 2, by: 0.1) {
                    let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i + (softened ? 0 : 1)))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i - 1)
            events.append(event)
        }

        if (!softened) {
            for i in stride(from: 1, to: 2, by: 0.1) {
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(3 - i))
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(3 - i))
                let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
                events.append(event)
            }
        }

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }

    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
}

// MARK: Logic
enum Prize {

    case million, shock, fifty, ten, zero

    func getValue(revealZeros: Bool) -> String {
        switch (self, revealZeros) {
            case (.shock, _):
                return "⚡"
            default:
                return "\(money(revealZeros: revealZeros))"
        }
    }

    private func money (revealZeros: Bool) -> Int {

        let amount: Int
        switch (self) {
            case .million:
                amount = 1000000
            case .fifty:
                amount = 50
            case .ten:
                amount = 10
            default:
                amount = 0
        }
        let divisor = revealZeros ? 2 : 1

        return amount / divisor
    }


}

#Preview {
    GameView()
}
