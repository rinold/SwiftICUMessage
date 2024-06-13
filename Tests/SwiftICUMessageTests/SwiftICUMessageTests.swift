import XCTest
@testable import SwiftICUMessage

final class swift_icu_messageTests: XCTestCase {

    func test_Plurals_ar_few() throws {
      let format = "Add {count, plural, =1{one more item} few{a few more items} other{# more items} } to unlock"
      let resultString = try format.icuPlural(replacing: ["count": 7], languageCode: "ar")

      XCTAssertEqual("Add a few more items to unlock", resultString)
    }

    func test_Plurals_other_1() throws {
      let format = "Add {count, plural, =1{1 more item} other{# more items} } to unlock"
      let resultString = try format.icuPlural(replacing: ["count": 1])

      XCTAssertEqual("Add 1 more item to unlock", resultString)
    }

    func test_Plurals_other_11() throws {
      let format = "Add {count, plural, =1{1 more item} other{# more items}} to unlock"
      let resultString = try format.icuPlural(replacing: ["count": 11])

      XCTAssertEqual("Add 11 more items to unlock", resultString)
    }

    func test_Plurals1() throws {
      let format = "Add {count, plural, =1{1 more item} other{# more items}} to unlock"
      let resultString = try format.icuPlural(replacing: ["count": 11])

      XCTAssertEqual("Add 11 more items to unlock", resultString)
    }

    func test_whenPluralStringCalled_with0() throws {

        let resultString = try Strings.pluralString.icuPlural(replacing: ["mice": 0])

        XCTAssertEqual("There are no mice", resultString)
    }

    func test_whenPluralStringCalled_with1() throws {

        let resultString = try Strings.pluralString.icuPlural(replacing: ["mice": 1])

        XCTAssertEqual("There is one mouse", resultString)
    }

    func test_whenPluralStringCalled_withOther() throws {

        let resultString = try Strings.pluralString.icuPlural(replacing: ["mice": 100])

        XCTAssertEqual("There are a few mice", resultString)
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
