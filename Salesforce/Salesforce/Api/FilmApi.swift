//
//  FilmApi.swift
//  Salesforce
//
//  Created by Hrishi Amravatkar on 7/24/18.
//  Copyright © 2018 Hrishi Amravatkar. All rights reserved.
//

import Foundation

class FilmApi {
    
    let baseUrl = "http://www.omdbapi.com/?"
    let apiKey = "837f0e6a"
    
    func fetchFilms(searchText: String,success: @escaping([Film]) -> Void, failure: @escaping(Error) -> Void){
        let parameterDictionary = ["apikey": apiKey,"s" : searchText]
        var currentBaseUrl = baseUrl
        for (key, value) in parameterDictionary {
            currentBaseUrl.append("\(key)=\(value)&")
        }
        print("urlString \(currentBaseUrl)")
        guard let serviceUrl = URL(string: currentBaseUrl) else {return}
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200  {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        var resultArray:Array<Film> = []
                        let dispatchGroup = DispatchGroup()
                        if let resultDict = json as? [String: AnyObject] {
                            let arrayData: Array = resultDict["Search"] as! Array<AnyObject>
                            for filmData in arrayData {
                                //Code where you want to make an syncronous call.
                                dispatchGroup.enter()
                                let filmDict = filmData as! Dictionary<String, AnyObject>
                                self.setFilmDetails(filmTitle: filmDict["Title"] as! String , success: { (plot, director) in
                                    let film = Film(title: filmDict["Title"] as! String, year: filmDict["Year"] as! String, director: director, poster: filmDict["Poster"] as! String, plot: plot)
                                    resultArray.append(film)
                                    dispatchGroup.leave()
                                })
                            }
                        }
                        dispatchGroup.notify(queue: .main) {
                            print("Finished all requests.")
                            success(resultArray)
                        }
        
                    } catch {
                        failure(error)
                    }
                }
            }
        }.resume()
    }
    
    
    func setFilmDetails(filmTitle: String, success:@escaping (String, String) -> Void) {
        var currentBaseUrl = baseUrl
        let parameterDictionary = ["apikey": apiKey,"t" : filmTitle]
        for (key, value) in parameterDictionary {
            let valueEncoded: String = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            currentBaseUrl.append("\(key)=\(valueEncoded)&")
        }
        guard let serviceUrl = URL(string: currentBaseUrl) else {return}
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        let filmDetails = json as! Dictionary<String, AnyObject>
                        success(filmDetails["Plot"] as? String ?? "", filmDetails["Director"] as? String ?? "")
                    } catch {
                        print(error)
                    }
                }
            }
        }).resume()
    }
        
    
}
