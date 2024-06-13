//
//  WordQuantifierRuleAR.swift
//
//
//  Created by Mikhail Churbanov on 6/13/24.
//

import Foundation

struct WordQuantifierRuleAR: WordQuantifierLanguageRule {
    let languageCode = "ar"
    func cardinalToken(for count: Int) -> WordQuantifierToken {
        let remainder = count % 100
        return switch count {
        case 0: .zero
        case 1: .one
        case 2: .two
        case count where remainder >= 3 && remainder <= 10: .few
        case count where remainder >= 11 && remainder <= 99: .many
        default: .other
        }
    }
}
