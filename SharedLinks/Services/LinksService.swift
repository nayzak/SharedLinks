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
  private let backgroundQueue = DispatchQueue.global(qos: .background)

  init() {
    self.links = self.linksSubject.toSignal()
    updateLinks()
  }

  func updateLinks() {
    if let notUpdating = updateLinksDisposable?.isDisposed, notUpdating == false { return }

    backgroundQueue.async { [unowned self] in
      let twiterFeed = self.twitterDataSource
        .homeTimeline()
        .suppressError(logging: true)
        .start(with: [])
      let rssFeed = self.rssDataSource
        .feed()
        .suppressError(logging: true)
        .start(with: [])
      let feed = combineLatest(twiterFeed, rssFeed, combine: +).map(LinksService.sort)
      self.updateLinksDisposable?.dispose()
      self.updateLinksDisposable = feed.bind(to: self.linksSubject)
    }
  }

  private static func sort(_ links: [Link]) -> [Link] {
    return links.sorted { lhs, rhs in
      return lhs.publishDate > rhs.publishDate
    }
  }
}
