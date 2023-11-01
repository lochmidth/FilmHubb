//
//  CoreDataManager.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 31.10.2023.
//

import UIKit
import CoreData

private let entityName = "FavoriteMovies"

protocol CoreDataManaging {
    func createCoreData(forMovie movie: Movie, completion: @escaping() -> Void)
    func fetchAllCoreData(completion: @escaping(Int, String) -> Void)
    func fetchCoreData(forMovie movie: Movie, completion: @escaping(Int, String) -> Void)
    func deleteCoreData(forMovie movie: Movie, completion: @escaping() -> Void)
    func deleteAllData(completion: @escaping() -> Void)
}

class CoreDataManager: CoreDataManaging {
    
    private let application: UIApplication
    
    init(application: UIApplication = UIApplication.shared) {
        self.application = application
    }
    
    func createCoreData(forMovie movie: Movie, completion: @escaping() -> Void) {
        guard let appDelegate = application.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let movieEntity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        
        let posterImageUrl = movie.posterPath
        let id = movie.id
        
        let movie = NSManagedObject(entity: movieEntity, insertInto: managedContext)
        movie.setValue(posterImageUrl, forKey: "posterImageUrl")
        movie.setValue(id, forKey: "id")
        
        do {
            try managedContext.save()
            completion()
        } catch {
            print("DEBUG: Error while saving favorite movie to core data, \(error.localizedDescription)")
        }
    }
    
    func fetchAllCoreData(completion: @escaping(Int, String) -> Void) {
        guard let appDelegate = application.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let posterImageUrl = data.value(forKey: "posterImageUrl")
                let id = data.value(forKey: "id")
                completion(id as! Int, posterImageUrl as! String)
            }
        } catch {
            print("DEBUG: Error while fetching the core data, \(error.localizedDescription)")
        }
    }
    
    func fetchCoreData(forMovie movie: Movie, completion: @escaping(Int, String) -> Void) {
        guard let appDelegate = application.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %i", movie.id)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let posterImageUrl = data.value(forKey: "posterImageUrl")
                let id = data.value(forKey: "id")
                completion(id as! Int, posterImageUrl as! String)
            }
        } catch {
            print("DEBUG: Error while fetching the core data, \(error.localizedDescription)")
        }
    }
    
    func deleteCoreData(forMovie movie: Movie, completion: @escaping() -> Void) {
        guard let appDelegate = application.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %i", movie.id)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let movie = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = movie[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            try managedContext.save()
            completion()
        } catch {
            print("DEBUG: Error while deleting the context, \(error.localizedDescription)")
        }
    }
    
    func deleteAllData(completion: @escaping() -> Void) {
        guard let appDelegate = application.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false

        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
                try managedContext.save()
                completion()
            }
        } catch let error as NSError {
            print("Detele all data in favoriteMovies error : \(error) \(error.userInfo)")
        }
    }
}
