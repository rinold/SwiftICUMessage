import XCTest
@testable import swift_icu_message

final class swift_icu_messageTests: XCTestCase {
    func test_whenPluralStringCalled_with0() throws {
        
        let resultString = try Strings.pluralString.pluralFromICU(replacing: ["mice": 0])
        
        XCTAssertEqual("There are no mice", resultString)
    }
    
    func test_whenPluralStringCalled_with1() throws {
        
        let resultString = try Strings.pluralString.pluralFromICU(replacing: ["mice": 1])
        
        XCTAssertEqual("There is one mouse", resultString)
    }
    
    func test_whenPluralStringCalled_withOther() throws {
        
        let resultString = try Strings.pluralString.pluralFromICU(replacing: ["mice": 100])
        
        XCTAssertEqual("There are a few mice", resultString)
    }

//    func test_whenThereAreMultablePluralsTemplates() throws {
//        let resultString = try Strings.twoPluralString.pluralFromICU(
//            replacing: [
//                "mice": 100,
//                "gems": 0])
//
//        XCTAssertEqual("There are a few mice and there's no gems", resultString)
//    }
    
    func test_whenSimpleControlFlow_isGenderMale() throws {
        let resultString = try Strings.simpleControlFlow.selectFromICU(replacing: ["gender": "male"])
        XCTAssertEqual("a gender is Male", resultString)
    }

    func test_whenSimpleControlFlow_isGenderFemale() throws {
        let resultString = try Strings.simpleControlFlow.selectFromICU(replacing: ["gender": "female"])
        XCTAssertEqual("a gender is female", resultString)
    }

    func test_whenSimpleControlFlow_isGenderOther() throws {
        let resultString = try Strings.simpleControlFlow.selectFromICU(replacing: ["gender": "other"])
        XCTAssertEqual("a gender is other", resultString)
    }
    
    func test_whenMultipleControlFlow_1() throws {
        let resultString = try Strings.multipleControlFlow.selectFromICU(
            replacing: ["gender": "other", "beer": "ale"]
        )
        XCTAssertEqual("a gender is other and the best beer is Ale", resultString)
    }
    
    func test_placeholder() throws {
        let resultString = try Strings.placeholderString.replacementFromICU(replacing: ["value": "10"])
        XCTAssertEqual("Credit score decreased by 10", resultString)
    }
}

extension swift_icu_messageTests {
    
    struct Strings {
        static let pluralString =  "There {mice, plural, =0 {are no mice} =1 {is one mouse} other {are a few mice} }"
        static let twoPluralString =  "There {mice, plural, =0 {are no mice} =1 {is one mouse} other {are a few mice}} and there's {gems, plural, =0 {no gems} =1 {one gem}, few {some gems}, other {many many gems}}"
        static let placeholderString = "Credit score decreased by {value}"
        static let dateString = "Sale begins {start, date, medium}"
        static let currencyString = "The price is {num, number, ::sign compact-short currency/GBP}"
        static let simpleControlFlow = "a gender is {gender, select, male {Male} female {female} other {other}}"
        static let multipleControlFlow = "a gender is {gender, select, male {Male} female {female} other {other}} and the best beer is {beer, select, ale {Ale} lager {Lager} other {Or another one}}"
        static let nestedControlFlowString = "{isActive, select, true {Disable} other {{isVerified, select, 0 {Verify your email} other{Enable}}}}"
    }
    
}
