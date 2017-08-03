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

extension ReactiveExtensions where Base: FeedParser {

  func parce() -> Signal<FeedParserResult, FeedParserError> {
    return Signal { observer in

      self.base.parseAsync(queue: .global(qos: .background)) { result in
        switch(result) {
        case .failure(let error):
          observer.failed(FeedParserError(error: error))
        default:
          observer.completed(with: FeedParserResult(result: result))
        }
      }
      
      return BlockDisposable {
        self.base.abortParsing()
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

  case other

  init(error: NSError) {
    self = .other
  }
}
