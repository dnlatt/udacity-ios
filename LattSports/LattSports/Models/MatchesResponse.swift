//
//  MatchesResponse.swift
//  LattSports
//
//  Created by dnlatt on 2/10/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//


import Foundation

// MARK: - Welcome
struct MatchResponse: Codable {
    let count: Int
    let filters: Filters
    let matches: [Match]
}

// MARK: - Filters
struct Filters: Codable {
    let dateFrom, dateTo, permission: String
    let competitions: [Int]
}

// MARK: - Match
struct Match: Codable {
    let id: Int
    let competition: Competition
    let season: Season
    let utcDate: String
    let status: MatchStatus
    let matchday: Int
    let stage: Stage
    let group: JSONNull?
    let lastUpdated: String
    let odds: Odds
    let score: Score
    let homeTeam, awayTeam: TeamName
    let referees: [Referee]
}

// MARK: - Team
struct TeamName: Codable {
    let id: Int
    let name: String
}

// MARK: - Competition
struct Competition: Codable {
    let id: Int
    let name: CompetitionName
    let area: Area
}

// MARK: - Area
struct Area: Codable {
    let name: NationalityEnum
    let code: Code
    let ensignURL: String

    enum CodingKeys: String, CodingKey {
        case name, code
        case ensignURL = "ensignUrl"
    }
}

enum Code: String, Codable {
    case eng = "ENG"
}

enum NationalityEnum: String, Codable {
    case australia = "Australia"
    case england = "England"
}

enum CompetitionName: String, Codable {
    case premierLeague = "Premier League"
}

// MARK: - Odds
struct Odds: Codable {
    let msg: Msg
}

enum Msg: String, Codable {
    case activateOddsPackageInUserPanelToRetrieveOdds = "Activate Odds-Package in User-Panel to retrieve odds."
}

// MARK: - Referee
struct Referee: Codable {
    let id: Int
    let name: String
    let role: Role
    let nationality: NationalityEnum?
}

enum Role: String, Codable {
    case assistantRefereeN1 = "ASSISTANT_REFEREE_N1"
    case assistantRefereeN2 = "ASSISTANT_REFEREE_N2"
    case fourthOfficial = "FOURTH_OFFICIAL"
    case referee = "REFEREE"
    case videoAssisantRefereeN1 = "VIDEO_ASSISANT_REFEREE_N1"
    case videoAssisantRefereeN2 = "VIDEO_ASSISANT_REFEREE_N2"
}

// MARK: - Score
struct Score: Codable {
    let winner: String?
    let duration: Duration
    let fullTime, halfTime, extraTime, penalties: ExtraTime
}

enum Duration: String, Codable {
    case regular = "REGULAR"
}

// MARK: - ExtraTime
struct ExtraTime: Codable {
    let homeTeam, awayTeam: Int?
}

// MARK: - Season
struct Season: Codable {
    let id: Int
    let startDate, endDate: String
    let currentMatchday: Int
    let winner: JSONNull?
}

enum Stage: String, Codable {
    case regularSeason = "REGULAR_SEASON"
}

enum MatchStatus: String, Codable {
    case finished = "FINISHED"
    case scheduled = "SCHEDULED"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
