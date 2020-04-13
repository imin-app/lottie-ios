//
//  LayerContainer.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/22/19.
//

import Foundation
import QuartzCore

/**
 The base class for a child layer of CompositionContainer
 */
public class CompositionLayer: CALayer, KeypathSearchable {
  
  weak var layerDelegate: CompositionLayerDelegate?
  
  let transformNode: LayerTransformNode
  
  let contentsLayer: CALayer = CALayer()
  
  let maskLayer: MaskContainerLayer?
  
  let matteType: MatteType?
  
  var renderScale: CGFloat = 1 {
    didSet {
      self.updateRenderScale()
    }
  }
  
  var matteLayer: CompositionLayer? {
    didSet {
      if let matte = matteLayer {
        if let type = matteType, type == .invert {
          mask = InvertedMatteLayer(inputMatte: matte)
        } else {
          mask = matte
        }
      } else {
        mask = nil
      }
    }
  }
  
  let inFrame: CGFloat
  let outFrame: CGFloat
  let startFrame: CGFloat
  let timeStretch: CGFloat
  
  init(layer: LayerModel, size: CGSize) {
    self.transformNode = LayerTransformNode(transform: layer.transform)
    if let masks = layer.masks {
      maskLayer = MaskContainerLayer(masks: masks)
    } else {
      maskLayer = nil
    }
    self.matteType = layer.matte
    self.inFrame = layer.inFrame.cgFloat
    self.outFrame = layer.outFrame.cgFloat
    self.timeStretch = layer.timeStretch.cgFloat
    self.startFrame = layer.startTime.cgFloat
    self.keypathName = layer.name
    self.childKeypaths = [transformNode.transformProperties]
    super.init()
    self.anchorPoint = .zero
    self.actions = [
      "opacity" : NSNull(),
      "transform" : NSNull(),
      "bounds" : NSNull(),
      "anchorPoint" : NSNull(),
      "sublayerTransform" : NSNull()
    ]
    
    contentsLayer.anchorPoint = .zero
    contentsLayer.bounds = CGRect(origin: .zero, size: size)
    contentsLayer.actions = [
      "opacity" : NSNull(),
      "transform" : NSNull(),
      "bounds" : NSNull(),
      "anchorPoint" : NSNull(),
      "sublayerTransform" : NSNull(),
      "hidden" : NSNull()
    ]
    addSublayer(contentsLayer)
    
    if let maskLayer = maskLayer {
      contentsLayer.mask = maskLayer
    }
  }
  
  override init(layer: Any) {
    /// Used for creating shadow model layers. Read More here: https://developer.apple.com/documentation/quartzcore/calayer/1410842-init
    guard let layer = layer as? CompositionLayer else {
      fatalError("Wrong Layer Class")
    }
    self.transformNode = layer.transformNode
    self.matteType = layer.matteType
    self.inFrame = layer.inFrame
    self.outFrame = layer.outFrame
    self.timeStretch = layer.timeStretch
    self.startFrame = layer.startFrame
    self.keypathName = layer.keypathName
    self.childKeypaths = [transformNode.transformProperties]
    self.maskLayer = nil
    super.init(layer: layer)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  final func displayWithFrame(frame: CGFloat, forceUpdates: Bool) {
//    if (self is TextCompositionLayer) {
//        let anchor = KeyframeGroup(Vector3D(x: Double(0), y: 0, z: 0))
//        transformNode.transformProperties.anchor = NodeProperty(provider: KeyframeInterpolator(keyframes: anchor.keyframes))
//
//    }
//    if (self is TextCompositionLayer) {
//        if let anchor = (transformNode.transformProperties.properties[1] as? NodeProperty<Vector3D>)?.value {
//            transformNode.globalTransform.m41 -= CGFloat(anchor.x)
//            transformNode.globalTransform.m42 -= CGFloat(anchor.y)
//            print(anchor)
//        }
//    }
    transformNode.updateTree(frame, forceUpdates: forceUpdates)
    
    if (self is TextCompositionLayer) {
//        if let anchor = (transformNode.transformProperties.properties[1] as? NodeProperty<Vector3D>)?.value {
        if let anchor = transformNode.transformProperties.position?.value {
            transformNode.globalTransform.m41 -= CGFloat(anchor.x)
            transformNode.globalTransform.m42 -= CGFloat(anchor.y)
            print(anchor)
        }
    }

    
    let layerVisible = frame.isInRangeOrEqual(inFrame, outFrame)
    /// Only update contents if current time is within the layers time bounds.
    if layerVisible {
      displayContentsWithFrame(frame: frame, forceUpdates: forceUpdates)
      maskLayer?.updateWithFrame(frame: frame, forceUpdates: forceUpdates)
    }
    

        contentsLayer.transform = transformNode.globalTransform

//    } else {
//        contentsLayer.transform = transformNode.localTransform
//    }
    contentsLayer.opacity = transformNode.opacity
    contentsLayer.isHidden = !layerVisible
    layerDelegate?.frameUpdated(frame: frame)
  }
  
  func displayContentsWithFrame(frame: CGFloat, forceUpdates: Bool) {
    /// To be overridden by subclass
  }
  
  // MARK: Keypath Searchable
  
  public let keypathName: String
  
  public var keypathProperties: [String : AnyNodeProperty] {
    return [:]
  }
  
  public final var childKeypaths: [KeypathSearchable]
  
  public var keypathLayer: CALayer? {
    return contentsLayer
  }
  
  func updateRenderScale() {
    self.contentsScale = self.renderScale
  }
}

protocol CompositionLayerDelegate: class {
  func frameUpdated(frame: CGFloat)
}

