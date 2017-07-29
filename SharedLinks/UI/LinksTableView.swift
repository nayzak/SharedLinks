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
    didSet { bind(viewModel) }
  }

  fileprivate var lastFrame: NSRect?

  convenience init() {
    self.init(frame: .zero)
  }

  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {

    allowsColumnReordering = false
    allowsColumnResizing = false
    backgroundColor = .clear
    verticalMotionCanBeginDrag = false
    allowsMultipleSelection = false
    allowsEmptySelection = true
    allowsColumnSelection = false
    selectionHighlightStyle = .none
    
    let column = NSTableColumn(identifier: "Links")
    addTableColumn(column)
    headerView = nil

    let cellID = Cell.identifier
    let nib = NSNib(nibNamed: cellID, bundle: nil)
    register(nib, forIdentifier: cellID)
  }

  override func layout() {
    super.layout()
    updateRowsHeightsIfNeeded()
  }
  
  private func updateRowsHeightsIfNeeded() {
    if let lastWidth = lastFrame?.width, lastWidth != frame.width {
      let indexes = IndexSet(0..<numberOfRows)
      noteHeightOfRows(withIndexesChanged: indexes)
    }
    lastFrame = frame
  }
}

// MARK: Bindings

extension LinksTableView {

  fileprivate func bind(_ vm: Model?) {
    guard let vm = vm else { unbindViewModel(); return }

    let bond = DefaultTableViewBond<ObservableArray<Cell.Model>>(
      measureCell: { items, row, view  in
        Cell.rowHeight(forWidth: view.bounds.width, using: items[row])
      },
      createCell: { _, _, view  in
        view.make(withIdentifier: Cell.identifier, owner: nil)
      }
    )

    vm.items.bind(to: self, using: bond)

    reactive.selectedRow
      .filter { $0 >= 0 }
      .bind(to: self) { view, row in
        vm.selectItem?(row)
        view.deselectRow(row)
      }
  }

  private func unbindViewModel() {
    dataSource = nil
    delegate = nil
    reloadData()
  }
}
