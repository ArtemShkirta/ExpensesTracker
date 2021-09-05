//
//  Environment.swift
//  Platform
//
//  Created by Artem Shkirta on 05.09.2021.
//

import Foundation

enum Environment {
    static var bitcoinPriceURL: URL? {
        URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")
    }
}
