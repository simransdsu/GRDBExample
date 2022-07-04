//
//  Player.swift
//  GRDBExample
//
//  Created by Simran Preet Singh Narang on 2022-07-04.
//

import Foundation
import GRDB

struct Player: Codable, FetchableRecord, PersistableRecord {
    
    var id: String
    var name: String
    var score: Int
}
