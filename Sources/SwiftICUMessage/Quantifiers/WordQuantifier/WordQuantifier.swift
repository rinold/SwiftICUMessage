//
//  WordQuantifier.swift
//
//
//  Created by Mikhail Churbanov on 6/13/24.
//

import Foundation

struct WordQuantifier {

    private let languageCode: String
    private let languageRule: WordQuantifierLanguageRule

    init?(
        languageCode: String?
    ) {
        guard let languageCode,
              let languageRule = WordQuantifierRules.rule(for: languageCode)
        else {
            return nil
        }
        self.languageCode = languageCode
        self.languageRule = languageRule
    }

    func cardinalToken(for template: Int) -> WordQuantifierToken? {
        return languageRule.cardinalToken(for: template)
    }
}
