//
//  TwitterDataSource.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 27/07/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation
import Accounts
import ReactiveKit
import SwifterMac

//TODO: Implement TwitterDataSourceError
enum TwitterDataSourceError: Error {

  case swifter(SwifterError)
  case other
  case noAccountsAccess

  init(error: Error) {
    self = .other
  }
}

class TwitterDataSource {

  private let config: AppConfig? = {
    guard let path = Bundle.main.path(forResource: "DebugConfig", ofType: "json"),
          let data = try? Data(contentsOf: URL(fileURLWithPath: path))
      else { return nil }
    return try? JSONDecoder().decode(AppConfig.self, from: data)
  }()

  private lazy var client = Swifter(
    consumerKey: self.config?.twitterClient?.key ?? "",
    consumerSecret: self.config?.twitterClient?.secret ?? "",
    appOnly: true
  )

  func homeTimeline() -> Future<[Link], TwitterDataSourceError> {

    func decodeLink(_ json: JSON) -> [Link] {
      return json.array?.flatMap(Link.init(tweet:)) ?? []
    }

    func decodeFollowingIDs(_ json: JSON) -> Set<String> {
      let ids = json.array?.flatMap { $0.string } ?? []
      return Set(ids)
    }

    func followingIdsForUser(withId userId: String) -> Future<Set<String>, TwitterDataSourceError> {
      return self.client.reactive
        .getUserFollowingIDs(for: .screenName(userId), stringifyIDs: true)
        .map { $0.json }
        .map(decodeFollowingIDs)
        .mapError { TwitterDataSourceError.swifter($0) }
    }

    func followingIdsForUsers(withIds usersIds: Set<String>) -> Future<Set<String>, TwitterDataSourceError> {
      return combineLatest(usersIds.map(followingIdsForUser)) {
        $0.reduce(Set<String>(), { $0.union($1) })
      }
    }

    func timelineForUser(withId userId: String) -> Future<[Link], TwitterDataSourceError> {
      return self.client.reactive.getTimeline(for: userId, count: 50)
        .map(decodeLink)
        .mapError { TwitterDataSourceError.swifter($0) }
    }

    func combine(_ signals: [Future<[Link], TwitterDataSourceError>]) -> Future<[Link], TwitterDataSourceError> {
      return combineLatest(signals) { $0.reduce([], +) }
    }

    func timeline() -> Future<[Link], TwitterDataSourceError> {
      let ids = self.config?.twitterUsersToAgregateFollowingsTimeline ?? []
      return followingIdsForUsers(withIds: ids)
        .flatMap(timelineForUser)
        .flatMapLatest(combine)
    }

    if self.client.client.credential != nil {
      return timeline()
    } else {
      return self.client.reactive.authorizeAppOnly()
        .mapError { TwitterDataSourceError.swifter($0) }
        .eraseType()
        .flatMapLatest(timeline)
    }
  }
}
