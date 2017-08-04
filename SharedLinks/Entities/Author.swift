//
//  Author.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 28/07/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation
import CryptoSwift

struct Author {

  struct ID {

    let feedType: FeedType
    let idInFeed: String
    let value: String

    init?(feedType: FeedType, idInFeed: String) {
      guard !idInFeed.isEmptyOrWhitespace else { return nil }

      self.feedType = feedType
      self.idInFeed = idInFeed
      self.value = (feedType.prefixForIDHashing + idInFeed).sha256()
    }
  }
  
  let id: ID
  let name: String
  let avatar: URL?

  init(id: ID, name: String, avatar: URL?) {
    self.name = name
    self.avatar = avatar
    self.id = id
  }

  init?(feedType: FeedType, idInFeed: String, name: String, avatar: URL?) {
    guard let id = ID(feedType: feedType, idInFeed: idInFeed) else { return nil }

    self.init(id: id, name: name, avatar: avatar)
  }
}

extension Author.ID: Hashable {

  var hashValue: Int {
    return value.hashValue
  }

  static func ==(lhs: Author.ID, rhs: Author.ID) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}

extension Author.ID: CustomStringConvertible {

  var description: String {
    return self.value
  }
}

extension Author: Hashable {

  var hashValue: Int {
    return id.hashValue
  }

  public static func ==(lhs: Author, rhs: Author) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
