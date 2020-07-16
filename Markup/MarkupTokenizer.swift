//  MarkupTokenizer.swift
//  Mantrah
//
//  Created by Djuro on 16/07/20.
//  Copyright © 2020 Manthrah. All rights reserved.
//

import Foundation

private extension CharacterSet {
	static let delimiters = CharacterSet(charactersIn: "*_~")
	static let whitespaceAndPunctuation = CharacterSet.whitespacesAndNewlines
		.union(CharacterSet.punctuationCharacters)
		.union(CharacterSet(charactersIn: "~"))
}

private extension UnicodeScalar {
	static let space: UnicodeScalar = " "
}

struct MarkupTokenizer {
    
    // MARK: - Properties
	private let input: String.UnicodeScalarView
	private var currentIndex: String.UnicodeScalarView.Index
	private var leftDelimiters = [UnicodeScalar]()
    private var current: UnicodeScalar? {
        guard currentIndex < input.endIndex else { return nil }

        return input[currentIndex]
    }
    private var previous: UnicodeScalar? {
        guard currentIndex > input.startIndex else { return nil }

        let index = input.index(before: currentIndex)
        return input[index]
    }
    private var next: UnicodeScalar? {
        guard currentIndex < input.endIndex else { return nil }

        let index = input.index(after: currentIndex)

        guard index < input.endIndex else { return nil }

        return input[index]
    }

    // MARK: - Initializer
	init(string: String) {
		input = string.unicodeScalars
		currentIndex = string.unicodeScalars.startIndex
	}

    // MARK: - Public API
	mutating func nextToken() -> MarkupToken? {
		guard let c = current else { return nil }

		var token: MarkupToken?

		if CharacterSet.delimiters.contains(c) {
			token = scan(delimiter: c)
		} else {
			token = scanText()
		}

		if token == nil {
			token = .text(String(c))
			advance()
		}

		return token
	}

    // MARK: - Private API
	private mutating func scan(delimiter d: UnicodeScalar) -> MarkupToken? {
		return scanRight(delimiter: d) ?? scanLeft(delimiter: d)
	}

	private mutating func scanLeft(delimiter: UnicodeScalar) -> MarkupToken? {
		let p = previous ?? .space

		guard let n = next else { return nil }

		// Left delimiters must be predeced by whitespace or punctuation
		// and NOT followed by whitespaces or newlines
		guard CharacterSet.whitespaceAndPunctuation.contains(p) &&
			!CharacterSet.whitespacesAndNewlines.contains(n) &&
			!leftDelimiters.contains(delimiter) else {
			return nil
		}

		leftDelimiters.append(delimiter)
		advance()

		return .leftDelimiter(delimiter)
	}

	private mutating func scanRight(delimiter: UnicodeScalar) -> MarkupToken? {
		guard let p = previous else {
			return nil
		}

		let n = next ?? .space

		// Right delimiters must NOT be preceded by whitespace and must be
		// followed by whitespace or punctuation
		guard !CharacterSet.whitespacesAndNewlines.contains(p) &&
			CharacterSet.whitespaceAndPunctuation.contains(n) &&
			leftDelimiters.contains(delimiter) else {
			return nil
		}

		while !leftDelimiters.isEmpty {
			if leftDelimiters.popLast() == delimiter {
				break
			}
		}
		advance()

		return .rightDelimiter(delimiter)
	}

	private mutating func scanText() -> MarkupToken? {
		let startIndex = currentIndex
		scanUntil { CharacterSet.delimiters.contains($0) }

		guard currentIndex > startIndex else { return nil }

		return .text(String(input[startIndex ..< currentIndex]))
	}

	private mutating func scanUntil(_ predicate: (UnicodeScalar) -> Bool) {
		while currentIndex < input.endIndex && !predicate(input[currentIndex]) {
			advance()
		}
	}

	private mutating func advance() {
		currentIndex = input.index(after: currentIndex)
	}
    
}
