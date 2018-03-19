//
//  TicViewController.swift
//  FirebasePrep
//
//  Created by Jon Eikholm on 18/03/2018.
//  Copyright © 2018 Jon Eikholm. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TicViewController: UIViewController {

    @IBOutlet weak var row1: UIView!
    let tileO = UIImage(named: "o")
    let tileX = UIImage(named: "x")
    let tileWhite = UIImage(named: "white")
    let tilesize = 97
    var last = "s"
    var ref:DatabaseReference!
    var items:DatabaseQuery?
    let key = "tictactoe"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        initializeTiles()
        clearBoard()
        queryFirebase()
        listenToNewGame()
        // Do any additional setup after loading the view.
    }

    func listenToNewGame(){
        ref.child("newgame").removeValue()
        let newGameQuery = ref.child("newgame").queryOrderedByValue()
        newGameQuery.observe(.childAdded) { (snapshot) in
            self.clearBoard()
            self.resetTiles()
        }
    }
    
    fileprivate func queryFirebase() {
        items = ref.child(key).queryOrderedByValue()
        items?.observe(.value, with: { (snapshot) in
            for child in snapshot.children {
                let item =  child as! DataSnapshot
                if item.key == "last" {
                  // print("found last \(item.key)")
                    let dict = item.value as! [String: String]
                    self.last = (dict["char"])!
                    let tile = Int(dict["tile"]!)!
                    let imgV = self.view.viewWithTag(tile)!
                    imgV.isUserInteractionEnabled = false
                }else {
                    if let symbol = item.value {
                        let symbol = String(describing: symbol)
                                        let tag = Int(item.key)!
                                        let v = self.view.viewWithTag(tag) as! UIImageView
                        if symbol == "x" {
                                    v.image = self.tileX;
                        }else if symbol == "o" {
                                    v.image = self.tileO;
                        }else if symbol == "-" {
                            v.image = self.tileWhite;
                        }
                    }
                }
            }
        })
    }
    
    func clearBoard(){
        ref.child(key).child("last").removeValue()
        for i in 1...9 {
          let newItemRef = ref.child(key).child("\(i)")
               newItemRef.setValue("-")
        }
        
        last = "s"
       
    }
    
    
    
    
    @objc func viewTapped(sender:UITapGestureRecognizer){
        let imgView_ = sender.view as! UIImageView
        let newItemRef = ref.child(key).child("\(imgView_.tag)")
        if last == "o" || last=="s" {
            
            // in relation to child("last") the following
            // .child("x")... will be available as [String:String] when querying.
            ref.child(key).child("last").setValue(["tile": "\(imgView_.tag)", "char":"x"])
            newItemRef.setValue("x")
        }else if last == "x"{
            ref.child(key).child("last").setValue(["tile": "\(imgView_.tag)", "char":"o"])
            newItemRef.setValue("o")
        }
        print("pressed button \(imgView_.tag)")
    }
    
    func initializeTiles(){
        var count = 1
        for j in 0...2 {
            for i in 0...2 {
                let imgView = UIImageView(image: tileWhite!)
                imgView.tag = count
                count += 1
                imgView.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
                imgView.addGestureRecognizer(tap)
                imgView.frame = CGRect(x: i * tilesize + (i * 2), y: j*tilesize + (j * 2), width: tilesize, height: tilesize)
                row1.addSubview(imgView)
            }
        }
    }
    
    func resetTiles(){
        for view in row1.subviews {
            view.isUserInteractionEnabled = true
        }
       
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func newGamePressed(_ sender: UIButton) {
       ref.child("newgame").childByAutoId().setValue("new Game now")
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
