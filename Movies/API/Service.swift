//
//  Service.swift
//  Movies
//
//  Created by Giorgi on 3/6/21.
//

import Foundation

class Service {
    static let shared = Service()
    var isPaginating: Bool = false
    
    private init () {}
    
    func fetchData<T: Codable>(forUrl url: String,
                               decodingType: T.Type,
                               pagination: Bool = false,
                               completion: @escaping(Result<T,Error>) -> Void) {
        
        if pagination {
            isPaginating = true
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 1.5 : 0.5)) {
        
        guard let url = URL(string: url) else {return}
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(error!))
                return
            }

        guard let data = data else {return}
            
            let decoder = JSONDecoder()
            do {
                let movieItem: T = try decoder.decode(decodingType, from: data)
                completion(.success(movieItem))
                if pagination { self.isPaginating = false }
            } catch let error {
                completion(.failure(error))
            }
        }    
        task.resume()
        }
    }
    
    
    func fetchData(posterPath: String, completion: @escaping (Result <Data,Error>) -> ()) {
   
       guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") else {return}
       

       let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
           if error != nil {
               completion(.failure(error!))
               return
           }
           guard let data = data else {
                   completion(.failure(error!))
                   return
               }
           completion(.success(data))
       }
       dataTask.resume()
   }
}
