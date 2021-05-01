//
//  Playing11TeamModel.swift
//  Playing11
//
//  Created by SAGAR THAKARE on 01/05/21.
//

import Foundation

struct Playing11Model: Codable {
    var Teams: TeamsModel?
}

struct TeamsModel: Codable {
    var teams: [Teams]?
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        init?(intValue: Int) { return nil }
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        var tempArray = [Teams]()
        
        for key in container.allKeys {
            let decodedObject = try container.decode(Teams.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            tempArray.append(decodedObject)
        }
        teams = tempArray
    }
}

struct Teams: Codable {
    var Name_Full: String?
    var Name_Short: String?
    var Players: PlayersModel?
}

struct PlayersModel: Codable {
    var players: [Players]?
    
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        init?(intValue: Int) { return nil }
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        var tempArray = [Players]()
        
        for key in container.allKeys {
            let decodedObject = try container.decode(Players.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            tempArray.append(decodedObject)
        }
        players = tempArray
    }
}

struct Players: Codable {
    var Position: String?
    var Name_Full: String?
    var Iscaptain: Bool?
    var Iskeeper: Bool?
    var Batting: Bating?
    var Bowling: Bowling?
}

struct Bating: Codable {
    var Style: String?
    var Average: String?
    var Strikerate: String?
    var Runs: String?
}

struct Bowling: Codable {
    var Style: String?
    var Average: String?
    var Economyrate: String?
    var Wickets: String?
}
