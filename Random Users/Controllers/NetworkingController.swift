//
//  NetworkingController.swift
//  Random Users
//
//  Created by Sean Acres on 8/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation


class NetworkingController {
    enum NetworkError: Error {
        case otherError
        case badData
        case noDecode
        case noEncode
        case badResponse
        case badAuth
        case noAuth
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    var randomUsers: [RandomUser] = []
    let baseURL: URL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func getAlbums(completion: @escaping (NetworkError?) -> Void) {
        
        URLSession.shared.dataTask(with: baseURL) { (data, response, error) in
            if let _ = error {
                completion(.otherError)
                return
            }
            
            guard let data = data else {
                completion(.badData)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                
                self.randomUsers = try jsonDecoder.decode([RandomUser].self, from: data)
                completion(nil)
            } catch {
                print("\(error)")
                completion(.noDecode)
                print("decode failure")
            }
        }.resume()
    }
}
