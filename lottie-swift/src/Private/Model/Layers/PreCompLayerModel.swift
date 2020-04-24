//
//  PreCompLayer.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/8/19.
//

import Foundation
import UIKit

/// A layer that holds another animation composition.
public final class PreCompLayerModel: LayerModel {
  
  /// The reference ID of the precomp.
  public var referenceID: String
  
  /// A value that remaps time over time.
  let timeRemapping: KeyframeGroup<Vector1D>?
  
  /// Precomp Width
  public var width: Double
  
  /// Precomp Height
  public var height: Double
  
  public var viewTransform: CGAffineTransform = .identity

  private enum CodingKeys : String, CodingKey {
    case referenceID = "refId"
    case timeRemapping = "tm"
    case width = "w"
    case height = "h"
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: PreCompLayerModel.CodingKeys.self)
    self.referenceID = try container.decode(String.self, forKey: .referenceID)
    self.timeRemapping = try container.decodeIfPresent(KeyframeGroup<Vector1D>.self, forKey: .timeRemapping)
    self.width = try container.decode(Double.self, forKey: .width)
    self.height = try container.decode(Double.self, forKey: .height)
    try super.init(from: decoder)
  }
  
  override public func encode(to encoder: Encoder) throws {
    try super.encode(to: encoder)
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(referenceID, forKey: .referenceID)
    try container.encode(timeRemapping, forKey: .timeRemapping)
    try container.encode(width, forKey: .width)
    try container.encode(height, forKey: .height)
  }
  
}
