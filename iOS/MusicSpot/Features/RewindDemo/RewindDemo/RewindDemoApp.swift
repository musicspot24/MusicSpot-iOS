//
//  RewindDemoApp.swift
//  RewindDemo
//
//  Created by 이창준 on 7/17/24.
//

import SwiftUI

import Dripper
import Rewind

@main
struct RewindDemoApp: App {
    private let station = Station(initialState: RewindDripper.State(selectedJourney: .sample)) {
        RewindDripper()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(station: station)
        }
    }
}
