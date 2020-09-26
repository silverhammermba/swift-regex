import Foundation

infix operator ~: ComparisonPrecedence
infix operator ~?: ComparisonPrecedence

public struct Regexp {
    public struct Match: Sequence, IteratorProtocol {
        private let string: String
        private let result: NSTextCheckingResult
        private var index = 0

        public var groups: Int { return result.numberOfRanges - 1 }
        public var substring: Substring { return string[Range(result.range, in: string)!] }

        init(_ result: NSTextCheckingResult, in string: String) {
            self.string = string
            self.result = result
        }

        public subscript(_ index: Int) -> Substring?! {
            guard index >= 0 && index < groups else { return nil }
            let range = result.range(at: index + 1)
            guard range.location != NSNotFound else { return .some(nil) }
            return string[Range(range, in: string)!]
        }

        public mutating func next() -> Substring?? {
            guard index < groups else { return nil }
            let sub = self[index]
            index += 1
            return sub
        }
    }

    private let regexp: NSRegularExpression

    public init(_ pattern: String, options: NSRegularExpression.Options = []) throws {
        regexp = try NSRegularExpression(pattern: pattern, options: options)
    }

    public static func ~= (lhs: Regexp, rhs: String) -> Bool {
        return lhs.regexp.firstMatch(in: rhs, range: NSRange(rhs.startIndex..., in: rhs)) != nil
    }

    public static func ~ (lhs: Regexp, rhs: String) -> [Match] {
        return lhs.regexp.matches(in: rhs, range: NSRange(rhs.startIndex..., in: rhs)).map { Match($0, in: rhs) }
    }

    public static func ~? (lhs: Regexp, rhs: String) -> Match? {
        return lhs.regexp.firstMatch(in: rhs, range: NSRange(rhs.startIndex..., in: rhs)).map { Match($0, in: rhs) }
    }
}

extension Regexp.Match {
    public func t1(_ start: Int = 0) -> Substring? {
        return groups > start + 0 ? self[start + 0] : nil
    }

    public func t2(_ start: Int = 0) -> (Substring?, Substring?) {
        let t = t1(start)
        return (t, groups > start + 1 ? self[start + 1] : nil)
    }

    public func t3(_ start: Int = 0) -> (Substring?, Substring?, Substring?) {
        let t = t2(start)
        return (t.0, t.1, groups > start + 2 ? self[start + 2] : nil)
    }

    public func t4(_ start: Int = 0) -> (Substring?, Substring?, Substring?, Substring?) {
        let t = t3(start)
        return (t.0, t.1, t.2, groups > start + 3 ? self[start + 3] : nil)
    }

    public func t5(_ start: Int = 0) -> (Substring?, Substring?, Substring?, Substring?, Substring?) {
        let t = t4(start)
        return (t.0, t.1, t.2, t.3, groups > start + 4 ? self[start + 4] : nil)
    }

    public func t6(_ start: Int = 0) -> (Substring?, Substring?, Substring?, Substring?, Substring?, Substring?) {
        let t = t5(start)
        return (t.0, t.1, t.2, t.3, t.4, groups > start + 5 ? self[start + 5] : nil)
    }

    public func t7(_ start: Int = 0) -> (Substring?, Substring?, Substring?, Substring?, Substring?, Substring?, Substring?) {
        let t = t6(start)
        return (t.0, t.1, t.2, t.3, t.4, t.5, groups > start + 6 ? self[start + 6] : nil)
    }

    public func t8(_ start: Int = 0) -> (Substring?, Substring?, Substring?, Substring?, Substring?, Substring?, Substring?, Substring?) {
        let t = t7(start)
        return (t.0, t.1, t.2, t.3, t.4, t.5, t.6, groups > start + 7 ? self[start + 7] : nil)
    }
}
