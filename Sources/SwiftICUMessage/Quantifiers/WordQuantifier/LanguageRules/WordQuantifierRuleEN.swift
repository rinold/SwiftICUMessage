//
//  WordQuantifierRuleEN.swift
//  
//
//  Created by Mikhail Churbanov on 6/13/24.
//

import Foundation

struct WordQuantifierRuleEN: WordQuantifierLanguageRule {
    let languageCode = "en"
    func cardinalToken(for count: Int) -> WordQuantifierToken {
        switch count {
        case 0: .zero
        case 1: .one
        default: .other
        }
    }
}
