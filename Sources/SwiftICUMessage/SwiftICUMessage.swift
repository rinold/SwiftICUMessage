//
//  WordQuantifier.swift
//
//
//  Created by Mikhail Churbanov on 6/13/24.
//

import Foundation

extension String {

    public func icuPlural(
        replacing templates: [String: Any],
        languageCode: String? = Locale.current.languageCode
    ) throws -> String {
        try pluralFromICU(replacing: templates, languageCode: languageCode)
    }
}

extension String {

    fileprivate struct Regex {
        static let plural = "\\{?\\s*(?:\\b%@, plural,|\\G(?!\\A))\\s*(\\S+)\\s*\\{([^}]*)\\}\\s*\\}?"
    }

    fileprivate func pluralFromICU(
        replacing templates: [String: Any],
        languageCode: String?
    ) throws -> String {

        let wordQuantifier = WordQuantifier(languageCode: languageCode)
        let comparisonQuantifier = ComparisonQuantifier()
        var mutatingSelf = self

        try templates.forEach { template in
            var phraseToUse: String?

            let pattern = String(format: Regex.plural, template.key)
            let regex = try NSRegularExpression(pattern: pattern)

            let matches = regex.matches(in: mutatingSelf, range: NSRange(mutatingSelf.startIndex ..< mutatingSelf.endIndex, in: mutatingSelf))
            let removeCharacters = String(format: "%@, plural,", template.key)

            var pluralValues = [String: String]()
//            print("* matches : \(matches)")
            matches.forEach { match in
                var matchString = String(mutatingSelf[Range(match.range, in: mutatingSelf)!])
                matchString = matchString
                    .replacingOccurrences(of: removeCharacters, with: "")
                    .trimmingCharacters(in: .whitespaces.union(.init(charactersIn: "{}")))
                
//                print("* matchString \(matchString)")

                let matchValues = matchString.components(separatedBy: "{")
                guard let quantifier = matchValues.first?.trimmingCharacters(in: .whitespaces),
                      let phrase = matchValues.last
                else {
                    return
                }

                pluralValues[quantifier] = String(phrase)

//                print("* match : \(matchString)")
            }
            let sortedKeys = pluralValues.keys.sorted()
//            print("* pluralValues : \(pluralValues)")
//            print("* pluralValues keys : \(sortedKeys)")

            guard let intTemplate = template.value as? Int else {
                return
            }

            if let comparisonKeyMatch = comparisonQuantifier.match(for: intTemplate, in: sortedKeys),
               let quantifiedValue = pluralValues[comparisonKeyMatch] {
                phraseToUse = quantifiedValue
            } else if let cardinalToken = wordQuantifier?.cardinalToken(for: intTemplate),
               let quantifiedValue = pluralValues[cardinalToken.rawValue] ??
                pluralValues[WordQuantifierToken.other.rawValue] {
                phraseToUse = quantifiedValue
            }

            guard let phraseToUse = phraseToUse?.replacingOccurrences(of: "#", with: String(intTemplate)) else {
                return
            }

//            print("* phrase to use \(phraseToUse)")

            if let lowerBound = matches.first?.range.lowerBound,
               let lowerIndex = mutatingSelf.index(mutatingSelf.startIndex, offsetBy: lowerBound, limitedBy: mutatingSelf.endIndex),
               let upperBound = matches.last?.range.upperBound,
               let upperIndex = mutatingSelf.index(mutatingSelf.startIndex, offsetBy: upperBound, limitedBy: mutatingSelf.endIndex) {

                mutatingSelf.replaceSubrange(lowerIndex..<upperIndex, with: phraseToUse)
            }
        }
//        print("* mutatingSelf \n \(mutatingSelf)")
//        print("* self \n \(self)")
        return mutatingSelf
    }
}
