//
//  NSTableView.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 28/07/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Cocoa
import ReactiveKit
import Bond

extension ReactiveExtensions where Base: NSTableView {

  var selectedRow: SafeSignal<Int> {
    return self.selectionDidChange.map { [unowned base] in base.selectedRow }
  }
}
