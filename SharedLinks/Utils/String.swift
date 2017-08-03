//
//  String.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 02/08/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation

extension String {

  var removingHtmlTags: String {
    
    let withoutTags = self.replacingOccurrences(
      of: "<[^>]*>",
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
    
    return withoutTagsAndDublicatedSpaces
  }
}
