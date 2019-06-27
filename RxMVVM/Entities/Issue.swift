//
//  Issue.swift
//  RxMVVM
//
//  Created by Bheem Singh on 27/06/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import Foundation

struct Issue: Codable {
    
    
    let title, comments_url, description, updated_at: String
    let id, number: Int
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case number
        case title = "title"
        case comments_url
        case description = "body"
        case updated_at
    }
    
    
}

extension Issue {
    
    init?(data: Data) {
        do {
            let me = try JSONDecoder().decode(Issue.self, from: data)
            self = me
        }catch {
            print(error)
            return nil
        }
    }
    
}
