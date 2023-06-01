//
//  Service.swift
//  JRAcademyChallenge
//
//  Created by Furkan Özyürek on 1.06.2023.
//

import Foundation
import Alamofire

func makeRequest<T: Decodable>(url: URLConvertible, method: HTTPMethod, completion: @escaping (Result<T, Error>) -> Void) {
    AF.request(url, method: method).responseData { response in
        switch response.result {
        case .failure(let error):
            completion(.failure(error))
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
