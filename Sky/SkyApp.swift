//
//  SkyApp.swift
//  Sky
//
//  Created by rasti najim on 3/14/22.
//

import SwiftUI
import KeychainSwift

@main
struct SkyApp: App {
    @State private var isAuthenticated: Bool
    
    init() {
        let keychain = KeychainSwift()
        let token = keychain.get("token")
        print(token ?? "app lunched")
        if token != nil {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                ContentView()
            } else {
                WelcomeView()
            }
        }
    }
}
