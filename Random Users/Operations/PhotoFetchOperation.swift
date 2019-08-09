//
//  PhotoFetchOperation.swift
//  Random Users
//
//  Created by Sean Acres on 8/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class PhotoFetchOperation: ConcurrentOperation {
    var imageURL: String
    var imageData: Data?
    
    private var dataTask: URLSessionDataTask = URLSessionDataTask()
    
    // MARK: Functions
    init(imageURL: String) {
        self.imageURL = imageURL
    }
    
    override func start() {
        state = .isExecuting
        if let url = URL(string: imageURL) {
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                defer {
                    self.state = .isFinished
                }
                
                if let error = error {
                    NSLog("Error getting image data from url: \(error)")
                    return
                }
                
                guard let data = data else { return }
                self.imageData = data
                
            }
            
            task.resume()
            self.dataTask = task
        }
    }
    
    override func cancel() {
        dataTask.cancel()
    }
}
