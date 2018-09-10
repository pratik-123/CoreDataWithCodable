//
//  List+CoreDataProperties.swift
//  CoreDataWithCodable
//
//  Created by Pratik Lad on 10/09/18.
//  Copyright © 2018 iOS. All rights reserved.
//
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }

    @NSManaged public var body: String?
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var user_id: Int64

}
