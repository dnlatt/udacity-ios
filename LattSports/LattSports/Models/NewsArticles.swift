//
//  NewsArticles.swift
//  LattSports
//
//  Created by dnlatt on 28/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ArticlesResponses: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String?
    let articleDescription: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}

