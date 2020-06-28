//
//  MovieApi.swift
//  Metal Interview
//
//  Created by Hrishi Amravatkar on 6/26/20.
//  Copyright © 2020 Hrishi Amravatkar. All rights reserved.
//

import Foundation

class MovieApi {
    
    func getListMovies(_ success: @escaping([Movie]) -> Void, _ failure: @escaping(Error) -> Void) -> Void {
        
        let url = URL(string: "http://private-anon-a8a140b857-iosinterview1.apiary-mock.com/movies/genres")
        
        guard  let urlValue = url else {
            return
        }
        
        //get shared session and async task
        URLSession.shared.dataTask(with: urlValue) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, let data = data, let error = error else {
                return
            }

            if response.statusCode == 200 {
                //here deserialize the json data
                guard let jsonArray = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: Any]] else {
                    print("Not containing JSON")
                    return
                }
                var movies = [Movie]()
                let moviesAtZero = jsonArray[0] as [String: Any]
                let moviesList = moviesAtZero["movies"] as! [[String: Any]]
                for movieDict in moviesList {
                    let movie  = Movie(movieDict)
                    movies.append(movie)
                }
                success(movies)
            } else {
                failure(error)
            }
        }.resume()
        
    }
    
}
