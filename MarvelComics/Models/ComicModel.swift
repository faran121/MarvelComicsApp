//
//  ComicModel.swift
//  MarvelComics
//
//  Created by Maliks on 17/09/2023.
//

import Foundation

struct APIComicResults: Codable {
    var data: APIComicData
}

struct APIComicData: Codable {
    var count: Int
    var results: [Comic]
}

struct Comic: Identifiable, Codable {
    var id: Int
    var title: String
    var description: String?
    var thumbnail: [String: String]
    var urls: [[String: String]]
}
