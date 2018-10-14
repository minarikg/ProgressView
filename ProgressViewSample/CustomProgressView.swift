//  Copyright © 2018 mrlines. All rights reserved.

import UIKit

final class CustomProgressView: UIProgressView {
    private let height: CGFloat

    override init(frame: CGRect) {
        height = frame.height
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let newSize = CGSize(width: size.width, height: height)
        return newSize
    }
}
