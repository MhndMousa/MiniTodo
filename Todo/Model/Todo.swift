//
//  Todo.swift
//  Todo
//
//  Created by Muhannad Alnemer on 2/20/20.
//  Copyright © 2020 Muhannad Alnemer. All rights reserved.
//

import Foundation
import MobileCoreServices

class Todo: NSObject,Codable, NSItemProviderReading, NSItemProviderWriting{
     
    
    let id = UUID()
    let string:String
    var status: TodoStatus
    init(string: String, status: TodoStatus) {
        self.string = string
        self.status = status
    }
    
    static var writableTypeIdentifiersForItemProvider: [String]{
        return [(kUTTypeData) as String]
    }
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        
        
        let progress = Progress(totalUnitCount: 100)
        // 5
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(self)
            let json = String(data: data, encoding: String.Encoding.utf8)
            progress.completedUnitCount = 100
            completionHandler(data, nil)
        } catch {
     
            completionHandler(nil, error)
        }
        
        return progress
    }

    // 1
    static var readableTypeIdentifiersForItemProvider: [String] {
            return [(kUTTypeData) as String]
        }
    // 2
        static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
            let decoder = JSONDecoder()
            do {
                let myJSON = try decoder.decode(Self.self, from: data)
                return myJSON
            } catch {
                fatalError("Err")
            }
            
        }
    
    
    
    
}
