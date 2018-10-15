//  Copyright © 2018 mrlines. All rights reserved.

import XCTest
@testable import ProgressViewSample

class ProgressViewTests: XCTestCase {
    private let expectedDefaultProgressTintColor = UIColor(red: 15, green: 120, blue: 250)
    private let expectedDefaultTrackTintColor = UIColor(red: 182, green: 182, blue: 182)

    override func tearDown() {
        super.tearDown()

        // Cleanup
        ProgressView.appearance().progressTintColor = nil
        ProgressView.appearance().trackTintColor = nil
    }

    // MARK: - Progress property
    func testProgress_whenInit_shouldBe0() {
        // Arrange
        let sut = ProgressView(frame: .zero)

        // Assert
        XCTAssertEqual(sut.progress, 0)
    }


    func testProgress_whenHigherThen1_shouldBe1() {
        // Arrange
        let sut = ProgressView(frame: .zero)

        // Act
        sut.progress = 2

        // Assert
        XCTAssertEqual(sut.progress, 1)
    }

    func testProgress_whenLessThen0_shouldBe0() {
        // Arrange
        let sut = ProgressView(frame: .zero)

        // Act
        sut.progress = -1

        // Assert
        XCTAssertEqual(sut.progress, 0)
    }

    func testProgress_whenSetToValueBetween0And1_shouldReturnSameValue() {
        // Arrange
        let sut = ProgressView(frame: .zero)

        // Act
        sut.progress = 0.5

        // Assert
        XCTAssertEqual(sut.progress, 0.5)
    }

    // MARK: - Colors
    func testColors_whenInit_shouldHaveDefaultColors() {
        // Arrange
        let sut = ProgressView(frame: .zero)

        // Assert
        XCTAssertEqual(sut.progressTintColor, expectedDefaultProgressTintColor)
        XCTAssertEqual(sut.trackTintColor, expectedDefaultTrackTintColor)
    }

    func testColors_whenChanged_shouldReflectNewColors() {
        // Arrange
        let sut = ProgressView(frame: .zero)

        // Act
        sut.progressTintColor = .red
        sut.trackTintColor = .blue

        // Assert
        XCTAssertEqual(sut.progressTintColor, UIColor.red)
        XCTAssertEqual(sut.trackTintColor, UIColor.blue)
    }

    func testAppearance_whenInit_shouldUseColorsDefinedViaAppearance() {
        // Arrange
        ProgressView.appearance().progressTintColor = .green
        ProgressView.appearance().trackTintColor = .black

        // Act
        let sut = ProgressView(frame: .zero)

        // Assert
        XCTAssertEqual(sut.progressTintColor, UIColor.green)
        XCTAssertEqual(sut.trackTintColor, UIColor.black)
    }

    func testAppearance_whenCustomColors_shouldUseCustomColors() {
        // Arrange
        ProgressView.appearance().progressTintColor = .green
        ProgressView.appearance().trackTintColor = .black

        let sut = ProgressView(frame: .zero)

        // Act
        sut.progressTintColor = .red
        sut.trackTintColor = .blue

        // Assert
        XCTAssertEqual(sut.progressTintColor, UIColor.red)
        XCTAssertEqual(sut.trackTintColor, UIColor.blue)
    }
}
