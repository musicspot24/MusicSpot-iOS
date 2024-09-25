//
//  ContentView.swift
//  RewindDemo
//
//  Created by 이창준 on 7/17/24.
//

import SwiftUI

import Entity
import RewindPresentation
import RewindService

struct ContentView: View {
    @State private var service: RewindService

    init(selectedJourney: Journey) {
        service = RewindService(journey: selectedJourney)
    }

    var body: some View {
        RewindView()
            .environment(service)
    }
}

#Preview {
    ContentView(selectedJourney: .sample)
}
