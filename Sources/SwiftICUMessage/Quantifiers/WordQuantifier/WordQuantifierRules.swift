//
//  WordQuantifierRules.swift
//
//
//  Created by Mikhail Churbanov on 6/13/24.
//

import Foundation

struct WordQuantifierRules {
    static let supportedRules: [WordQuantifierLanguageRule] = [
        WordQuantifierRuleEN(),
        WordQuantifierRuleAR()
    ]

    static func rule(for languageCode: String) -> WordQuantifierLanguageRule? {
        supportedRules.first(where: { $0.languageCode == languageCode })
    }
}
