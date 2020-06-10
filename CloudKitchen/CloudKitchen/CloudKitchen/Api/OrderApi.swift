//
//  OrderApi.swift
//  CloudKitchen
//
//  Created by Hrishi Amravatkar on 6/6/20.
//  Copyright © 2020 Hrishi Amravatkar. All rights reserved.
//

import Foundation

public class OrderApi {
    
    func fetchOrders(success: @escaping(_ results: [Order]) -> Void, failure : @escaping(_ error:Error) -> Void) {
        
        //Load data from json file.
        if Bundle.main.path(forResource: "orders", ofType: "json") != nil {
            
            if let url = Bundle.main.url(forResource: "orders", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    
                    let jsonResult: Array = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                    var orders = [Order]()
                    for orderValue in jsonResult {
                        let order = Order(orderValue as! [String : Any])
                        orders.append(order)
                    }
                    success(orders)
                    
                } catch {
                    print("Error!! Unable to parse  json")
                }
            }
        }
    }
}
