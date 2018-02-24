//
//  NSArray+ReactiveKit.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 04/08/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation
import ReactiveKit

extension ReactiveExtensions where Base: NSArray {

  static func array(withContentsOfFile path: String) -> SafeFuture<NSArray?> {
    return Signal { observer in
      let disposable = SimpleDisposable()
      DispatchQueue.global(qos: .background).async {
        guard !disposable.isDisposed else { return }
        let result = NSArray(contentsOfFile: path)
        observer.completed(with: result)
      }
      return disposable
    }
  }
}
