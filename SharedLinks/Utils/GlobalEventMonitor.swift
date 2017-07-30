//
//  GlobalEventMonitor.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 30/07/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Foundation
import Cocoa

class GlobalEventMonitor {
  
  typealias Handler = (NSEvent?) -> Void
  
  private var monitor: Any?
  private let mask: NSEventMask
  private let handler: Handler

  public init(mask: NSEventMask, handler: @escaping Handler) {
    self.mask = mask
    self.handler = handler
  }

  deinit {
    stop()
  }

  public func start() {
    monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
  }

  public func stop() {
    guard let monitor = self.monitor else { return }
    NSEvent.removeMonitor(monitor)
    self.monitor = nil
  }
}
