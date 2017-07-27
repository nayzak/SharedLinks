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

  init() {

    let links = Property<[Link]>([])
    twitterDataSource.homeTimeline()
      .recover(with: [])
      .bind(to: links)
    
    self.links = links.toSignal()
  }

}
