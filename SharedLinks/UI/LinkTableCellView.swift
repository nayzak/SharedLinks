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
        NSFontAttributeName: NSFont.boldSystemFont(ofSize: 13),
        NSForegroundColorAttributeName: NSColor(calibratedWhite: 51 / 255.0, alpha: 1)
      ])
      paragraphs.append(title)
    }

    if let subtitleString = model.subtitle, !subtitleString.isEmpty {
      let subtitle = NSAttributedString(string: subtitleString, attributes: [
        NSFontAttributeName: NSFont.boldSystemFont(ofSize: 12),
        NSForegroundColorAttributeName: NSColor(calibratedWhite: 76 / 255.0, alpha: 1)
      ])
      paragraphs.append(subtitle)
    }

    if (!model.text.isEmpty) {
      let text = NSAttributedString(string: model.text, attributes: [
        NSFontAttributeName: NSFont.systemFont(ofSize: 12),
        NSForegroundColorAttributeName: NSColor(calibratedWhite: 76 / 255.0, alpha: 1)
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

  static let identifier = "LinkTableCellView"

  static func rowHeight(forWidth cellWidth: CGFloat, using model: Model) -> CGFloat {
    let padding: CGFloat = 8
    let imageSize = NSSize(width: 36, height: 36)
    let maxHeight: CGFloat = 200
    let minHeight: CGFloat = imageSize.height + 2 * padding
    let textWidth = cellWidth - (imageSize.width + 2 * padding + 10)
    let maxTextSize = NSSize(width: textWidth, height: maxHeight - 2 * padding)
    let text = attributedText(with: model)
    let textSize = text.boundingRect(with: maxTextSize, options: [.usesLineFragmentOrigin, .usesFontLeading])
    let calculatedHeight = textSize.height + 2 * padding
    return max(minHeight, calculatedHeight)
  }
}
