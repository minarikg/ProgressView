//  Copyright © 2018 mrlines. All rights reserved.

import UIKit

final class ProgressView: UIView {
    // MARK: - Colors
    private let kDefaultProgressTintColor = UIColor(red: 15, green: 120, blue: 250)
    private let kDefaultTrackTintColor = UIColor(red: 182, green: 182, blue: 182)

    private var defaultProgressTintColor: UIColor {
        return type(of: self).appearance().progressTintColor ?? kDefaultProgressTintColor
    }

    private var defaultTrackTintColor: UIColor {
        return type(of: self).appearance().trackTintColor ?? kDefaultTrackTintColor
    }

    // Set to `dynamic` in order to support to change via UIAppearance
    @objc public dynamic var progressTintColor: UIColor? {
        didSet {
            guard let progressTintColor = progressTintColor else {
                progressLayer.strokeColor = defaultProgressTintColor.cgColor
                return
            }

            progressLayer.strokeColor = progressTintColor.cgColor
        }
    }

    // Set to `dynamic` in order to support to change via UIAppearance
    @objc public dynamic var trackTintColor: UIColor? {
        get {
            return backgroundColor
        }
        set {
            guard let trackTintColor = newValue else {
                backgroundColor = defaultTrackTintColor
                return
            }

            backgroundColor = trackTintColor
        }
    }

    // MARK: - Layer
    private lazy var progressLayer: CAShapeLayer = {
        return makeShapeLayer(rect: bounds, color: defaultProgressTintColor.cgColor)
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
        progressTintColor = defaultProgressTintColor
        trackTintColor = defaultTrackTintColor
    }

    // MARK: - Overrides
    override func layoutSubviews() {
        super.layoutSubviews()

        let color = progressLayer.strokeColor ?? defaultProgressTintColor.cgColor

        progressLayer.removeFromSuperlayer()
        progressLayer = makeShapeLayer(rect: bounds, color: color)
        layer.addSublayer(progressLayer)

        setProgressWithoutAnimation(_progress)
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
        let start = CGPoint(x: rect.origin.x, y: rect.midY)
        let end = CGPoint(x: rect.maxX, y: rect.midY)

        return makeShapeLayer(start: start, end: end, lineWidth: rect.height, color: color)
    }

    private func makeShapeLayer(start: CGPoint, end: CGPoint, lineWidth: CGFloat, color: CGColor) -> CAShapeLayer {
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)

        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.lineWidth = lineWidth
        layer.strokeColor = color
        return layer
    }
}
