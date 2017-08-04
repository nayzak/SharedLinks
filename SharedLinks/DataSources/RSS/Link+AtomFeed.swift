//
//  Link+AtomFeed.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 04/08/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation
import FeedKit

extension Link {

  init?(atomFeedEntry item: AtomFeedEntry, author: Author) {
    guard
      let url = item.links?.first?.attributes?.href.flatMap(URL.init(string:)),
      let text = item.content?.value,
      let publishDate = item.published ?? item.updated
      else { return nil }

    self.url = url
    self.title = item.title ?? ""
    self.description = text.removingHtmlTags
    self.publishDate = publishDate
    self.author = author
  }
}
