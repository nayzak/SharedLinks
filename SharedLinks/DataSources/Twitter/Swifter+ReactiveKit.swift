//
//  Swifter+ReactiveKit.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 27/07/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation
import SwifterMac
import ReactiveKit

extension Swifter: ReactiveExtensionsProvider { }

extension ReactiveExtensions where Base: Swifter {

  func authorizeAppOnly() -> Future<Credential.OAuthAccessToken, SwifterError> {
    return Signal { observer in
      self.base.authorizeAppOnly(
        success: { (token: Credential.OAuthAccessToken?, response: URLResponse) in

          guard !observer.disposable.isDisposed else { return }

          if let token = token {
            observer.completed(with: token)
          } else {
            observer.failed(SwifterError(kind: .badOAuthResponse))
          }

        },
        failure: Self.makeErrorHandler(observer: observer)
      )

      return SimpleDisposable()
    }
  }

  func getTimeline(
    for userId: String,
    count: Int? = nil,
    sinceID: String? = nil,
    maxID: String? = nil,
    trimUser: Bool? = nil,
    contributorDetails: Bool? = nil,
    includeEntities: Bool? = nil
  ) -> Future<JSON, SwifterError>
  {
    return Signal { observer in
      self.base.getTimeline(
        for: userId,
        count: count,
        sinceID: sinceID,
        maxID: maxID,
        trimUser: trimUser,
        contributorDetails: contributorDetails,
        includeEntities: includeEntities,
        success: { (json: JSON) in

          guard !observer.disposable.isDisposed else { return }
          observer.completed(with: json)

        },
        failure: Self.makeErrorHandler(observer: observer)
      )

      return SimpleDisposable()
    }
  }

  func getUserFollowingIDs(
    for userTag: UserTag,
    cursor: String? = nil,
    stringifyIDs: Bool? = nil,
    count: Int? = nil
  ) -> Future<(json: JSON, String?, String?), SwifterError> {
    return Signal { observer in
      self.base.getUserFollowingIDs(
        for: userTag,
        cursor: cursor,
        stringifyIDs: stringifyIDs,
        count: count,
        success: { (json: JSON, b: String?, c: String?) in

          guard !observer.disposable.isDisposed else { return }
          observer.completed(with: (json: json, b, c))

        },
        failure: Self.makeErrorHandler(observer: observer)
      )

      return SimpleDisposable()
    }
  }

  fileprivate static func makeErrorHandler<T>(observer: AtomicObserver<T, SwifterError>) -> (Error) -> Void {
    return { (error: Error) in
      guard !observer.disposable.isDisposed else { return }
      observer.failed(SwifterError(error: error))
    }
  }
}

//TODO: Explore error handling in Swifter
fileprivate extension SwifterError {

  init(kind: ErrorKind) {
    self.kind = kind
    self.message = ""
  }

  init(error: Error) {

    if let error = error as? SwifterError {
      self.kind = error.kind
      self.message = error.message
    } else {
      self.message = error.localizedDescription
      self.kind = .invalidJSONResponse
    }
  }
}
