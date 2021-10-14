//
//  LeagueStandingResponse.swift
//  LattSports
//
//  Created by dnlatt on 1/10/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import Foundation

struct LeagueStandingResponse: Codable {
    let welcomeGet: String
    let parameters: Parameters
    let errors: [String]
    let results: Int
    let paging: Paging
    let response: [Response]

    enum CodingKeys: String, CodingKey {
        case welcomeGet = "get"
        case parameters, errors, results, paging, response
    }
}

// MARK: - Paging
struct Paging: Codable {
    let current, total: Int
}

// MARK: - Parameters
struct Parameters: Codable {
    let league, season: String
}

// MARK: - Response
struct Response: Codable {
    let league: League
}

// MARK: - League
struct League: Codable {
    let id: Int
    let name: Name
    let country: String
    let logo: String
    let flag: String
    let season: Int
    let standings: [[Standing]]
}

enum Name: String, Codable {
    case premierLeague = "Premier League"
}

// MARK: - Standing
struct Standing: Codable {
    let rank: Int
    let team: Team
    let points, goalsDiff: Int
    let group: Name
    let form: String
    let status: Status
    let standingDescription: String?
    let all, home, away: All
    let update: String

    enum CodingKeys: String, CodingKey {
        case rank, team, points, goalsDiff, group, form, status
        case standingDescription = "description"
        case all, home, away, update
    }
}

// MARK: - All
struct All: Codable {
    let played, win, draw, lose: Int
    let goals: Goals
}

// MARK: - Goals
struct Goals: Codable {
    let goalsFor, against: Int

    enum CodingKeys: String, CodingKey {
        case goalsFor = "for"
        case against
    }
}

enum Status: String, Codable {
    case same = "same"
}

// MARK: - Team
struct Team: Codable {
    let id: Int
    let name: String
    let logo: String
}
