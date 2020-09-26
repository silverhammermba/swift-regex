import XCTest
@testable import swift_regex

final class swift_regexTests: XCTestCase {
    func testExample() {
        let r: Regexp! = try? Regexp(#"cat"#)
        XCTAssertNotNil(r)
        let m = r ~ "cattle"
        XCTAssertEqual(m.count, 1)
        XCTAssertEqual(m.first!.groups, 0)
        XCTAssertEqual(m.first!.substring, "cat")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
