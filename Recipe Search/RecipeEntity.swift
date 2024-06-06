import Foundation
import CoreData

@objc(RecipeEntity)
public class RecipeEntity: NSManagedObject {
}

extension RecipeEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeEntity> {
        return NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
    }

    @NSManaged public var label: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var ingredients: [String]?
    @NSManaged public var calories: Double
    @NSManaged public var protein: Double
    @NSManaged public var fat: Double
    @NSManaged public var carbs: Double
}

