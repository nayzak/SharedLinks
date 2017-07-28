//
//  Author.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 28/07/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation

struct Author {

  let name: String
  let avatar: URL?
}

extension Author: Equatable {

  static func ==(lhs: Author, rhs: Author) -> Bool {
    //TODO: Implement Author equility not based on name
    return lhs.name == lhs.name
  }
}
