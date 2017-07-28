//
//  Link+Twitter.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 27/07/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation
import SwifterMac

extension Link {

  init?(tweet json: SwifterMac.JSON) {
    guard
      let urlString = json["entities"]["urls"][0]["url"].string,
      let url = URL(string: urlString),
      let text = json["text"].string,
      let author = Author(tweetUser: json["user"])
    else { return nil}
    
    self.url = url
    self.title = ""
    self.description = text.removingTwitterShortLinks
    self.author = author
  }
}

extension String {

  fileprivate var removingTwitterShortLinks: String {
    return replacingOccurrences(
      of: "https?://t.co/[\\d\\w]+",
      with: "",
      options: .regularExpression,
      range: startIndex ..< endIndex
    ).trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
