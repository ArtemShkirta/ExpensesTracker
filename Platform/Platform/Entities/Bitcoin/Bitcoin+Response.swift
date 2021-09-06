//
//  Bitcoin+Response.swift
//  Platform
//
//  Created by Artem Shkirta on 06.09.2021.
//

import struct Domain.Bitcoin

extension Bitcoin {
    struct Response {
        let rate: Decimal
        let code: String
    }
}

// MARK: - Decodable
extension Bitcoin.Response: Decodable {
    private enum USDCodingKeys: String, CodingKey {
        case rate = "rate_float"
        case code
    }
    
    private enum BPICodingKeys: String, CodingKey {
        case usd = "USD"
    }
    
    private enum CodingKeys: String, CodingKey {
        case bpi
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let bpiContainer = try container.nestedContainer(keyedBy: BPICodingKeys.self, forKey: .bpi)
        let usdContainer = try bpiContainer.nestedContainer(keyedBy: USDCodingKeys.self, forKey: .usd)
        code = try usdContainer.decode(String.self, forKey: .code)
        rate = try usdContainer.decode(Decimal.self, forKey: .rate)
    }
}

extension Bitcoin {
    init(_ response: Bitcoin.Response) {
        self.init(code: response.code, rate: response.rate)
    }
}
