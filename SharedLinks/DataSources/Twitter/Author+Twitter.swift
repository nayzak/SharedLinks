//
//  Author+Twitter.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 28/07/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation
import SwifterMac

extension Author {

  init?(tweetUser json: SwifterMac.JSON) {
    guard let name = json["name"].string else { return nil}

    self.name = name
    self.avatar = json["profile_image_url_https"].string
      .flatMap { $0.replacingOccurrences(of: "_normal", with: "") }
      .flatMap(URL.init(string:))
  }
}
