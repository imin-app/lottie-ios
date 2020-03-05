//
//  TextDocument.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/9/19.
//

import Foundation

public enum TextJustification: Int, Codable {
  case left
  case right
  case center
}

public final class TextDocument: Codable {
  
  /// The Text
  public var text: String
  
  /// The Font size
  public var fontSize: Double
  
  /// The Font Family
  public var fontFamily: String
  
  /// Justification
  public var justification: TextJustification
  
  /// Tracking
  public var tracking: Int
  
  /// Line Height
  public var lineHeight: Double
  
  /// Baseline
  public var baseline: Double?
  
  /// Fill Color data
  public var fillColorData: Color
  
  /// Scroke Color data
  public var strokeColorData: Color?
  
  /// Stroke Width
  public var strokeWidth: Double?
  
  /// Stroke Over Fill
  public var strokeOverFill: Bool?
  
  public var textFramePosition: Vector3D?
  
  public var textFrameSize: Vector3D?
  
  private enum CodingKeys : String, CodingKey {
    case text = "t"
    case fontSize = "s"
    case fontFamily = "f"
    case justification = "j"
    case tracking = "tr"
    case lineHeight = "lh"
    case baseline = "ls"
    case fillColorData = "fc"
    case strokeColorData = "sc"
    case strokeWidth = "sw"
    case strokeOverFill = "of"
    case textFramePosition = "ps"
    case textFrameSize = "sz"
  }
}
