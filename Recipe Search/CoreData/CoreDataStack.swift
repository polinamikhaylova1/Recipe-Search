import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteRecipe")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func deleteFromFavorites(recipe: RecipeModel) {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<FavoriteRecipies> = FavoriteRecipies.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "label == %@", recipe.label)

        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            try context.save()
        } catch {
            print("Failed to delete recipe: \(error)")
        }
    }
    func isRecipeFavorite(uri: String) -> Bool {
            let fetchRequest: NSFetchRequest<FavoriteRecipies> = FavoriteRecipies.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "uri == %@", uri)
            
            do {
                let count = try context.count(for: fetchRequest)
                return count > 0
            } catch {
                print("Failed to fetch favorite recipe: \(error)")
                return false
            }
        }
        
    func fetchFavoriteRecipe(uri: String) -> FavoriteRecipies? {
        let fetchRequest: NSFetchRequest<FavoriteRecipies> = FavoriteRecipies.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uri == %@", uri)
        
        do {
            let recipes = try context.fetch(fetchRequest)
            return recipes.first
        } catch {
            print("Failed to fetch favorite recipe: \(error)")
            return nil
        }
    }

}

