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
      let publishDate = json["created_at"].string.flatMap(Date.init(twitterDateString:)),
      let author = Author(tweetUser: json["user"])
    else { return nil}
    
    self.url = url
    self.title = ""
    self.description = text.removingTwitterShortLinks
    self.publishDate = publishDate
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



extension Date {

  private static let twitterDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy" //Thu Aug 03 10:31:20 +0000 2017
    return formatter
  }()

  fileprivate init?(twitterDateString: String) {
    guard let date = Date.twitterDateFormatter.date(from: twitterDateString) else { return nil }
    self.init(timeIntervalSince1970: date.timeIntervalSince1970)
  }
}
