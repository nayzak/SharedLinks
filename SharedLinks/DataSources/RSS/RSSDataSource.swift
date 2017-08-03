//
//  RSSDataSource.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 02/08/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation
import ReactiveKit
import FeedKit

enum RSSDataSourceError: Error {

  case failedToCreateFeedParcer
  case other

  init(error: NSError) {
    self = .other
  }

  init(feedParcerError error: FeedParserError) {
    self = .other
  }
}

class RSSDataSource {

  func feed() -> Signal<[Link], RSSDataSourceError> {
    let url = URL(string: "https://geek-tv.ru/gtv.rss")!
    guard let parcer = FeedParser(URL: url) else {
      return .failed(.failedToCreateFeedParcer)
    }

    return parcer.reactive.parce()
      .mapError(RSSDataSourceError.init)
      .map(RSSDataSource.decode)
  }

  private static func decode(parceResult result: FeedParserResult) -> [Link] {
    switch (result) {
    case .atom: return []
    case .rss(let feed): return RSSDataSource.decode(rssFeed: feed)
    case .json: return []
    }
  }

  private static func decode(rssFeed feed: RSSFeed) -> [Link] {
    guard
      let author = Author(rssFeed: feed),
      let items = feed.items
    else { return [] }

    let decode: (RSSFeedItem) -> Link? = { Link(rssFeedItem: $0, author: author) }

    return items.flatMap(decode)
  }
  
}
