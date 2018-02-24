//
//  LinksTableView.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 29/07/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Cocoa
import Bond

class LinksTableView: NSTableView {

  typealias Cell = LinkTableCellView

  struct Model {
    typealias ItemIndex = Int
    let items: ObservableArray<Cell.Model>
    let selectItem: ((ItemIndex) -> Void)?
  }

  var viewModel: Model? {
    didSet { self.bind(self.viewModel) }
  }

  fileprivate var lastFrame: NSRect?

  convenience init() {
    self.init(frame: .zero)
  }

  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    self.setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {

    self.allowsColumnReordering = false
    self.allowsColumnResizing = false
    self.backgroundColor = .clear
    self.verticalMotionCanBeginDrag = false
    self.allowsMultipleSelection = false
    self.allowsEmptySelection = true
    self.allowsColumnSelection = false
    self.intercellSpacing = .zero
    self.selectionHighlightStyle = .none
    
    let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "Links"))
    self.addTableColumn(column)
    self.headerView = nil

    let cellID = Cell.identifier.rawValue
    let nib = NSNib(nibNamed: NSNib.Name(rawValue: cellID), bundle: nil)
    self.register(nib, forIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellID))
  }

  override func layout() {
    super.layout()
    self.updateRowsHeightsIfNeeded()
  }

  private func updateRowsHeightsIfNeeded() {
    if let lastWidth = self.lastFrame?.width, lastWidth != self.frame.width {
      let indexes = IndexSet(0..<self.numberOfRows)
      self.noteHeightOfRows(withIndexesChanged: indexes)
    }
    self.lastFrame = self.frame
  }
}

// MARK: Bindings

extension LinksTableView {

  fileprivate func bind(_ vm: Model?) {
    guard let vm = vm else { self.unbindViewModel(); return }

    let bond = DefaultTableViewBond<ObservableArray<Cell.Model>>(
      measureCell: { items, row, view  in
        Cell.rowHeight(forWidth: view.bounds.width, using: items[row])
      },
      createCell: { _, _, view  in
        view.makeView(withIdentifier: Cell.identifier, owner: nil)
      }
    )

    vm.items.bind(to: self, using: bond)

    self.reactive.selectedRow
      .filter { $0 >= 0 }
      .bind(to: self) { view, row in
        vm.selectItem?(row)
        view.deselectRow(row)
      }
  }

  private func unbindViewModel() {
    self.dataSource = nil
    self.delegate = nil
    self.reloadData()
  }
}
