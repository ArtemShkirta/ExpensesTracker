//
//  Optional+Helpers.swift
//  Platform
//
//  Created by Artem Shkirta on 05.09.2021.
//

extension Optional {
    func orThrow(_ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            throw errorExpression()
        }
        return value
    }
}
