//
//  LinksService.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 27/07/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation
import ReactiveKit

class LinksService {

  let links: SafeSignal<[Link]>
  
  private let twitterDataSource = TwitterDataSource()
  private let rssDataSource = RSSDataSource()
  private let linksSubject = Property<[Link]>([])
  private var updateLinksDisposable: Disposable?

  init() {
    self.links = self.linksSubject.toSignal()
    updateLinks()
  }

  func updateLinks() {
    let twiterFeed = twitterDataSource.homeTimeline()
      .suppressError(logging: true)
      .start(with: [])
    let rssFeed = rssDataSource.feed()
      .suppressError(logging: true)
      .start(with: [])
    let feed = combineLatest(twiterFeed, rssFeed, combine: +).map(LinksService.sort)
    updateLinksDisposable?.dispose()
    updateLinksDisposable = feed.bind(to: linksSubject)
  }

  private static func sort(_ links: [Link]) -> [Link] {
    return links.sorted { lhs, rhs in
      return lhs.publishDate > rhs.publishDate
    }
  }
}
