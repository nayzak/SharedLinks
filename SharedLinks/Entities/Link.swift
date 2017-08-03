//
//  Link.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 27/07/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation

struct Link {

  let url: URL
  let title: String
  let description: String
  let publishDate: Date
  let author: Author
  
}

extension Link: Equatable {

  static func ==(lhs: Link, rhs: Link) -> Bool {
    //TODO: Implement Links equility not based on url
    return lhs.url == lhs.url
  }
}
