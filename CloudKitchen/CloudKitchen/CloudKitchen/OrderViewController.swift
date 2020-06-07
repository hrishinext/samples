//
//  OrderViewController.swift
//  CloudKitchen
//
//  Created by Hrishi Amravatkar on 6/6/20.
//  Copyright © 2020 Hrishi Amravatkar. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {

    @IBOutlet var ordersTableView: UITableView!
    
    var orders: [Order] = []
    var hotShelf: [Order] = []
    var coldShelf: [Order] = []
    var frozenShelf: [Order] = []
    var overflowShelf: [Order] = []
    var timer: Timer?
    var currentOrderCount: Int = 0
    @IBOutlet var orderStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ordersTableView.delegate = self
        self.ordersTableView.dataSource = self
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
            self.orderStatusLabel.text = "Courier Dispatched!"
            let randomCourierTime = Int.random(in: 2 ... 6)
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(randomCourierTime)) {
                //courier arrives and takes the order
                self.orderStatusLabel.text = "Courier pickedup order!"
                //pickup order
                self.pickupOrder()
                
            }
        }
    }
    
    func processIncomingOrders(_ incomingOrders: [Order]) {
        //process the order in different groups
        for order in incomingOrders {
            if order.shelfType == .hotShelf && self.hotShelf.count <= 10 {
                self.hotShelf.append(order)
            }
            else if order.shelfType == .coldShelf && self.hotShelf.count <= 10 {
                self.coldShelf.append(order)
            }
            else if order.shelfType == .frozenShelf && self.hotShelf.count <= 10 {
                self.frozenShelf.append(order)
            }
            else if self.overflowShelf.count <= 15 {
                self.overflowShelf.append(order)
            }
            else {
                //remove random order from overflowShelf
                let randomOrder = Int.random(in: 0 ... 15)
                self.overflowShelf.remove(at: randomOrder)
                self.overflowShelf.append(order)
            }

        }
        DispatchQueue.main.async {
            self.ordersTableView.reloadData()
        }
    }
    
    func pickupOrder() {
        if self.hotShelf.count > 0 {
            self.hotShelf.remove(at: 0)
        }
        else if self.coldShelf.count > 0 {
            self.coldShelf.remove(at: 0)
        }
        else if self.frozenShelf.count > 10 {
            self.frozenShelf.remove(at: 0)
        }
        else if self.overflowShelf.count > 0 {
            self.overflowShelf.remove(at: 0)
        } else {
            //all orders empty and no orders left.
            print("all orders successfully delivered")
        }
        
        self.ordersTableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension OrderViewController : UITableViewDelegate, UITableViewDataSource {
    
     func numberOfSections(in tableView: UITableView) -> Int {
         // #warning Incomplete implementation, return the number of sections
         return 1
     }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         // #warning Incomplete implementation, return the number of rows
         return 4
     }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.ordersTableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! CustomTableViewCell

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
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 100
     }
}
