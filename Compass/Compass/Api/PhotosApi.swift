//
//  PhotosApi.swift
//  Compass
//
//  Created by Hrishi Amravatkar on 7/1/20.
//  Copyright © 2020 Hrishi Amravatkar. All rights reserved.
//

import Foundation

public class PhotosApi {
    
    func fetchPhotos(success: @escaping(_ results: [Photo]) -> Void, failure : @escaping(_ error:Error) -> Void) {
        //Asyncronously fetch the photos from the url
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/photos")
        
        guard let urlValue = url else {
            return
        }
        URLSession.shared.dataTask(with: urlValue) { (data, response, error) in
            
            if let error = error {
                failure(error)
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                //unmarshall
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: Any]] {
                        var photos = [Photo]()
                        for jsonObject in jsonArray {
                            let photo = Photo(jsonObject)
                            photos.append(photo)
                        }
                        success(photos)
                    }
                } catch  {
                    failure(error)
                }
            }
        }.resume()
    }
}
