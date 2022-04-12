
import Foundation

extension String {
        
    struct Regex {
        static let plural = "(?:\\b%@, plural,|\\G(?!\\A))\\s*(\\S+)\\s*\\{([^}]*)\\}"
        static let select = "(?:\\b%@, select,|\\G(?!\\A))\\s*(\\S+)\\s*\\{([^}]*)\\}"
        static let replacement = "\\{%@\\}"
        
    }
    
    enum SignedQuantifiers: String, CaseIterable {
        case greaterThan = ">"
        case lessThan = "<"
        case equalTo = "="
    }
    
    enum WordQuantifiers: String, CaseIterable {
        case few, other
    }
    
    func replacementFromICU(replacing templates: [String: String]) throws -> String {
        var mutatingSelf = self
        try templates.forEach { template in
            let pattern = String(format: Regex.replacement, template.key)
            let regex = try NSRegularExpression(pattern: pattern)
            let matches = regex.matches(in: mutatingSelf, range: NSRange(mutatingSelf.startIndex ..< mutatingSelf.endIndex, in: mutatingSelf))
            
            if let lowerBound = matches.first?.range.lowerBound,
               let lowerIndex = mutatingSelf.index(mutatingSelf.startIndex, offsetBy: (lowerBound), limitedBy: mutatingSelf.endIndex),
               let upperBound = matches.last?.range.upperBound,
               let upperIndex = mutatingSelf.index(mutatingSelf.startIndex, offsetBy: (upperBound), limitedBy: mutatingSelf.endIndex) {
                mutatingSelf.replaceSubrange(lowerIndex ..< upperIndex, with: template.value)
            }
        }
        return mutatingSelf
    }
    
    func selectFromICU(replacing templates: [String: Any]) throws -> String {
        var mutatingSelf = self
        try templates.forEach { template in
            var phraseToUse: String
            
            let pattern = String(format: Regex.select, template.key)
            let regex = try NSRegularExpression(pattern: pattern)
            
            let matches = regex.matches(in: mutatingSelf, range: NSRange(mutatingSelf.startIndex ..< mutatingSelf.endIndex, in: mutatingSelf))
            let removeCharacters = String(format: "%@, select,", template.key)
            
            var selectValues = [String: String]()
//            print("* matches : \(matches)")
            matches.forEach { match in
                var matchString = String(mutatingSelf[Range(match.range, in: mutatingSelf)!])
                print("* matchString \(matchString)")
                matchString = matchString.replacingOccurrences(of: removeCharacters, with: "")
                print("* matchString \(matchString)")
                
                let matchValues = matchString.components(separatedBy: "{")
                guard var quantifier = matchValues.first, let phrase = matchValues.last?.dropLast() else {
                    return
                }
                
                if quantifier.first == " " {
                    quantifier = String(quantifier.dropFirst())
                }
                
                if quantifier.last == " " {
                    quantifier = String(quantifier.dropLast())
                }
                
                selectValues[quantifier] = String(phrase)
                
                print("* match : \(matchString)")
            }
            
            phraseToUse = selectValues.compactMap { value -> String? in
                guard let templateValue = template.value as? String else { return nil }

                print("* templateValue: \(templateValue)")
                print("* key : \(value.key)")
                
                if templateValue == value.key {
                    return value.value
                }
                
                return nil
            }.first!
//            print("* phrase to use \(phraseToUse)")
                        
            if let lowerBound = matches.first?.range.lowerBound,
               let lowerIndex = mutatingSelf.index(mutatingSelf.startIndex, offsetBy: (lowerBound-1), limitedBy: mutatingSelf.endIndex),
               let upperBound = matches.last?.range.upperBound,
               let upperIndex = mutatingSelf.index(mutatingSelf.startIndex, offsetBy: (upperBound+1), limitedBy: mutatingSelf.endIndex) {                
                mutatingSelf.replaceSubrange(lowerIndex ..< upperIndex, with: phraseToUse)
            }
            
            
        }
//        print("* mutatingSelf \n \(mutatingSelf)")
//        print("* self \n \(self)")
        return mutatingSelf
    }
    
    func pluralFromICU(replacing templates: [String: Any]) throws -> String {
        
        var mutatingSelf = self
        
        try templates.forEach { template in
            var phraseToUse: String
            
            let pattern = String(format: Regex.plural, template.key)
            let regex = try NSRegularExpression(pattern: pattern)
            
            let matches = regex.matches(in: mutatingSelf, range: NSRange(mutatingSelf.startIndex ..< mutatingSelf.endIndex, in: mutatingSelf))
            let removeCharacters = String(format: "%@, plural,", template.key)
            
            var pluralValues = [String: String]()
//            print("* matches : \(matches)")
            matches.forEach { match in
                var matchString = String(mutatingSelf[Range(match.range, in: mutatingSelf)!])
//                print("* matchString \(matchString)")
                matchString = matchString.replacingOccurrences(of: removeCharacters, with: "")
                
                let matchValues = matchString.components(separatedBy: "{")
                guard var quantifier = matchValues.first, let phrase = matchValues.last?.dropLast() else {
                    return
                }
                
                if quantifier.first == " " {
                    quantifier = String(quantifier.dropFirst())
                }
                
                if quantifier.last == " " {
                    quantifier = String(quantifier.dropLast())
                }
                
                pluralValues[quantifier] = String(phrase)
                
//                print("* match : \(matchString)")
            }
            let sortedKeys = pluralValues.keys.sorted()
//            print("* pluralValues : \(pluralValues)")
//            print("* pluralValues keys : \(sortedKeys)")
            
            phraseToUse = sortedKeys.compactMap { key -> String? in
                guard let value = pluralValues[key], let intTemplate = template.value as? Int else { return nil }
                
                if let mathQuantifier = SignedQuantifiers(rawValue: String(key.first ?? Character(""))),
                   let intComparison = Int(String(key.dropFirst())) {
                                        
                    switch mathQuantifier {
                    case .lessThan:
                        if intComparison < intTemplate {
                            return value
                        }
                    case .greaterThan:
                        if intComparison > intTemplate {
                            return value
                        }
                    case .equalTo:
                        if intComparison == intTemplate {
                            return value
                        }
                    }
                    
                } else if let wordQuantifier = WordQuantifiers(rawValue: String(key)) {
                    
                    // Hardcoded comparison based on symantics of what the word means
                    
                    switch wordQuantifier {
                    case .few:
                        if intTemplate > 2 && intTemplate <= 10 {
                            return value
                        }
                    case .other:
                        if intTemplate > 10 {
                            return value
                        }
                    }
                } else {
                    return nil
                }
                
                return nil
            }.first!
//            print("* phrase to use \(phraseToUse)")
            
            if let lowerBound = matches.first?.range.lowerBound,
               let lowerIndex = mutatingSelf.index(mutatingSelf.startIndex, offsetBy: (lowerBound-1), limitedBy: mutatingSelf.endIndex),
               let upperBound = matches.last?.range.upperBound,
               let upperIndex = mutatingSelf.index(mutatingSelf.startIndex, offsetBy: (upperBound+1), limitedBy: mutatingSelf.endIndex) {
                
//                let matchRange = NSRange(lowerBound ..< upperBound)
                mutatingSelf.replaceSubrange(lowerIndex...upperIndex, with: phraseToUse)
            }
            
            
        }
        print("* mutatingSelf \n \(mutatingSelf)")
        print("* self \n \(self)")
        return mutatingSelf
    }
    
}
