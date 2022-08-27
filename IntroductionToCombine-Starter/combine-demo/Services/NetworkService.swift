//
//  NetworkService.swift
//  combine-demo
//
//  Created by Caleb Meurer on 8/1/22.
//

import Foundation

protocol Networkable {
    func fetchData<T: Codable>(from urlString: String, for model: T.Type, completion: @escaping (Result<T, NetworkingError>) -> Void)
}

class NetworkService: Networkable {
    func fetchData<T: Codable>(from urlString: String, for model: T.Type, completion: @escaping (Result<T, NetworkingError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.errorFromServer(error.localizedDescription)))
            }
            
            guard let data = data else {
                return
            }
            
            self.decode(data: data, for: model) { result in
                switch result {
                case .success(let decodedData):
                    completion(.success(decodedData))
                case .failure(let error):
                    completion(.failure(.errorDecoding(error.localizedDescription)))
                }
            }
        }
        task.resume()
    }
    
    private func decode<T: Codable>(data: Data, for model: T.Type, completion: (Result<T, Error>) -> Void) {
        let jsonDecoder = JSONDecoder()
        do {
            completion(.success(try jsonDecoder.decode(model, from: data)))
        } catch {
            completion(.failure(error))
        }
    }
}
