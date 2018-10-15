//  Copyright © 2018 mrlines. All rights reserved.

import UIKit

final class ProgressView: UIView {
    // MARK: - Colors
    private let kDefaultProgressTintColor = UIColor(red: 15, green: 120, blue: 250)
    private let kDefaultTrackTintColor = UIColor(red: 182, green: 182, blue: 182)

    // Set to `dynamic` in order to support to change via UIAppearance
    @objc public dynamic var progressTintColor: UIColor? {
        didSet {
            guard let progressTintColor = progressTintColor else {
                progressLayer.strokeColor = kDefaultProgressTintColor.cgColor
                return
            }

            progressLayer.strokeColor = progressTintColor.cgColor
        }
    }

    // Set to `dynamic` in order to support to change via UIAppearance
    @objc public dynamic var trackTintColor: UIColor? {
        didSet {
            guard let trackTintColor = trackTintColor else {
                backgroundColor = kDefaultTrackTintColor
                return
            }

            backgroundColor = trackTintColor
        }
    }

    // MARK: - Layer
    private lazy var progressLayer: CAShapeLayer = {
        return makeShapeLayer(rect: bounds, color: kDefaultProgressTintColor.cgColor)
    }()

    // MARK: - Progress
    private var _progress: Float = 0.0

    /// The current progress shown by the receiver.
    /// The current progress is represented by a floating-point value between 0.0 and 1.0, inclusive,
    /// where 1.0 indicates the completion of the task.
    /// The default value is 0.0. Values less than 0.0 and greater than 1.0 are pinned to those limits.
    public var progress: Float {
        get {
            return _progress
        }
        set {
            setProgress(newValue, animated: false)
        }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        // UIAppearance swizzles all setters that have a default apperance, and tracks when they get changed, so that UIAppearance doesn’t override your customizations.
        // Only use direct ivar access in the initializer for properties that comply to UI_APPEARANCE_SELECTOR
        progressLayer.strokeColor = kDefaultProgressTintColor.cgColor
        backgroundColor = kDefaultTrackTintColor
        
        layer.addSublayer(progressLayer)
    }

    // MARK: - Overrides
    override func layoutSubviews() {
        super.layoutSubviews()
        setLine(for: progressLayer, rect: bounds)
    }

    // MARK: - Public
    public func setProgress(_ progress: Float, animated: Bool) {
        let newProgress = max(min(1.0, progress), 0.0)

        progressLayer.isHidden = newProgress == 0.0
        guard newProgress != 0.0 else {
            setProgressWithoutAnimation(newProgress)
            return
        }

        if animated {
            animate(from: _progress, to: newProgress)
        }

        setProgressWithoutAnimation(newProgress)
    }
}

// MARK: - Private
private extension ProgressView {

    private func setProgressWithoutAnimation(_ progress: Float) {
        _progress = progress
        progressLayer.strokeEnd = CGFloat(progress)
    }

    private func animate(from fromValue: Float, to toValue: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = fromValue
        animation.toValue = toValue
        progressLayer.add(animation, forKey: animation.keyPath)
    }

    private func makeShapeLayer(rect: CGRect, color: CGColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        setLine(for: layer, rect: rect)
        layer.strokeColor = color
        
        // Disable default animation for `strokeEnd`
        layer.actions = ["strokeEnd": NSNull()]
        
        return layer
    }
    
    private func setLine(for layer: CAShapeLayer, rect: CGRect, animationDisabled: Bool = true) {
        CATransaction.setDisableActions(animationDisabled)
        
        layer.path = makeLine(rect)
        layer.lineWidth = rect.height
        
        CATransaction.setDisableActions(false)
    }
    
    private func makeLine(_ rect: CGRect) -> CGPath {
        let start = CGPoint(x: rect.origin.x, y: rect.midY)
        let end = CGPoint(x: rect.maxX, y: rect.midY)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        return path.cgPath
    }
}
