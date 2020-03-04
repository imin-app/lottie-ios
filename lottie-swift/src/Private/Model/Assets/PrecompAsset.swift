//
//  PrecompAsset.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/9/19.
//

import Foundation

public final class PrecompAsset: Asset {
  
  /// Layers of the precomp
  public var layers: [LayerModel]
  
  enum CodingKeys : String, CodingKey {
    case layers = "layers"
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: PrecompAsset.CodingKeys.self)
    self.layers = try container.decode([LayerModel].self, ofFamily: LayerType.self, forKey: .layers)
    try super.init(from: decoder)
  }
  
  override public func encode(to encoder: Encoder) throws {
    try super.encode(to: encoder)
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(layers, forKey: .layers)
  }
}
