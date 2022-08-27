//
//  NetworkService.swift
//  combine-demo
//
//  Created by Caleb Meurer on 8/1/22.
//

import Foundation
import Combine

protocol Networkable {
    func fetchData<T: Codable>(from urlString: String, for model: T.Type) -> AnyPublisher<T, NetworkingError>?
}

class NetworkService: Networkable {
    
    func fetchData<T: Codable>(from urlString: String, for model: T.Type) -> AnyPublisher<T, NetworkingError>? {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkingError.invalidURL)
                .eraseToAnyPublisher()
        }
        let session = URLSession(configuration: .default)
        let publsherTask = session.dataTaskPublisher(for: url)
        let publishedData = publsherTask.map { $0.data }
        let publishedDecoder = publishedData.decode(type: T.self, decoder: JSONDecoder())
            .catch { error in
            Fail(error: NetworkingError.errorDecoding(error.localizedDescription))
        }
        return AnyPublisher(publishedDecoder)
    }
}
