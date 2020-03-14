////
////  Todo.swift
////  Todo
////
////  Created by Muhannad Alnemer on 2/20/20.
////  Copyright © 2020 Muhannad Alnemer. All rights reserved.
////
//
//import CloudKit
//
//class Todo{
//    let id : CKRecord.ID
//    var text:String!
//    var status: TodoStatus!
//    let listRefrence: CKRecord.Reference?
//    
//    init() {
//        self.id = CKRecord.ID()
//        self.text = ""
//        self.status = .unfinished
//        self.listRefrence = nil
//    }
//    
//    init(record: CKRecord){
//        id = record.recordID
//        text = record["text"]
//        status = TodoStatus(rawValue: record["status"]!)
//        listRefrence = record["list"] as? CKRecord.Reference
//    }
//    
//    var dictionary : [String:Any]{
//        return [
//            "text" : self.text,
//            "status" : self.status.rawValue,
//            "visible" : true
//        ]
//    }
//}
//
//extension Todo:Hashable{
//    static func == (lhs: Todo, rhs: Todo) -> Bool {
//      return lhs.id == rhs.id
//    }
//    
//    func hash(into hasher: inout Hasher) {
//      hasher.combine(id)
//    }
//}
