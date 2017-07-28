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

  @IBOutlet weak var tableView: NSTableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    service.links.bind(to: tableView) { links, index, tableView in
      let cell = tableView.make(withIdentifier: "LinkCell", owner: nil) as! NSTableCellView
      cell.textField?.stringValue = links[index].description
      return cell
    }
  }

}
