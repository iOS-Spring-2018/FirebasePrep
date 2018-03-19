//
//  TodoItem.swift
//  FirebasePrep
//
//  Created by Jon Eikholm on 08/03/2018.
//  Copyright © 2018 Jon Eikholm. All rights reserved.
//

import Foundation
import FirebaseDatabase
class TodoItem{
    
    var text:String
    var id:String
    init(id:String, textVar:String){
        text = textVar
        self.id = id
    }
    
    init(snapshot: DataSnapshot){
        let snapshotValue = snapshot.value as! [String:String]
        text = snapshotValue["text"] ?? "empty text"
        id = snapshotValue["id"] ?? "empty id"
        
    }
    
    func toDictionary() -> Any {
        return ["text":text, "id":id]
    }
    
}
