//
//  Attributes.swift
//  project-book-series
//
//  Created by 유영웅 on 3/24/25.
//

import Foundation

// MARK: - Attributes
struct Attributes: Codable {
    let title, author: String
    let pages: Int
    let releaseDate, dedication, summary: String
    let wiki: String
    let chapters: [Chapter]

    enum CodingKeys: String, CodingKey {
        case title, author, pages
        case releaseDate = "release_date"
        case dedication, summary, wiki, chapters
    }
}
