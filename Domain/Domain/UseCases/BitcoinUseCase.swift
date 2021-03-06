//
//  BitcoinUseCase.swift
//  Domain
//
//  Created by Artem Shkirta on 06.09.2021.
//

import Foundation

public protocol BitcoinUseCase {
    func bitcoinExchangeRate(completion: @escaping (Result<Bitcoin, AppError>) -> Void)
    func startUpdateExchangeRateTimer()
    func stopUpdateExchangeRateTimer()
}
