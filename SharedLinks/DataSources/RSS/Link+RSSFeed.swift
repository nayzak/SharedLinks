//
//  Link+RSSFeed.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 02/08/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation
import FeedKit

extension Link {

  init?(rssFeedItem item: RSSFeedItem, author: Author) {
    guard
      let url = item.link.flatMap(URL.init(string:)),
      let text = item.description,
      let publishDate = item.pubDate
    else { return nil }
    
    self.url = url
    self.title = item.title ?? ""
    self.description = text.removingHtmlTags
    self.publishDate = publishDate
    self.author = author
  }
}
