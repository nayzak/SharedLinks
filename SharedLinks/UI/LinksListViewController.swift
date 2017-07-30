//
//  LinksListViewController.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 27/07/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Cocoa
import Accounts
import SwifterMac
import ReactiveKit
import Bond

class LinksListViewController: NSViewController {

  private var linksTableView: LinksTableView!
  private let service = LinksService()

  override func loadView() {

    linksTableView = LinksTableView()
    
    let scrollView = NSScrollView().apply { v in
      v.documentView = linksTableView
      v.hasVerticalScroller = true
      v.hasHorizontalScroller = false
      v.drawsBackground = false
      v.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
    }

//    view = NSVisualEffectView().apply { v in
//      v.blendingMode = .behindWindow
//      v.addSubview(scrollView)
//      v.frame = NSRect(x: 0, y: 0, width: 400, height: 600)
//    }

    view = NSView().apply { v in
      v.addSubview(scrollView)
      v.frame = NSRect(x: 0, y: 0, width: 400, height: 600)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    makeBindings()
  }

  private func open(url: URL) {
    NSWorkspace.shared().open(url)
  }
  
  private func makeBindings() {

    let items = MutableObservableArray<LinkTableCellView.Model>()
    service.links
      .flatMap(LinkTableCellView.Model.init)
      .observeNext { items.replace(with: $0, performDiff: true) }
      .dispose(in: bag)

    let selectedLinkIndex = SafePublishSubject<Int>()

    let selectedLink = selectedLinkIndex.combineLatest(with: service.links) { $1[$0] }
    selectedLink.bind(to: self) { vc, link in vc.open(url: link.url) }
    
    linksTableView.viewModel = LinksTableView.Model(
      items: items,
      selectItem: selectedLinkIndex.next
    )
  }
}

extension LinkTableCellView.Model {

  init(link: Link) {
    // TODO: Set LinkTableCellView.Model uuid not with Link.url.hashValue
    self.uuid = link.url.hashValue
    self.image = link.author.avatar
    self.title = link.author.name
    self.subtitle = nil
    self.text = link.description
  }
}
