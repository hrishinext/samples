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
    var hotShelf: [String: Order] = [:]
    var coldShelf: [String: Order] = [:]
    var frozenShelf: [String: Order] = [:]
    var overflowShelf: [String:Order] = [:]
    var timer: Timer?
    var courierTimer: Timer?
    var orderAgeTimer: Timer?
    var orderShelfLifeTimer: Timer?
    var currentOrderCount: Int = 0
    var orderAgeLookup: [String: Order] = [:]
    @IBOutlet var orderStatusLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var shelfLabel: UILabel!
    @IBOutlet weak var decayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ordersTableView.delegate = self
        self.ordersTableView.dataSource = self
        
        let orderApi = OrderApi()
        orderApi.fetchOrders(success: { [weak self] (ordersArray) in
            guard let self = self else { return }
            self.orders = ordersArray
            
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: true)
            
        }) { (error) in
            print(error)
        }
        
        self.courierTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {  [weak self] (timer) in
            guard let self = self else { return }
            let randomCourierTime = Int.random(in: 2 ... 6)
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(randomCourierTime)) {
                //courier arrives and takes the order
                self.orderStatusLabel.text = "Courier pickedup order!"
                //pickup order
                self.pickupOrder(timer)
            }
        })
        
        self.orderAgeTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
            guard let self = self else { return }
            for (key, valueOrder) in self.orderAgeLookup {
                var value = valueOrder
                value.orderAge += 1
                self.orderAgeLookup[key] = value
            }
        })
        
        self.orderShelfLifeTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self](timer) in
             guard let self = self else { return }
            //process all the lookups and check the value.
            for (key, orderValue) in self.orderAgeLookup {
                
                let value = Utils.calculateOrderValue(orderValue)
                if value <= 0 {
                    //remove that order from the list
                    //how do i remove that order from the list.
                    self.orderAgeLookup[key] = nil
                }
            }
        })
    }
    
    @objc func fireTimer() {
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
        }
    }
    
    func processIncomingOrders(_ incomingOrders: [Order]) {
        //process the order in different groups
        for order in incomingOrders {
            if order.shelfType == .hot && self.hotShelf.count < 10 {
                self.hotShelf[order.orderId] = order
            }
            else if order.shelfType == .cold && self.coldShelf.count < 10 {
                self.coldShelf[order.orderId] = order
            }
            else if order.shelfType == .frozen && self.frozenShelf.count < 10 {
                self.frozenShelf[order.orderId] = order
            }
            else if self.overflowShelf.count < 15 {
                self.overflowShelf[order.orderId] = order
            }
            else {
                //remove random order from overflowShelf
                //let randomOrder = Int.random(in: 0 ..< self.overflowShelf.count)
                let randomOrder = self.overflowShelf.randomElement()
                self.overflowShelf[randomOrder!.key] = nil
                //self.overflowShelf.append(order)
            }
            self.orderAgeLookup[order.orderId] = order
        }
        DispatchQueue.main.async {
            self.ordersTableView.reloadData()
        }
    }
    
    func pickupOrder(_ timer: Timer) {
        var pickedupOrder: Order?
        if self.hotShelf.count > 0 {
            pickedupOrder = self.hotShelf.randomElement()!.value
            self.hotShelf[pickedupOrder!.orderId] = nil
        }
        else if self.coldShelf.count > 0 {
            pickedupOrder = self.coldShelf.randomElement()!.value
            self.coldShelf[pickedupOrder!.orderId] = nil
        }
        else if self.frozenShelf.count > 0 {
            pickedupOrder = self.frozenShelf.randomElement()!.value
            self.frozenShelf[pickedupOrder!.orderId] = nil
        }
        else if self.overflowShelf.count > 0 {
            pickedupOrder = self.overflowShelf.randomElement()!.value
            self.overflowShelf[pickedupOrder!.orderId] = nil
        } else {
            //all orders empty and no orders left.
            print("all orders successfully delivered")
            self.orderStatusLabel.text = "All orders delivered!"
            self.orderIdLabel.text = ""
            self.orderName.text = ""
            self.tempLabel.text = ""
            self.shelfLabel.text = ""
            self.decayLabel.text = ""
            timer.invalidate()
        }
        if let pickedupOrder = pickedupOrder {
            self.orderIdLabel.text = pickedupOrder.orderId
            self.orderName.text = pickedupOrder.name
            self.tempLabel.text = pickedupOrder.temp
            self.shelfLabel.text = String(pickedupOrder.shelfLife)
            self.decayLabel.text = String(pickedupOrder.decayRate)
        }

        self.ordersTableView.reloadData()
    }

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
             cell.capacity.text = "\(self.overflowShelf.count)"
         }

         return cell
     }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 100
     }
}
