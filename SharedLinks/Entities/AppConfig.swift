//
//  Config.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 24/02/2018.
//  Copyright © 2018 Ian Kazlauskas. All rights reserved.
//

import Foundation

struct AppConfig: Codable {

  typealias TwitterUserScreenName = String

  struct TwitterClient: Codable {
    let key: String
    let secret: String
  }

  let twitterClient: TwitterClient?
  let twitterUsersToAgregateFollowingsTimeline: Set<TwitterUserScreenName>
  let twitterUsersToAgregateTimeline: Set<TwitterUserScreenName>

  let webFeedSourcesUrls: Set<URL>
}
