//
//  StickerLayerModel.swift
//  Lottie_iOS
//
//  Created by Берн on 19.05.2020.
//  Copyright © 2020 YurtvilleProds. All rights reserved.
//

import Foundation
import UIKit

public final class StickerLayerModel: Codable {
    
  /// url
  public var stickerUrl: String
  
  /// view defines
  public var viewTransform: CGAffineTransform
  public var viewPosition: CGPoint
  public var viewBounds: CGRect

  private enum CodingKeys : String, CodingKey {
    case stickerUrl = "stickerUrl"
      case viewTransform = "viewTransform"
      case viewPosition = "viewPosition"
      case viewBounds = "viewBounds"
  }
  
  public init(url: String, transform: CGAffineTransform, position: CGPoint, bounds: CGRect) {
        stickerUrl = url
        viewTransform = transform
        viewPosition = position
        viewBounds = bounds
  }
    
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: StickerLayerModel.CodingKeys.self)
    self.stickerUrl = try container.decode(String.self, forKey: .stickerUrl)
    self.viewTransform = try container.decode(CGAffineTransform.self, forKey: .viewTransform)
    self.viewPosition = try container.decode(CGPoint.self, forKey: .viewPosition)
    self.viewBounds = try container.decode(CGRect.self, forKey: .viewBounds)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(stickerUrl, forKey: .stickerUrl)
    try container.encode(viewTransform, forKey: .viewTransform)
    try container.encode(viewPosition, forKey: .viewPosition)
    try container.encode(viewBounds, forKey: .viewBounds)
  }
  
}
