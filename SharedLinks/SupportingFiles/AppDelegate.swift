//
//  AppDelegate.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 27/07/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

  var window: NSWindow!

  func applicationDidFinishLaunching(_ notification: Notification) {
    let linksViewController = LinksListViewController()
    window = NSWindow(contentViewController: linksViewController)
    window.makeKeyAndOrderFront(nil)
  }

  func applicationWillTerminate(_ notification: Notification) {
    // Insert code here to tear down your application
  }
}

