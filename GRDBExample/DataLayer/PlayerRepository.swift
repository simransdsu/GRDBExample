//
//  PlayerRepository.swift
//  GRDBExample
//
//  Created by Simran Preet Singh Narang on 2022-07-04.
//

import Foundation
import GRDB

struct PlayerRepository {
    
    private let dbQueue = DatabaseManager.shared.dbQueue
    
    func create(withName name: String, score: Int) async -> Player? {
        
        let player = Player(id: UUID().uuidString, name: name, score: score)
        do {
            try await DatabaseManager.shared.dbQueue?.write({ db in
                try player.save(db)
            })
            
            return player
        } catch {
            print("❌ Failed to \(#function): \(error.localizedDescription)")
            return nil
        }
    }
    
    
    func fetchAll() async -> [Player]? {
        
        do {
            return try await dbQueue?.read({ db in
                try Player.fetchAll(db)
            })
        } catch {
            print("❌ Failed to \(#function): \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchOne(withId id: String) async -> Player? {
        
        do {
            return try await dbQueue?.read({ db in
                return try Player
                    .filter(Column("id") == id)
                    .fetchOne(db)
            })
        } catch {
            print("❌ Failed to \(#function): \(error.localizedDescription)")
            return nil
        }
    }
    
    func delete(_ player: Player) async {
        do {
            _ = try await dbQueue?.write({ db in
                try player.delete(db)
            })
        } catch {
            print("❌ Failed to \(#function): \(error.localizedDescription)")
        }
        
    }
    
    func delete(withId id: String) async {
        
        do {
            let player = await fetchOne(withId: id)
            _ = try await dbQueue?.read({ db in
                try player?.delete(db)
            })
        } catch {
            print("❌ Failed to \(#function): \(error.localizedDescription)")
        }
        
    }
    
    func update(player: Player, with updatePlayer: Player) async {
        
        do {
            try await dbQueue?.write({ db in
                var playerToUpdate = try Player.filter(Column("id") == player.id).fetchOne(db)
                playerToUpdate?.name = updatePlayer.name
                playerToUpdate?.score = updatePlayer.score
                
                try playerToUpdate?.update(db)
            })
        } catch {
            print("❌ Failed to \(#function): \(error.localizedDescription)")
        }
        
    }
}
