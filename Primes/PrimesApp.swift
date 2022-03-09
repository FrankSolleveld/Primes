//
//  PrimesApp.swift
//  Primes
//
//  Created by Frank Solleveld on 09/03/2022.
//

import SwiftUI
import ComposableArchitecture

@main
struct PrimesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store:
                Store(
                    initialValue: AppState(),
                    reducer: with(
                        appReducer,
                        compose(
                            logging,
                            activityFeed
                        )
                    )
                )
            )
        }
    }
}
