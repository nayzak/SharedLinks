//
//  AppDelegate.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 27/07/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

  var popover: NSPopover!
  var menuBarItem: NSStatusItem!

  func applicationDidFinishLaunching(_ notification: Notification) {

    popover = NSPopover().apply {
      $0.contentViewController = LinksListViewController()
      $0.animates = false
    }

    menuBarItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength).apply {
      $0.button?.apply {
        $0.image = #imageLiteral(resourceName: "menu-bar-icon")
        $0.action = #selector(togglePopover(_:))
      }
    }
  }

  func applicationWillTerminate(_ notification: Notification) {
    // Insert code here to tear down your application
  }

  @objc private func togglePopover(_ sender: Any?) {
    if popover.isShown {
      closePopover()
    } else {
      showPopover()
    }
  }

  private func showPopover() {
    guard let button = menuBarItem.button else { return }
    popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
  }

  private func closePopover() {
    popover.performClose(nil)
  }
}
