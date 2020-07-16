//  MarkupToken.swift
//  Mantrah
//
//  Created by Djuro on 16/07/20.
//  Copyright © 2020 Manthrah. All rights reserved.
//

import Foundation

enum MarkupToken {
	case text(String)
	case leftDelimiter(UnicodeScalar)
	case rightDelimiter(UnicodeScalar)
}

extension MarkupToken: Equatable {}

extension MarkupToken: CustomStringConvertible {
	var description: String {
		switch self {
		case .text(let value):
			return value
		case .leftDelimiter(let value):
			return String(value)
		case .rightDelimiter(let value):
			return String(value)
		}
	}
}

extension MarkupToken: CustomDebugStringConvertible {
	var debugDescription: String {
		switch self {
		case .text(let value):
			return "text(\(value))"
		case .leftDelimiter(let value):
			return "leftDelimiter(\(value))"
		case .rightDelimiter(let value):
			return "rightDelimiter(\(value))"
		}
	}
}
