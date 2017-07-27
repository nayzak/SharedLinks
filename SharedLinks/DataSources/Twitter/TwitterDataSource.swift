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

  func homeTimeline() -> Signal<[Link], TwitterDataSourceError> {

    func decode(_ json: JSON) -> [Link] {
      return json.array?.flatMap(Link.init(tweet:)) ?? []
    }

    func timeline(_ swifter: Swifter) -> Signal<[Link], TwitterDataSourceError> {
      return swifter.reactive.homeTimeline()
        .map(decode)
        .mapError { TwitterDataSourceError.swifter($0) }
    }

    func combine(_ signals: [Signal<[Link], TwitterDataSourceError>]) -> Signal<[Link], TwitterDataSourceError> {
      return combineLatest(signals) { $0.reduce([], +) }
    }

    return twitterClients
      .flatMap(timeline)
      .flatMapLatest(combine)
  }

  private var twitterClients: Signal<[Swifter], TwitterDataSourceError> {
    return accounts.flatMap(Swifter.init)
  }

  private var accounts: Signal<[ACAccount], TwitterDataSourceError> {

    return Signal { observer in

      let disposable = SimpleDisposable()

      let store = ACAccountStore()
      let twitterType = store.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)

      store.requestAccessToAccounts(with: twitterType, options: nil) { granted, error in

        if disposable.isDisposed { return }

        if let error = error {
          observer.failed(.init(error: error))
          return
        }

        if (!granted) {
          observer.failed(.noAccountsAccess)
          return
        }

        let twitterAccounts = store.accounts(with: twitterType) as? [ACAccount]
        observer.completed(with: twitterAccounts ?? [])
      }
        
      return disposable
    }
  }
}
