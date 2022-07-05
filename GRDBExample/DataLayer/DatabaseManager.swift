//
//  Database.swift
//  GRDBExample
//
//  Created by Simran Preet Singh Narang on 2022-07-04.
//

import Foundation
import GRDB

struct DatabaseManager {
    
    public static let shared = DatabaseManager()
    
    public var dbQueue: DatabaseQueue?
    
    private init() {
        
        let databaseURL = try? FileManager.default
            .url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db.sqlite")
        dbQueue = try? DatabaseQueue(path: databaseURL?.path ?? "")
        
        try? dbQueue?.write { db in
            
            try? db.create(table: "player") { t in
                t.column("id").primaryKey()
                t.column("name", .text).notNull()
                t.column("score", .integer).notNull()
            }
        }
    }
}



