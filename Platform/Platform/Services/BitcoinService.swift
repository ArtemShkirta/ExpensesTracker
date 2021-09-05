//
//  BitcoinService.swift
//  Platform
//
//  Created by Artem Shkirta on 05.09.2021.
//

import Foundation

final class BitcoinService {
    
    func bitcoinExchangeRate(completion: @escaping (Result<Decimal, NetworkError>) -> Void) {
        guard let url = Environment.bitcoinPriceURL else {
            return completion(.failure(.incorretURL))
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return completion(.failure(.incorrectJSON))
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data)
            } catch {
                completion(.failure(.parseError))
            }
        }
    }
}
