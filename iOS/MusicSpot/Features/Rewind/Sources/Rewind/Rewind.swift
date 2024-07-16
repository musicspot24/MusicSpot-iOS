//
//  Rewind.swift
//  Rewind
//
//  Created by 이창준 on 7/15/24.
//

import SwiftUI

@MainActor
extension Rewind: View {
    public var body: some View {
        TabView(selection: $selectedJourney) {
            ForEach(selectedJourney.spots) { spot in
                Text(spot.id)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
