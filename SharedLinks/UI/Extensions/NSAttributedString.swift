//
//  NSAttributedString.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 28/07/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation

extension NSAttributedString {

  static var empty: NSAttributedString {
    return NSAttributedString()
  }

  convenience init(attrStrings: [NSAttributedString], separator: String? = nil) {

    guard !attrStrings.isEmpty else { self.init(); return }

    let result = NSMutableAttributedString()
    for component in attrStrings {
      result.append(component)
      if let separator = separator, component != attrStrings.last {
        result.append(NSAttributedString(string: separator))
      }
    }

    self.init(attributedString: result)
  }
}
