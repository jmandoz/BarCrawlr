//
//  BarController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/27/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

private let apiKey = "gAa_9Vm0dDzqXeQSal7BbLzryWdwCt-vyW-t7fi2LDRrLb5sFgzUESHDVdZNDUV-mPAoJJxwvHJaC-sD-kATeUIi2h_mBrGA9g9dBOeN9W1IBVhlmNzoTKOcqCQyXXYx"

class BarController {
    
    let barResults: [Bars] = []
    
    
    //Base URL
    static let baseURL = URL(string: "https://api.yelp.com/v3/businesses/search")
    
    //Shared Instance
    static let shared = BarController()
    
    //Fetch Restaurant/Bar function
    func fetchBarFrom(Search searchQuery: String, lat: Double, long: Double, completion: @escaping ([Bars]?) ->  Void) {
        guard let baseUrl = URL(string: "https://api.yelp.com/v3/businesses/search") else {completion(nil); return}
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        let barSearchQuery = URLQueryItem(name: "term", value: searchQuery)
        let latitude = URLQueryItem(name: "latitude", value: "\(lat)")
        let longitude = URLQueryItem(name: "longitude", value: "\(long)")
        components?.queryItems = [barSearchQuery, latitude, longitude]
        guard let finalURL = components?.url else {completion(nil); return}
        var request = URLRequest(url: finalURL)
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        print(request)
        print(finalURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let data = data else {completion(nil); return}
            do {
                let jsdecoder = JSONDecoder()
                let topLevelJson = try jsdecoder.decode(TopLevelJSON.self, from: data)
                completion(topLevelJson.businesses)
            } catch {
                print("failed to decode the data")
                completion(nil)
                return
            }
        }.resume()
    }
    
    func fetchBarImage(imageURL: String?, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = imageURL else {return}
        guard let urlOfString = URL(string: imageURL) else {return}
        
        URLSession.shared.dataTask(with: urlOfString) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("Couldn't fetch the data")
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        } .resume()
    }
    
    
}
