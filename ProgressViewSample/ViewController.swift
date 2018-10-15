//  Copyright © 2018 mrlines. All rights reserved.

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var animationSwitch: UISwitch!
    @IBOutlet weak var labelValue: UILabel!

    private let progressViewFrame = CGRect(x: 50, y: 120, width: 300, height: 10)
    private lazy var progressView = ProgressView(frame: progressViewFrame)

    override func viewDidLoad() {
        super.viewDidLoad()

        // You can use UIAppearance proxy to change colors for all ProgressView instances
        ProgressView.appearance().progressTintColor = UIColor(red: 143, green: 192, blue: 169)
        ProgressView.appearance().trackTintColor = UIColor(red: 206, green: 207, blue: 199)

        progressView.progress = 0.2
        view.addSubview(progressView)

        updateLabel()
    }

    // MARK: - Colors
    @IBAction func customColorsChanged(_ sender: UISwitch) {
        progressView.trackTintColor = sender.isOn ? .darkGray : nil
        progressView.progressTintColor = sender.isOn ? .black : nil
    }

    // MARK: - Progress property
    @IBAction func increaseTapped(_ sender: UIButton) {
        let progress = floatEqual(progressView.progress, 1) ? 0 : progressView.progress + 0.3
        progressView.setProgress(progress, animated: animationSwitch.isOn)

        updateLabel()
    }

    @IBAction func decreaseTapped(_ sender: UIButton) {
        let progress = floatEqual(progressView.progress, 0) ? 1.0 : progressView.progress - 0.2
        progressView.setProgress(progress, animated: animationSwitch.isOn)

        updateLabel()
    }

    // MARK: - Private
    private func updateLabel() {
        labelValue.text = "Progress: \(Int(progressView.progress * 100))%"
    }

    private func floatEqual(_ a: Float, _ b: Float) -> Bool {
        return abs(a - b) < Float.ulpOfOne
    }
}

