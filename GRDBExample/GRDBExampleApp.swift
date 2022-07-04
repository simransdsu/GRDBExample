//
//  GRDBExampleApp.swift
//  GRDBExample
//
//  Created by Simran Preet Singh Narang on 2022-07-04.
//

import SwiftUI

@main
struct GRDBExampleApp: App {
    
    var playerRepository = PlayerRepository()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    let players = await playerRepository.fetchAll()
                    if players?.count == 0 {
                        await generateRandomPlayers()
                    }
                }
        }
    }
    
    func generateRandomPlayers() async {
        
        for i in 1...100 {
            _ = await playerRepository.create(withName: "Player \(i)", score: Int.random(in: 1..<101))
        }
    }
}
