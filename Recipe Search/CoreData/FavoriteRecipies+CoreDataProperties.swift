//
//  FavoriteRecipies+CoreDataProperties.swift
//  Recipe Search
//
//  Created by Полина Михайлова on 08.06.2024.
//
//

import Foundation
import CoreData


extension FavoriteRecipies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteRecipies> {
        return NSFetchRequest<FavoriteRecipies>(entityName: "FavoriteRecipies")
    }

    @NSManaged public var label: String?
    @NSManaged public var ingredients: String?
    @NSManaged public var image: String?

}

extension FavoriteRecipies : Identifiable {

}
