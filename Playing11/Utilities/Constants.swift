//
//  Constants.swift
//  Playing11
//
//  Created by SAGAR THAKARE on 01/05/21.
//

import UIKit

//MARK:- Common Main Base URL
struct BaseURLData {
    static let kYahooCricketBaseURL   = "https://cricket.yahoo.net/"
}

struct BaseURL {
    
    static let playingTeam1 = BaseURLData.kYahooCricketBaseURL + "sifeeds/cricket/live/json/sapk01222019186652.json" // Pakistan vs South Africa
    static let playingTeam2 = BaseURLData.kYahooCricketBaseURL + "sifeeds/cricket/live/json/nzin01312019187360.json" // India vs New Zealand
}

//MARK:- API Error
struct APIError: Error, Decodable {
    let message: String
    let code: String
    let args: [String]
}

struct  ServerAPI {
struct ErrorMessages {
    static let kNoInternetConnectionMessage     = "Please check your internet connection."
    static let kCommanErrorMessage              = "Something went wrong. Please try again later."
    }
}

//MARK:- Identifire's
//  1. StoryBoard Identifires
struct StoryBoardIdentifire {
    
}
//  2. ViewController Identifires
struct ViewControllerIdentifire {
    
}
//  3. TableView Cell Identifires
struct TableViewCellIdentifire {
    
    static let kPlayerDetailsTableViewCell = "PlayerDetailsTableViewCell"
}
//  4. Collection Cell Identifires
struct CollectionViewCellIdentifire {
    
}

