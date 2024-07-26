//
//  ContentView.swift
//  RewindDemo
//
//  Created by 이창준 on 7/17/24.
//

import SwiftUI

import Entity
import RewindPresentation

struct ContentView: View {
    @State var selectedJourney = Journey(
        id: UUID().uuidString,
        title: "Sample",
        date: .init(start: .now),
        coordinates: [],

    var body: some View {
        RewindView(selectedJourney: $selectedJourney)
    }
}

#Preview {
    let selectedJourney = Journey(

    ContentView(selectedJourney: selectedJourney)
}
