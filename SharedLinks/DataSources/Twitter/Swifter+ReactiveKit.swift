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

  func homeTimeline(
    count: Int? = nil,
    sinceID: String? = nil,
    maxID: String? = nil,
    trimUser: Bool? = nil,
    contributorDetails: Bool? = nil,
    includeEntities: Bool? = nil
  ) -> Signal<JSON, SwifterError>
  {
    return Signal { observer in

      let disposable = SimpleDisposable()

      self.base.getHomeTimeline(
        count: count,
        sinceID: sinceID,
        maxID: maxID,
        trimUser: trimUser,
        contributorDetails: contributorDetails,
        includeEntities: includeEntities,
        success: { json in

          guard !disposable.isDisposed else { return }
          observer.completed(with: json)

        }, failure: { error in

          guard !disposable.isDisposed else { return }

          //TODO: Explore error handling in Swifter
          if let error = error as? SwifterError {
            observer.failed(error)
          } else {
            observer.failed(SwifterError(error: error))
          }

        }
      )

      return disposable
    }
  }

}

//TODO: Explore error handling in Swifter
fileprivate extension SwifterError {

  init(error: Error) {
    self.message = error.localizedDescription
    self.kind = .invalidJSONResponse
  }
}
