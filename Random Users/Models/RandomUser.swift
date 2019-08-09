//
//  RandomUser.swift
//  Random Users
//
//  Created by Sean Acres on 8/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct RandomUser: Decodable {
    let name: String
    let email: String
    let phone: String
    let imageURL: String
    
    enum RandomUserKeys: String, CodingKey {
        case name
        case email
        case phone
        case imageURL = "picture"
        
        enum NameKeys: String, CodingKey {
            case first
            case last
        }
        
        enum PictureKeys: String, CodingKey {
            case large
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RandomUserKeys.self)
        
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        
        let nameContainer = try container.nestedContainer(keyedBy: RandomUserKeys.NameKeys.self, forKey: .name)
        
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        let lastName = try nameContainer.decode(String.self, forKey: .last)
        
        name = "\(firstName) \(lastName)"
        
        let imageURLContainer = try container.nestedContainer(keyedBy: RandomUserKeys.PictureKeys.self, forKey: .imageURL)
        
        let imageURL = try imageURLContainer.decode(String.self, forKey: .large)
        self.imageURL = imageURL
    }
}

struct RandomUserResults: Decodable {
    let results: [RandomUser]
}
