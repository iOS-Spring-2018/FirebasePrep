//
//  ViewController.swift
//  FirebasePrep
//
//  Created by Jon Eikholm on 08/03/2018.
//  Copyright © 2018 Jon Eikholm. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var createUserBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var ticTacToeButton: UIButton!
    @IBOutlet weak var pagingButton: UIButton!
    
    
    
    var user:User!
    var ref:DatabaseReference!
    var items:DatabaseQuery?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        showLoginForm()
       // login() // debug
      
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        
    }

    func login(){
        if let email = usernameField.text, let
            password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    print("login complete")
                    self.showControllers()
                    self.hideLoginForm()
                    self.queryFirebase()
                    //  self.performSegue(withIdentifier: "segue2", sender: self)
                } else {
                    print(error ?? "unknown error")
                    self.hideControllers()
                }
            }
        }
    }
    
    func logout(){
        do {
        try Auth.auth().signOut()
            print("signed out")
            items?.removeAllObservers()
            hideControllers()
            showLoginForm()

        }catch {
            print("error signing out")
            print(error)
        }
    }
    
    func createUser(){
        if let email = usernameField.text, let
            password = passwordField.text {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("user created")
                    self.showControllers()
                    self.hideLoginForm()
                    self.queryFirebase()
                }else {
                    print("error in new user \(error!)")
                }
            })
        }
    }
 

    fileprivate func queryFirebase() {
        items = ref.child("todolist").queryOrdered(byChild: "text")
        items?.observe(.value, with: { (snapshot) in
            print("received update")
            self.textView.text = ""
            for child in snapshot.children {
                let item = TodoItem(snapshot: child as! DataSnapshot)

            self.textView.text = self.textView.text + item.text + "\n"
           }
        })
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if let text = textField.text {
            //ref.child("users/user/name").setValue(text)
            //ref.child("todolist").setValue(text)
            let newItemRef = ref.child("todolist").childByAutoId()
//            let newItem = ["id" : newItemRef.key, "text": text]
//            newItemRef.setValue(newItem)
            let todoItem = TodoItem(id: newItemRef.key, textVar: text)
            newItemRef.setValue(todoItem.toDictionary())
            print("added \(text) to Firebase")
            textField.text = ""
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        login()
    }
    @IBAction func logoutPressed(_ sender: UIButton) {
        logout()
    }
    
    @IBAction func createUserPressed(_ sender: UIButton) {
        createUser()
    }
    
    func hideLoginForm(){
        usernameField.isHidden = true
        passwordField.isHidden = true
        loginBtn.isHidden = true
        createUserBtn.isHidden = true
        ticTacToeButton.isHidden = false
        pagingButton.isHidden = false
    }
    
    func showLoginForm(){
        usernameField.isHidden = false
        passwordField.isHidden = false
        loginBtn.isHidden = false
        createUserBtn.isHidden = false
        ticTacToeButton.isHidden = true
        pagingButton.isHidden = true
    }
    
    fileprivate func showControllers() {
        self.textView.isHidden = false
        self.textField.isHidden = false
        self.addButton.isHidden = false
        self.logoutBtn.isHidden = false
     
    }
    
    fileprivate func hideControllers() {
        self.textView.isHidden = true
        self.textField.isHidden = true
        self.addButton.isHidden = true
        self.logoutBtn.isHidden = true

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func ticTacToePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "segue1", sender: self)
    }
    
    @IBAction func pagingPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "segue2", sender: self)
    }
    
}

// Firebase rules, to require authentication:
//{
//    "rules": {
//        ".read": "auth != null",
//        ".write": "auth != null"
//    }
//}
// no authentication:
//{
//    "rules": {
//        ".read": true,
//        ".write": true
//    }
//}
