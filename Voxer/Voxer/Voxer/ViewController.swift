//
//  ViewController.swift
//  Voxer
//
//  Created by Hrishi Amravatkar on 7/12/18.
//  Copyright © 2018 Hrishi Amravatkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Network call to get url
        getSessionData(success: { (resultDict) in
            print(resultDict)
        }) { (error) in
            print(error)
        }
    }
    
    func getSessionData(success: @escaping (_ success: Dictionary<String, Any>) -> Void, failure: @escaping (_ failure: Error) -> Void) {
        let Url = String(format: "https://jpc1-julian.voxer.com/3/cs/start_session")
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = ["user_identifier" : "hrishi@voxer.com", "response" : "2504a7affbe06c23c32471c950e7aaa791aadcd74ba5700ddbc4f3dd2b3c37221c21c14d176cbce546f984c8b670afe93c8e42090a9b523c1a04ddf3d4a798a2", "system_name" : "ios", "client_version": "3.0"]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    if let resultDict = json as? [String: Any] {
                        var address : String = String()
                        if let nestedDictionary = resultDict["home_router"] as? [String: Any] {
                            address = nestedDictionary["address"] as! String
                        }
                        self.getTimeline(hostAddress: address, sessionKey: resultDict["Rv_session_key"] as! String, success: { (timelineDict) in
                            print(timelineDict)
                        }, failure: { (error) in
                            print(error)
                        })
                    }

                }catch {
                    print(error)
                }
            }
            }.resume()
    }
    
    func getTimeline(hostAddress: String!, sessionKey: String!, success: @escaping (_ success: Dictionary<String, Any>) -> Void, failure: @escaping (_ failure: Error) -> Void) {
        
        let url = String(format: "https://\(hostAddress!)/3/cs/timeline?Rv_session_key=\(sessionKey!)")
        guard let serviceUrl = URL(string: url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let resultString: String =  (String(data: data, encoding: String.Encoding.utf8) as String?)!
                    let outputString = resultString.replacingOccurrences(of: "\r\n", with: "")
                    print(outputString)
                    
                    let data = outputString.data(using: .utf8)!
                    do {
                        if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                        {
                            print(jsonArray)
                        } else {
                            print("bad json")
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                    
                    //let json = try JSONSerialization.jsonObject(with: data, options: [])
                    //print(json)
                }catch {
                    print(error)
                }
            }
            }.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

