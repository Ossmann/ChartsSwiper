//
//  DBStock+CoreDataProperties.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 23/12/2023.
//
//

import Foundation
import CoreData


extension DBStock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBStock> {
        return NSFetchRequest<DBStock>(entityName: "DBStock")
    }

    @NSManaged public var symbol: String?
    @NSManaged public var peRatio: Float

}

extension DBStock : Identifiable {

}
