//
//  DBStock+CoreDataClass.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 23/12/2023.
//
//

import Foundation
import CoreData

@objc(DBStock)
public class DBStock: NSManagedObject {
    
    @NSManaged public var symbol: String?
    @NSManaged public var peRatio: Float

}
