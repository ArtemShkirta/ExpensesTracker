//
//  BitcoinService.swift
//  Platform
//
//  Created by Artem Shkirta on 05.09.2021.
//

import Foundation
import Domain
import class UIKit.UIApplication

final class BitcoinService: BitcoinUseCase {
    
    private enum C {
        static var updateExchangeRateInterval: TimeInterval = 3600
    }
    
    // MARK: - Properties
    private weak var timer: Timer?
    private let notifier: DataChangeNotifier
    
    // MARK: - Life Cycle
    init(notifier: DataChangeNotifier) {
        self.notifier = notifier
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    func bitcoinExchangeRate(completion: @escaping (Result<Decimal, AppError>) -> Void) {
        guard let url = Environment.bitcoinPriceURL else {
            return completion(.failure(.network(.incorretURL)))
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return completion(.failure(.network(.incorrectJSON)))
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                print("dasdasda \(json)")
            } catch {
                completion(.failure(.network(.parseError)))
            }
        }.resume()
    }
    
    // MARK: - Helper Methods
    private func startTimer() {
        timer = .scheduledTimer(withTimeInterval: C.updateExchangeRateInterval, repeats: true) { [weak self] timer in
            self?.notifier.notify(about: .shouldUpdateRate)
        }
    }
    
    @objc private func didEnterBackground() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func willEnterForeground() {
        startTimer()
    }
}
