////
////  List.swift
////  Todo
////
////  Created by Muhannad Alnemer on 3/4/20.
////  Copyright © 2020 Muhannad Alnemer. All rights reserved.
////
//
//import UIKit
//import MobileCoreServices
//import CloudKit
//
//class List {
//    var name: String!
//    var color : UIColor!
//    static let recordType = "List"
//    let id: CKRecord.ID
//    var todoList: [Todo]? = nil
//    
//    
//     init() {
//        self.id = CKRecord.ID()
//        self.name = ""
//        self.color = .white
//    }
//    init(record: CKRecord){
//        self.name = record["name"]
//        self.color = SystemColors(rawValue: record["color"]!)?.color
//        self.id = record.recordID
//    }
//}
//
//
//extension List:Hashable{
// static func == (l: List, r:List) -> Bool{
//        return l.id == r.id
//    }
//    
//    func hash(into hasher: inout Hasher) {
//      hasher.combine(id)
//    }
//}
