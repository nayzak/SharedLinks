//
//  String.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 02/08/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation

extension String {

  var trimmed: String {
    return trimmingCharacters(in: .whitespacesAndNewlines)
  }

  var isEmptyOrWhitespace: Bool {
    return trimmed.isEmpty
  }
  
  var removingHtmlTags: String {
    
    let withoutTags = self.replacingOccurrences(
      of: "(<script[^>]*.+</script>)|(<[^>]*>)",
      with: "",
      options: .regularExpression,
      range: self.startIndex ..< self.endIndex
    )
    
    let withoutTagsAndDublicatedSpaces = withoutTags.replacingOccurrences(
      of: "[ ]{2,}",
      with: " ",
      options: .regularExpression,
      range: withoutTags.startIndex ..< withoutTags.endIndex
    )
    
    return withoutTagsAndDublicatedSpaces.trimmed
  }
}
