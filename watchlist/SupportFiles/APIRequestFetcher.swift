//
//  APIRequestFetcher.swift
//  watchlist
//
//  Created by Clay Tercek on 2/4/19.
//  Copyright © 2019 Clay Tercek. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

enum NetworkError: Error {
    case failure
    case success
}

class APIRequestFetcher {
    var searchResults = [JSON]()
    var API_key:String = "0fa1071a92f1c0ec8136cf4446839afc"
    func search(searchText: String, completionHandler: @escaping ([JSON]?, NetworkError) -> ()) {
        let urlToSearch = "https://api.themoviedb.org/3/search/multi?api_key=\(API_key)&language=en-US&query=\(searchText)&page=1&include_adult=false"
        Alamofire.request(urlToSearch).responseJSON { response in
            guard let data = response.data else {
                completionHandler(nil, .failure)
                return
            }
            
            let json = try? JSON(data: data)
            let results = json?["results"].arrayValue
            guard let empty = results?.isEmpty, !empty else {
                completionHandler(nil, .failure)
                return
            }
            //make sure we don't get people
            let filteredResults = results!.filter { $0["media_type"].stringValue != "person"  }
            completionHandler(filteredResults, .success)
        }
    }
    
    func getById(id: Int, type: String, completionHandler: @escaping (JSON?, NetworkError) -> ()) {
        let urlToSearch = "https://api.themoviedb.org/3/\(type)/\(id)?api_key=\(API_key)&language=en-US"
        print("getting url '\(urlToSearch)'")
        Alamofire.request(urlToSearch).responseJSON { response in
            guard let data = response.data else {
                print("ruh roh")
                completionHandler(nil, .failure)
                return
            }
            
            let json = try? JSON(data: data)
            completionHandler(json, .success)
        }
    }
    
    
    
    func fetchImage(url: String, completionHandler: @escaping (UIImage?, NetworkError) -> ()) {
        Alamofire.request("https://image.tmdb.org/t/p/w200/" + url).responseData { responseData in
            
            guard let imageData = responseData.data else {
                completionHandler(nil, .failure)
                return
            }
            
            guard let image = UIImage(data: imageData) else {
                completionHandler(nil, .failure)
                return
            }
            
            completionHandler(image, .success)
        }
    }
}
