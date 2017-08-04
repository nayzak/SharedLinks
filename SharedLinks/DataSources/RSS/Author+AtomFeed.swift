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
    guard let name = feed.title else { return nil }

    self.name = name
    self.avatar = (feed.logo ?? feed.icon).flatMap(URL.init(string:))
  }
}
