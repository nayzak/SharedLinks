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
    updateLinksDisposable?.dispose()
//    updateLinksDisposable = twitterDataSource.homeTimeline()
//      .suppressError(logging: true)
//      .bind(to: linksSubject)
    updateLinksDisposable = rssDataSource.feed()
      .suppressError(logging: true)
      .bind(to: linksSubject)
  }
}
