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


class MovieService {
    static let shared = MovieService()
    
    func getMovies(for list: String, completion: @escaping(Result<[Movie], Error>) -> Void) {
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(TOKEN_AUTH)"
        ]
        let urlString = "https://api.themoviedb.org/3/movie/\(list)?language=en-US&page=1"
        guard let nsUrl = NSURL(string: urlString ) else { return }
        let request = NSMutableURLRequest(url: nsUrl as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(MoviesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        })
        
        dataTask.resume()
    }
    
    func fetchMovie(forId id: Int, completion: @escaping(Result<Movie, Error>) -> Void) {
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(TOKEN_AUTH)"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/\(id)?language=en-US")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(Movie.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        })
        dataTask.resume()
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
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(MovieCredits.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        })
        dataTask.resume()
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
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(MovieVideos.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        })
        dataTask.resume()
    }
    
    func searchMovie(withName name: String, completion: @escaping(Result<[Movie], Error>) -> Void) {
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(TOKEN_AUTH)"
        ]
        
        let query = name.replacingOccurrences(of: " ", with: "+")
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/search/movie?query=\(query)&include_adult=false&language=en-US&page=1")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(MoviesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        })
        dataTask.resume()
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
//            print("DEBUG: \(posterImageUrl) and \(id) are saved in favoriteMovies entity in CoreData.")
            completion()
        } catch {
            print("DEBUG: Error while saving favorite movie to core data, \(error.localizedDescription)")
        }
    }
    
    func fetchCoreData(forMovie movie: Movie? = nil, completion: @escaping(Int, String) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let id = movie?.id {
            fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        }
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
//                print("DEBUG: Retrieved core data: \(data.value(forKey: "id")) and \(data.value(forKey: "posterImageUrl"))")
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
//            print("DEBUG: \(objectToDelete) is deleted.")
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
//                print("DEBUG: \(managedContext) is deleted.")
                completion()
            }
        } catch let error as NSError {
            print("Detele all data in favoriteMovies error : \(error) \(error.userInfo)")
        }
    }
}
