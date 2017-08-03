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

    func feed(_ url: URL) -> Signal<[Link], RSSDataSourceError> {
      return FeedParser.reactive.feed(at: url)
        .mapError(RSSDataSourceError.init)
        .map(RSSDataSource.decode)
    }

    func combine(_ signals: [Signal<[Link], RSSDataSourceError>]) -> Signal<[Link], RSSDataSourceError> {
      return combineLatest(signals) { $0.reduce([], +) }
    }
    
    return combine(safariWebFeedSources.map(feed))
  }

  private struct SafariWebFeedSource {
    let url: URL

    init?(_ dict: [String:Any?]) {
      guard let url = (dict["FeedURL"] as? String).flatMap(URL.init(string:)),
            let state = (dict["State"] as? NSNumber)?.intValue,
            state == 0
        else { return nil }
      self.url = url
    }
  }
  
  private var safariWebFeedSources: [URL] {
    let webFeedSourcesPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
      .first?
      .appending("/Safari/WebFeedSources.plist")
      .addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
    guard
      let path = webFeedSourcesPath,
      let rawFeedSources = NSArray(contentsOfFile: path) as? [[String:Any?]]
    else { return [] }

    return rawFeedSources
      .flatMap(SafariWebFeedSource.init)
      .map { $0.url }
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

// /Users/nayzak/Library/Safari/WebFeedSources.plist
