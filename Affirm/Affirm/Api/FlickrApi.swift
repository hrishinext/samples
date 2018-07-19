
//
//  FlickrApi.swift
//  Affirm
//
//  Created by Hrishi Amravatkar on 7/16/18.
//  Copyright © 2018 Hrishi Amravatkar. All rights reserved.
//

import Foundation

public class FlickrApi {
    
    func searchFlickr(searchText: String, success: @escaping (_ success: [Photo]) -> Void,  failure: @escaping (_ failure: Error) -> Void) {
        var url = String(format: "https://api.flickr.com/services/rest/?method=flickr.photos.search&")
        let parameterDictionary = ["api_key" : "675894853ae8ec6c242fa4c077bcf4a0", "text" : searchText, "extras" : "url_s", "format": "json", "nojsoncallback" : "1"]
        for (key, value) in parameterDictionary {
            url.append("\(key)=\(value)&")
        }
        guard let serviceUrl = URL(string: url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    var resultArray:Array<Photo> = [Photo]()
                    if let resultDict = json as? [String: AnyObject] {
                        if let resultDictPhotos = resultDict["photos"] {
                            let arrayData: Array = resultDictPhotos["photo"] as! Array<AnyObject>
                            for photoData in arrayData {
                                let photoDict = (photoData as? Dictionary<String, Any>)!
                                print(photoData)
                                let photo : Photo = Photo(photoId: photoDict["id"] as! String, title: photoDict["title"] as! String, url: photoDict["url_s"] as? String ?? "" , height: photoDict["height_s"] as? Int ?? 0, width: photoDict["width_s"] as? Int ?? 0, owner: photoDict["owner"] as! String, secret: photoDict["secret"] as! String)
                                resultArray.append(photo)
                            }
                        }
                        success(resultArray)
                    }
                }catch {
                    print(error)
                }
            }
            }.resume()
    }
}
