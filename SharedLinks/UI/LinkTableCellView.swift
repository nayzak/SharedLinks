//
//  LinkTableCellView.swift
//  SharedLinks
//
//  Created by Ian Kazlauskas on 28/07/2017.
//  Copyright © 2017 Ian Kazlauskas. All rights reserved.
//

import Cocoa
import SDWebImage

class LinkTableCellView: NSTableCellView {

  struct Model: Equatable {

    let uuid: Int
    let image: URL?
    let title: String
    let subtitle: String?
    let text: String
    
    static func==(lhs: Model, rhs: Model) -> Bool {
      return lhs.uuid == rhs.uuid
    }
  }

  @IBOutlet fileprivate weak var imageWidthConstraint: NSLayoutConstraint!
  @IBOutlet fileprivate weak var imageHeightConstraint: NSLayoutConstraint!
  @IBOutlet fileprivate weak var imageTrailingToLabelLeadingConstraint: NSLayoutConstraint!
  @IBOutlet fileprivate weak var leftPaddingConstraint: NSLayoutConstraint!
  @IBOutlet fileprivate weak var topPaddingConstraint: NSLayoutConstraint!
  @IBOutlet fileprivate weak var rightPaddingConstraint: NSLayoutConstraint!
  @IBOutlet fileprivate weak var bottomPaddingConstraint: NSLayoutConstraint!

  var model: Model? {
    didSet {
      textField?.attributedStringValue = model.flatMap(LinkTableCellView.attributedText) ?? .empty
      imageView?.sd_setImage(with: model?.image, placeholderImage: nil, options: .scaleDownLargeImages)
    }
  }

  override var objectValue: Any? {
    didSet {
      model = objectValue as? Model
    }
  }

}

// MARK: Appearance

extension LinkTableCellView {

  fileprivate static func attributedText(with model: Model) -> NSAttributedString {

    var paragraphs: [NSAttributedString] = []

    if (!model.title.isEmpty) {
      let title = NSAttributedString(string: model.title, attributes: [
        .font: NSFont.boldSystemFont(ofSize: 13),
        .foregroundColor: NSColor(calibratedWhite: 51 / 255.0, alpha: 1)
      ])
      paragraphs.append(title)
    }

    if let subtitleString = model.subtitle, !subtitleString.isEmpty {
      let subtitle = NSAttributedString(string: subtitleString, attributes: [
        .font: NSFont.systemFont(ofSize: 12),
        .foregroundColor: NSColor(calibratedWhite: 51 / 255.0, alpha: 1)
      ])
      paragraphs.append(subtitle)
    }

    if (!model.text.isEmpty) {
      let text = NSAttributedString(string: model.text, attributes: [
        .font: NSFont.systemFont(ofSize: 12),
        .foregroundColor: NSColor(calibratedWhite: 76 / 255.0, alpha: 1)
      ])
      paragraphs.append(text)
    }

    return NSAttributedString(attrStrings: paragraphs, separator: "\n")
  }

  override var imageView: NSImageView? {
    didSet {
      imageView?.apply {
        $0.imageAlignment = .alignCenter
        $0.imageScaling = .scaleProportionallyUpOrDown
        $0.wantsLayer = true
        $0.layer?.apply {
          $0.cornerRadius = 2
          $0.masksToBounds = true
        }
      }
    }
  }

}

// MARK: NSTableView

extension LinkTableCellView {

  static let identifier = NSUserInterfaceItemIdentifier(rawValue: "LinkTableCellView")

  static func rowHeight(forWidth cellWidth: CGFloat, using model: Model) -> CGFloat {
    let totalHorizontalPadding = padding.left + padding.right
    let totalVerticalPadding = padding.top + padding.bottom
    let maxHeight: CGFloat = 150
    let minHeight = imageSize.height + totalVerticalPadding
    let textWidth = cellWidth - (imageSize.width + imageToLabelHorizontalSpace + totalHorizontalPadding)
    let maxTextSize = NSSize(width: textWidth, height: maxHeight - totalVerticalPadding)
    let text = attributedText(with: model)
    let textSize = text.boundingRect(
      with: maxTextSize,
      options: [.usesLineFragmentOrigin, .usesFontLeading]
    )
    let calculatedHeight = textSize.height + totalVerticalPadding
    return max(minHeight, calculatedHeight)
  }

  private static let instance: LinkTableCellView = {
    let nib = NSNib(nibNamed: NSNib.Name(rawValue: identifier.rawValue), bundle: nil)!
    var nibObjects: NSArray?
    nib.instantiate(withOwner: nil, topLevelObjects: &nibObjects)
    return nibObjects!
      .flatMap { $0 as? LinkTableCellView }
      .first!
  }()

  private static var padding: NSEdgeInsets {
    return NSEdgeInsets(
      top: instance.topPaddingConstraint.constant,
      left: instance.leftPaddingConstraint.constant,
      bottom: instance.bottomPaddingConstraint.constant,
      right: instance.rightPaddingConstraint.constant
    )
  }

  private static var imageSize: NSSize {
    return NSSize(
      width: instance.imageWidthConstraint.constant,
      height: instance.imageHeightConstraint.constant
    )
  }

  private static var imageToLabelHorizontalSpace: CGFloat {
    return instance.imageTrailingToLabelLeadingConstraint.constant
  }

}
