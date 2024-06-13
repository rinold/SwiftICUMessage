//
//  ComparisonQuantifier.swift
//
//
//  Created by Mikhail Churbanov on 6/13/24.
//

import Foundation

struct ComparisonQuantifier {

    func match(for template: Int, in keys: [String]) -> String? {
        return keys.first(where: { key in
            let mathSign = String(key.prefix(1))
            guard let quantifierToken = ComparisonQuantifierToken(rawValue: mathSign),
                  let comparisonValue = Int(key.dropFirst()) else {
                return false
            }
            return switch quantifierToken {
            case .lessThan: comparisonValue < template
            case .greaterThan: comparisonValue > template
            case .equalTo: comparisonValue == template
            }
        })
    }
}
