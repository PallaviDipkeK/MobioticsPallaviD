//
//  ListOfVideosToShow+CoreDataProperties.swift
//  
//
//  Created by Administrator on 03/04/20.
//
//

import Foundation
import CoreData


extension ListOfVideosToShow {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListOfVideosToShow> {
        return NSFetchRequest<ListOfVideosToShow>(entityName: "ListOfVideosToShow")
    }

    @NSManaged public var descriptionOfVideo: String?
    @NSManaged public var id: String?
    @NSManaged public var startTime: Float
    @NSManaged public var thumb: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?

}
