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
    guard let links = item.links?.flatMap({ $0.attributes }), !links.isEmpty else { return nil }
    
    var href: String?
    if links.count == 1 {
      href = links.first?.href
    } else {
      href = links.first { $0.rel != nil && $0.rel! == "alternate" }?.href
    }
    
    guard
      let url = href.flatMap(URL.init(string:)),
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
