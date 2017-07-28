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

  @IBOutlet weak var tableView: NSTableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    makeBindings()
  }

  override func viewDidLayout() {
    super.viewDidLayout()
    updateRowsHeightsIfNeeded()
  }

  private let service = LinksService()

  private func makeBindings() {

    let tableViewBond = DefaultTableViewBond<ObservableArray<LinkTableCellView.Model>>(
      measureCell: { vms, index, tableView  in
        LinkTableCellView.rowHeight(forWidth: tableView.bounds.width, using: vms[index])
      },
      createCell: { vms, index, tableView  in
        tableView.make(withIdentifier: LinkTableCellView.identifier, owner: nil)
      })

    service.links.flatMap(LinkTableCellView.Model.init).bind(to: tableView, using: tableViewBond)

    tableView.reactive.selectedRow
      .with(latestFrom: service.links) { $1[$0] }
      .bind(to: self) { _, link in NSWorkspace.shared().open(link.url) }
  }

  private func setupTableView() {
    let nib = NSNib(nibNamed: LinkTableCellView.identifier, bundle: nil)
    tableView.register(nib, forIdentifier: LinkTableCellView.identifier)
  }

  private var lastTableViewWidth: CGFloat?

  private func updateRowsHeightsIfNeeded() {
    let tableViewWidth = tableView.bounds.width
    if let previousWidth = lastTableViewWidth, previousWidth != tableViewWidth {
      tableView.noteHeightOfRows(withIndexesChanged: IndexSet(0..<tableView.numberOfRows))
    }
    lastTableViewWidth = tableViewWidth
  }

}

extension LinkTableCellView.Model {

  init(link: Link) {
    self.image = link.url
    self.title = ""
    self.subtitle = nil
    self.text = link.description
  }
}
