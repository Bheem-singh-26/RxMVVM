//
//  Comment.swift
//  RxMVVM
//
//  Created by Bheem Singh on 27/06/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import Foundation

struct Comment: Codable {
    
    
    let description: String
    let id: Int
    
    
    struct User:Codable {
        
        let name, avatar_url: String
        let id:Int
        
        enum CodingKeys: String, CodingKey {
            case name = "login"
            case id
            case avatar_url
        }
    }
    
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case description = "body"
        case user
    }
    
    
}

extension Comment {
    
    init?(data: Data) {
        do {
            let me = try JSONDecoder().decode(Comment.self, from: data)
            self = me
        }catch {
            print(error)
            return nil
        }
    }
    
}
