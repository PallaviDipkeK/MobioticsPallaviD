//
//  VideoListModel.swift
//  MobioticsPallaviD
//
//  Created by Administrator on 03/04/20.
//  Copyright © 2020 Administrator. All rights reserved.
//

import Foundation
// MARK: - VideoListModel
struct VideoListModel: Codable {
    let description, id: String?
    let thumb: String?
    let title: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case description
        case id, thumb, title, url
    }
}
