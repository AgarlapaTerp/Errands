//
//  MapPin+CoreDataProperties.swift
//  Errands
//
//  Created by user256510 on 4/24/24.
//
//

import Foundation
import CoreData


extension MapPin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MapPin> {
        return NSFetchRequest<MapPin>(entityName: "MapPin")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var note: NSAttributedString?
    @NSManaged public var subTitle: String?
    @NSManaged public var title: String?
    @NSManaged public var address: String?

}
