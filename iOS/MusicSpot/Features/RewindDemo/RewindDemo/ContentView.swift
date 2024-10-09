//
//  ContentView.swift
//  RewindDemo
//
//  Created by 이창준 on 7/17/24.
//

import SwiftUI

import Dripper
import Entity
import Rewind

struct ContentView: View {
    private let station: StationOf<RewindDripper>

    init(station: StationOf<RewindDripper>) {
        self.station = station
    }

    var body: some View {
        RewindView(station: station)
    }
}

#Preview {
    let station = Station(initialState: RewindDripper.State(journey: .sample)) {
        RewindDripper()
    }

    ContentView(station: station)
}
