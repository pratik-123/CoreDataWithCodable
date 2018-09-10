//
//  List+CoreDataClass.swift
//  CoreDataWithCodable
//
//  Created by Pratik Lad on 10/09/18.
//  Copyright © 2018 iOS. All rights reserved.
//
//

import Foundation
import CoreData

@objc(List)
public class List: NSManagedObject,Codable {
    
    ///From api response key if changed
    enum apiKey: String, CodingKey {
        case id
        case user_id = "userId"
        case title
        case body
    }

    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        
        ///Fetch context for codable
        guard let codableContext = CodingUserInfoKey.init(rawValue: "context"),
            let manageObjContext = decoder.userInfo[codableContext] as? NSManagedObjectContext,
            let manageObjList = NSEntityDescription.entity(forEntityName: "List", in: manageObjContext) else {
                fatalError("failed")
        }
        
        self.init(entity: manageObjList, insertInto: manageObjContext)
        
        let container = try decoder.container(keyedBy: apiKey.self)
        self.user_id = try container.decodeIfPresent(Int64.self, forKey: .user_id) ?? 0
        self.id = try container.decodeIfPresent(Int64.self, forKey: .id) ?? 0
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.body = try container.decodeIfPresent(String.self, forKey: .body)
    }
    
    // MARK: - encode
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: apiKey.self)
        try container.encode(user_id, forKey: .user_id)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(body, forKey: .body)
    }
}
