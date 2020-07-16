//  MarkupNode.swift
//  Mantrah
//
//  Created by Djuro on 16/07/20.
//  Copyright © 2020 Manthrah. All rights reserved.
//

import Foundation

enum MarkupNode {
	case text(String)
	case strong([MarkupNode])
	case emphasis([MarkupNode])
	case delete([MarkupNode])
}

extension MarkupNode: Equatable {}

extension MarkupNode {
	init?(delimiter: UnicodeScalar, children: [MarkupNode]) {
		switch delimiter {
		case "*":
			self = .strong(children)
		case "_":
			self = .emphasis(children)
		case "~":
			self = .delete(children)
		default:
			return nil
		}
	}
}
