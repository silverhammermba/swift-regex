import Foundation

infix operator ~: AdditionPrecedence

public struct Regexp {
    public struct Match {
        private let string: String
        private let result: NSTextCheckingResult

        public var groups: Int { return result.numberOfRanges - 1 }
        public var substring: Substring { return string[Range(result.range, in: string)!] }

        init(_ result: NSTextCheckingResult, in string: String) {
            self.string = string
            self.result = result
        }

        public subscript(_ index: Int) -> Substring {
            return string[Range(result.range(at: index + 1), in: string)!]
        }
    }

    private let regexp: NSRegularExpression

    public init(_ pattern: String, options: NSRegularExpression.Options = []) throws {
        regexp = try NSRegularExpression(pattern: pattern, options: options)
    }

    public static func ~ (left: Regexp, right: String) -> [Match] {
        return left.regexp.matches(in: right, range: NSRange(right.startIndex..., in: right)).map { Match($0, in: right) }
    }
}

