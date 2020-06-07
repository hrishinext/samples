//
//  KitchenTableViewController.swift
//  CloudKitchen
//
//  Created by Hrishi Amravatkar on 6/6/20.
//  Copyright © 2020 Hrishi Amravatkar. All rights reserved.
//

import UIKit

class KitchenTableViewController: UITableViewController {

    var orders: [Order] = []
    var hotShelf: [Order] = []
    var coldShelf: [Order] = []
    var frozenShelf: [Order] = []
    var overflowShelf: [Order] = []
    var timer: Timer?
    var currentOrderCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let orderApi = OrderApi()
        orderApi.fetchOrders(success: { (ordersArray) in
            self.orders = ordersArray
            
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: true)
            
            //process the data
        }) { (error) in
            print(error)
        }
    }
    
    @objc func fireTimer() {
        print("Timer fired!")
        if self.currentOrderCount >= self.orders.count {
            timer?.invalidate()
        } else {
            var currentOrders: [Order] = []
            currentOrders.append(self.orders[self.currentOrderCount])
            self.currentOrderCount += 1
            currentOrders.append(self.orders[self.currentOrderCount])
            self.currentOrderCount += 1
            self.processIncomingOrders(currentOrders)
        }
    }
    
    func processIncomingOrders(_ incomingOrders: [Order]) {
        //process the order in different groups
        for order in incomingOrders {
            if order.temp == "hot" {
                self.hotShelf.append(order)
            }
            if order.temp == "cold" {
                self.coldShelf.append(order)
            }
            if order.temp == "frozen" {
                self.frozenShelf.append(order)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! CustomTableViewCell

        if indexPath.row == 0 {
            cell.kitchenName.text = "Hot shelf"
            cell.capacity.text = "\(self.hotShelf.count)"
        }
        if indexPath.row == 1 {
            cell.kitchenName.text = "Cold shelf"
            cell.capacity.text = "\(self.coldShelf.count)"
        }
        if indexPath.row == 2 {
            cell.kitchenName.text = "Frozen shelf"
            cell.capacity.text = "\(self.frozenShelf.count)"
        }
        if indexPath.row == 3 {
            cell.kitchenName.text = "Overflow shelf"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
