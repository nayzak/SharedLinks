//
//  Author+RSSFeed.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 02/08/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation
import FeedKit

extension Author {

  init?(rssFeed feed: RSSFeed, feedURL: URL) {
    guard let name = feed.title else { return nil }
    
    let avatar = feed.image?.url.flatMap(URL.init(string:))
    self.init(feedType: .rss, idInFeed: feedURL.absoluteString, name: name, avatar: avatar)
  }
}
