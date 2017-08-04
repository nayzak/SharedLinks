//
//  Author+AtomFeed.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 04/08/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation
import FeedKit

extension Author {

  init?(atomFeed feed: AtomFeed) {

    guard let links = feed.links?.flatMap({ $0.attributes }),
          let feedURL = links.first(where: { $0.rel != nil && $0.rel! == "self" })?.href,
          let name = feed.title
      else { return nil }

    let avatar = (feed.logo ?? feed.icon).flatMap(URL.init(string:))

    self.init(feedType: .atom, idInFeed: feedURL, name: name, avatar: avatar)
  }
}
