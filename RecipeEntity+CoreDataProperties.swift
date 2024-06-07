//
//  RecipeEntity+CoreDataProperties.swift
//  Recipe Search
//
//  Created by Полина Михайлова on 07.06.2024.
//
//

import Foundation
import CoreData


extension RecipeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeEntity> {
        return NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
    }

    @NSManaged public var label: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var ingredients: String?

}

