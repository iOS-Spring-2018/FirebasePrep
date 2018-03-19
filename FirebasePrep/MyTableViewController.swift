//
//  MyTableViewController.swift
//  FirebasePrep
//
//  Created by Jon Eikholm on 18/03/2018.
//  Copyright © 2018 Jon Eikholm. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MyTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var ref:DatabaseReference!
    var items:DatabaseQuery?
    var itemArr = [TodoItem]()
    @IBOutlet weak var tableView: UITableView!
    var offset:UInt = 3;
    let pageSize:UInt = 5
    var totaltRows = 0
    var lastValue:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        tableView.dataSource = self
        tableView.delegate = self
        queryFirebaseForCount()
        queryFirebase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func queryFirebaseForCount(){
        items = ref.child("todolist")
        items?.observeSingleEvent(of: .value, with: { (snapshot) in
            print("counting objects: \(snapshot.childrenCount)")
            self.totaltRows = Int(snapshot.childrenCount)
        })
    }
    
    fileprivate func queryFirebase() {
        items = ref.child("todolist").queryOrdered(byChild: "text").queryLimited(toFirst: pageSize)
        items?.observeSingleEvent(of: .value, with: { (snapshot) in
            self.itemArr.removeAll()
            self.handleSnapshot(snapshot: snapshot)
        })
    }
    
    func handleSnapshot(snapshot:DataSnapshot) {
        for child in snapshot.children {
            let item = TodoItem(snapshot: child as! DataSnapshot)
            self.itemArr.append(item)
        }
        self.lastValue = (self.itemArr.last)!.text
        print("arr size \(self.itemArr.count)")
        self.tableView.reloadData()
    }
    
    @objc fileprivate func queryFirebaseAgain() {
        items = ref.child("todolist").queryOrdered(byChild: "text").queryStarting(atValue: lastValue).queryLimited(toFirst: pageSize)
        items?.observe(.value, with: { (snapshot) in
            print("received refresh")
            self.itemArr.remove(at: self.itemArr.count - 1)
            self.handleSnapshot(snapshot: snapshot)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return itemArr.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("will display \(indexPath.row)")
        if indexPath.row > self.itemArr.count - 2 && indexPath.row < totaltRows - 2{
            queryFirebaseAgain()
            print("querying again... at \(indexPath.row)")
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
        cell?.textLabel?.text = itemArr[indexPath.row].text
        return cell!
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
