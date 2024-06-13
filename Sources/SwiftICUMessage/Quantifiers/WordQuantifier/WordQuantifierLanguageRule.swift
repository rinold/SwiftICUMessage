//
//  WordQuantifierLanguageRule.swift
//  
//
//  Created by Mikhail Churbanov on 6/13/24.
//

import Foundation

protocol WordQuantifierLanguageRule {
    var languageCode: String { get }
    func cardinalToken(for count: Int) -> WordQuantifierToken
}
