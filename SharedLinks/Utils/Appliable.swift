//
//  Appliable.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 28/07/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation

public protocol Appliable: class { }

extension Appliable {

  @discardableResult
  public func apply(_ block: (Self) -> Void) -> Self {
    block(self)
    return self
  }

}

@discardableResult
public func with<T: Appliable>(_ target: T, _ block: (T) -> Void) -> T {
  return target.apply(block)
}

extension NSObject: Appliable { }
