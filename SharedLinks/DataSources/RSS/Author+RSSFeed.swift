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

  init?(rssFeed feed: RSSFeed) {
    guard let name = feed.title else { return nil }

    self.name = name
    self.avatar = feed.image?.url.flatMap(URL.init(string:))
  }
}
