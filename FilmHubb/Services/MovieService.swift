//
//  MovieService.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 2.10.2023.
//

import UIKit
import CoreData

private let entityName = "FavoriteMovies"

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

protocol MovieServicing {
    func getMovies(for list: String, completion: @escaping(Result<Movies, Error>) -> Void)
    func getMovie(forId id: Int, completion: @escaping(Result<Movie, Error>) -> Void)
    func fetchCredits(forId id: Int, completion: @escaping(Result<MovieCredits, Error>) -> Void)
    func getVideos(forId id: Int, completion: @escaping(Result<MovieVideos, Error>) -> Void)
    func searchMovie(withName name: String, completion: @escaping(Result<Movies, Error>) -> Void)
    func createCoreData(forMovie movie: Movie, completion: @escaping() -> Void)
    func fetchCoreData(completion: @escaping(Int, String) -> Void)
    func deleteCoreData(forMovie movie: Movie, completion: @escaping() -> Void)
}

class MovieService: MovieServicing {
    
    var networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getMovies(for list: String, completion: @escaping(Result<Movies, Error>) -> Void) {
                
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(TOKEN_AUTH)"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/\(list)?language=en-US&page=1")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        networkManager.performRequest(withRequest: request, responseType: Movies.self, completion: completion)
    }
    
    func getMovie(forId id: Int, completion: @escaping(Result<Movie, Error>) -> Void) {
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(TOKEN_AUTH)"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/\(id)?language=en-US")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        networkManager.performRequest(withRequest: request, responseType: Movie.self, completion: completion)
    }
    
    func fetchCredits(forId id: Int, completion: @escaping(Result<MovieCredits, Error>) -> Void) {
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(TOKEN_AUTH)"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/\(id)/credits?language=en-US")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        networkManager.performRequest(withRequest: request, responseType: MovieCredits.self, completion: completion)
    }
    
    func getVideos(forId id: Int, completion: @escaping(Result<MovieVideos, Error>) -> Void) {
        
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(TOKEN_AUTH)"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/\(id)/videos?language=en-US")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        networkManager.performRequest(withRequest: request, responseType: MovieVideos.self, completion: completion)
    }
    
    func searchMovie(withName name: String, completion: @escaping(Result<Movies, Error>) -> Void) {
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(TOKEN_AUTH)"
        ]
        
        let query = name.replacingOccurrences(of: " ", with: "+")
        
        let urlString = "https://api.themoviedb.org/3/search/movie?query=\(query)&include_adult=false&language=en-US&page=1"
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let request = NSMutableURLRequest(url: NSURL(string: encodedString)!
                                          as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        networkManager.performRequest(withRequest: request, responseType: Movies.self, completion: completion)
    }
    
    //MARK: - CoreData
    
    func createCoreData(forMovie movie: Movie, completion: @escaping() -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
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
    
    func fetchCoreData(completion: @escaping(Int, String) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
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
    
    func deleteCoreData(forMovie movie: Movie, completion: @escaping() -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
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
    
    func deleteAllData(completion: @escaping() -> Void)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
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

//MARK: Extension for fetchCoreData with a given movie id

extension MovieServicing {
    func fetchCoreData(forMovie movie: Movie, completion: @escaping(Int, String) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
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
}

