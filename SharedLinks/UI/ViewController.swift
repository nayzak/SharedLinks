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
import Bond

class ViewController: NSViewController {

  private let service = LinksService()
  
  override func viewDidAppear() {
    super.viewDidAppear()

    service.links.bind(to: self) { vc, links in print(links) }
  }

}
