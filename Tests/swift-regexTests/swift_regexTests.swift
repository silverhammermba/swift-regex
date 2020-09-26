import XCTest
@testable import swift_regex

final class swift_regexTests: XCTestCase {
    func testSimple() {
        let r: Regexp! = try? Regexp(#"cat"#)
        XCTAssertNotNil(r)
        let m = r ~ "cattle"
        XCTAssertEqual(m.count, 1)
        XCTAssertEqual(m.first!.groups, 0)
        XCTAssertEqual(m.first!.substring, "cat")
    }

    func testGroups() {
        let r = try! Regexp(#"(a|(b+)(c*))"#)

        let m = (r ~ "apple").first!
        XCTAssertEqual(m.substring, "a")
        XCTAssertEqual(m.map { $0 }, ["a", nil, nil])

        let m2 = r ~ "cabby"
        XCTAssertEqual(m2.count, 2)
        XCTAssertEqual(m2[1].map { $0 }, ["bb", "bb", ""])
    }

    func testSwitch() {
        let s = "hey there, buddy!"

        // match against multiple patterns
        switch s {
            case try! Regexp("foo"):
                XCTFail()
            case try! Regexp("here,"):
                break
            case try! Regexp("buddy"):
                XCTFail()
            default:
                XCTFail()
        }

        // or make one pattern
        let reg = try! Regexp(#"((\w+(!|\?))|(\d{3}))"#)

        // and check how it matched
        switch (reg ~? s)?.t2() {
            case (_, "buddy!")?:
                break
            default:
                XCTFail()
        }

        switch (reg ~? "number 1234 cool?")?.t3(1) {
            case (_?, _, nil)?:
                XCTFail()
            case (nil, _, let digits?)?:
                XCTAssertEqual(digits, "123")
            default:
                XCTFail()
        }
    }

    enum ParserError: Error {
        case fuck
    }

    func testTime() {
        func comp2t(_ neg: Bool, _ h: Int, _ m: Int, _ s: Int) -> TimeInterval {
            let int = TimeInterval(h * 3600 + m * 60 + s)
            return neg ? -int : int
        }

        func parse(_ s: String) throws -> TimeInterval {
            // parse some time offset like -04:03:02 with 0-3 components
            let reg = try! Regexp(#"^(|(-)?(\d+)(:(\d+))?(:(\d+))?)$"#)

            switch (reg ~? s)?.t7() {
                case (_, nil, nil, nil, nil, nil, nil)?:
                    return 0
                case (_, let s, let c1?, _, let c2?, _, let c3?)?:
                    return comp2t(s != nil, Int(c1)!, Int(c2)!, Int(c3)!)
                case (_, let s, let c1?, _, let c2?, _, _)?:
                    return comp2t(s != nil, 0, Int(c1)!, Int(c2)!)
                case (_, let s, let c1?, _, _, _, _)?:
                    return comp2t(s != nil, 0, 0, Int(c1)!)
                default:
                    throw ParserError.fuck
            }
        }

        XCTAssertEqual(try? parse(""), 0)
        XCTAssertEqual(try? parse("210"), 210)
        XCTAssertEqual(try? parse("3:2"), 3*60+2)
        XCTAssertEqual(try? parse("-01:02"), -(60+2))
        XCTAssertEqual(try? parse("-1:02:03"), -(3600+2*60+3))
        XCTAssertEqual(try? parse("04:02:03"), 4*3600+2*60+3)

        XCTAssertThrowsError(try parse("cat"))
        XCTAssertThrowsError(try parse("1:"))
        XCTAssertThrowsError(try parse("1:-2"))
        XCTAssertThrowsError(try parse("1:2:a"))
        XCTAssertThrowsError(try parse("1:2:3:a"))
        XCTAssertThrowsError(try parse("1:2:5:6"))
    }

    static var allTests = [
        ("testSimple", testSimple),
        ("testGroups", testGroups),
        ("testSwitch", testSwitch),
    ]
}
