//
//  FeedParser+ReactiveKit.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 03/08/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation
import FeedKit
import ReactiveKit


extension FeedParser: ReactiveExtensionsProvider { }

fileprivate let FeedParserQueue = DispatchQueue.global(qos: .background)

extension ReactiveExtensions where Base: FeedParser {

  static func feed(at url: URL) -> Signal<FeedParserResult, FeedParserError> {

    return Signal { observer in

      var parser: FeedParser?
      let task = URLSession.shared.downloadTask(with: url) { feedURL, _, error in
        guard let feedURL = feedURL else {
          observer.failed(.failedToDowndloadFeed)
          return
        }
        parser = FeedParser(URL: feedURL)
        guard let parser = parser else {
          observer.failed(.failedToReadFeed)
          return
        }
        parser.parseAsync(queue: FeedParserQueue) { result in
          switch(result) {
          case .failure:
            observer.failed(.failedToParseFeed)
          default:
            observer.completed(with: FeedParserResult(result: result))
          }
        }
      }
      task.resume()
      
      return BlockDisposable {
        task.cancel()
        parser?.abortParsing()
      }
    }
  }
}

enum FeedParserResult {

  case atom(AtomFeed)
  case rss(RSSFeed)
  case json(JSONFeed)

  fileprivate init(result: FeedKit.Result) {
    switch result {
    case .atom(let feed): self = .atom(feed)
    case .rss(let feed): self = .rss(feed)
    case .json(let feed): self = .json(feed)
    case .failure: fatalError("This never will happen")
    }
  }
}

enum FeedParserError: Error {

  case failedToDowndloadFeed
  case failedToReadFeed
  case failedToParseFeed
}
