//
//  ContentView.swift
//  Accessible Buttons
//
//  Created by Diogo Melo on 18/11/25.
//

import SwiftUI
let nOfLines = 3
let fixedPrizes = ["0", "20", "0", "10",
              "1,000,000", "Electric shock",
              "0", "10", "0"]

struct ContentView: View {
@State var prizes = fixedPrizes
    @State var isHidden = true

    var body: some View {
        VStack {
            ForEach (0..<nOfLines) { line in
                HStack {
                ForEach(0..<lines) { col in

                    Button (action: {
                        isHidden.toggle()
                    }) {
                        if isHidden {
                            Text("\(makeCell(line: line, col: col).position)")
                        } else {
                            Text("\(makeCell(line: line, col: col).prize)")
                        }

                    }
                    }
                }
            }
        }
        .padding()
    }

    func makeCell(line: Int, col: Int) -> (position: Int, prize: String) {

let position = line * lines + (col + 1)

        return(position, prizes[position - 1])
    }
}

#Preview {
    ContentView()
}
