//
//  ViewController.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 27/07/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Cocoa
import Accounts
import SwifterMac

class ViewController: NSViewController {

  override func viewDidAppear() {
    super.viewDidAppear()

    let store = ACAccountStore()
    let twitterAccountType = store.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
    store.requestAccessToAccounts(with: twitterAccountType, options: nil) { granted, error in
      if (granted) {
        let twitterAccounts = store.accounts(with: twitterAccountType) as? [ACAccount]
        if let account = twitterAccounts?.first {
          let swifter = Swifter(account: account)
          swifter.getHomeTimeline(success: { json in
            print(json)
          }, failure: { error in
            print(error)
          })
        }
      }
    }
  }
  
}
