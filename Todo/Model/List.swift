//
//  List.swift
//  Todo
//
//  Created by Muhannad Alnemer on 3/4/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import UIKit
import MobileCoreServices
import CloudKit

class List {
    var name: String!
    var color : UIColor!
    static let recordType = "List"
    let id: CKRecord.ID
    var todoList: [Todo]? = nil
    
    
     init() {
        self.id = CKRecord.ID()
        self.name = ""
//        self.color = Color(color: UIColor.white)
        self.color = .white
    }
    init(record: CKRecord){
        self.name = record["name"]
        self.color = SystemColors(rawValue: record["color"]!)?.color
        self.id = record.recordID
    }
    
    
//    init(name: String, color: Color){
//        self.name = name
//        self.color = color
//    }
//    init(_ d :[String:Any]){
//        self.name = d["name"] as? String
//        if d["color"] as? String == "" ||  d["color"] == nil {
//            self.color = Color(color: SystemColors(rawValue: "green")!.color)
//        }else{
//            self.color = Color(color: SystemColors(rawValue: d["color"] as! String)!.color)
//        }
//    }
//
//    init(_ d :[String:Any], id:String){
//        self.uid = id
//        self.name = d["name"] as? String
//
//        if d["color"] as? String == "" ||  d["color"] == nil {
//            self.color = Color(color: SystemColors(rawValue: "green")!.color)
//        }else{
//            self.color = Color(color: SystemColors(rawValue: d["color"] as! String)!.color)
//        }
//    }
//
//    var dictionary : [String:Any] {
//        return [
//            "name": self.name as! String,
//            "color" : self.color!.color.colorString as! String,
//            "visible" : true
//        ]
//    }
//    static var writableTypeIdentifiersForItemProvider: [String]{
//        return [(kUTTypeData) as String]
//    }
//
//    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
//        let progress = Progress(totalUnitCount: 100)
//        // 5
//        do {
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .prettyPrinted
//            let data = try encoder.encode(self)
//            let json = String(data: data, encoding: String.Encoding.utf8)
//            progress.completedUnitCount = 100
//            completionHandler(data, nil)
//        } catch {
//            completionHandler(nil, error)
//        }
//        return progress
//    }
//
//    // 1
//    static var readableTypeIdentifiersForItemProvider: [String] {
//        return [(kUTTypeData) as String]
//
//    }
//    // 2
//    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
//        let decoder = JSONDecoder()
//        do {
//            let myJSON = try decoder.decode(Self.self, from: data)
//            return myJSON
//
//        } catch {
//            fatalError("Err")
//        }
//    }
    
}


extension List:Hashable{
 static func == (l: List, r:List) -> Bool{
        return l.id == r.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
}
