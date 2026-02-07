//
//  TextGeneratorTests.swift
//  LoremaTests
//
//  Created by Daniel Danielsson on 2024-01-01.
//

import XCTest
@testable import Lorema

final class TextGeneratorTests: XCTestCase {

    // MARK: - Word count accuracy

    func testWordCount1() {
        let result = TextGenerator.generate(wordCount: 1, mode: .lorem)
        XCTAssertEqual(result.split(separator: " ").count, 1)
    }

    func testWordCount5() {
        let result = TextGenerator.generate(wordCount: 5, mode: .lorem)
        XCTAssertEqual(result.split(separator: " ").count, 5)
    }

    func testWordCount10() {
        let result = TextGenerator.generate(wordCount: 10, mode: .random)
        XCTAssertEqual(result.split(separator: " ").count, 10)
    }

    func testWordCount50() {
        let result = TextGenerator.generate(wordCount: 50, mode: .lorem)
        XCTAssertEqual(result.split(separator: " ").count, 50)
    }

    func testWordCount100() {
        let result = TextGenerator.generate(wordCount: 100, mode: .random)
        XCTAssertEqual(result.split(separator: " ").count, 100)
    }

    func testWordCount1000() {
        let result = TextGenerator.generate(wordCount: 1000, mode: .lorem)
        XCTAssertEqual(result.split(separator: " ").count, 1000)
    }

    // MARK: - Clamping

    func testClampAtMaxWordLimit() {
        let result = TextGenerator.generate(wordCount: 2000, mode: .lorem)
        XCTAssertEqual(result.split(separator: " ").count, Structures.MAX_WORD_LIMIT)
    }

    // MARK: - Lorem mode

    func testLoremModeStartsWithLoremIpsum() {
        let result = TextGenerator.generate(wordCount: 20, mode: .lorem)
        XCTAssertTrue(result.hasPrefix("Lorem ipsum dolor sit amet,"))
    }

    func testLoremModeShortText() {
        let result = TextGenerator.generate(wordCount: 3, mode: .lorem)
        XCTAssertEqual(result, "Lorem ipsum dolor")
    }

    // MARK: - Random mode

    func testRandomModeDoesNotStartWithLoremIpsum() {
        let result = TextGenerator.generate(wordCount: 20, mode: .random)
        XCTAssertFalse(result.hasPrefix("Lorem ipsum"))
    }

    func testRandomModeFirstWordIsCapitalized() {
        let result = TextGenerator.generate(wordCount: 5, mode: .random)
        let firstChar = result.first!
        XCTAssertTrue(firstChar.isUppercase)
    }

    // MARK: - Punctuation

    func testOutputOver10WordsEndsWithPeriod() {
        let result = TextGenerator.generate(wordCount: 20, mode: .lorem)
        XCTAssertTrue(result.hasSuffix("."))
    }

    func testOutputOver10WordsEndsWithPeriodRandom() {
        let result = TextGenerator.generate(wordCount: 50, mode: .random)
        XCTAssertTrue(result.hasSuffix("."))
    }

    func testWordsAfterPeriodsAreCapitalized() {
        let result = TextGenerator.generate(wordCount: 500, mode: .random)
        let words = result.split(separator: " ").map(String.init)
        for i in 0..<words.count - 1 {
            if words[i].contains(".") {
                let nextWord = words[i + 1]
                let firstChar = nextWord.first!
                XCTAssertTrue(firstChar.isUppercase, "Word after period should be capitalized: '\(nextWord)' after '\(words[i])'")
            }
        }
    }

    // MARK: - Edge cases

    func testZeroInputReturnsEmpty() {
        let result = TextGenerator.generate(wordCount: 0, mode: .lorem)
        XCTAssertEqual(result, "")
    }

    func testNegativeInputReturnsEmpty() {
        let result = TextGenerator.generate(wordCount: -5, mode: .random)
        XCTAssertEqual(result, "")
    }

    // MARK: - Randomness

    func testTwoCallsProduceDifferentOutput() {
        let result1 = TextGenerator.generate(wordCount: 50, mode: .random)
        let result2 = TextGenerator.generate(wordCount: 50, mode: .random)
        XCTAssertNotEqual(result1, result2)
    }

    // MARK: - Word lists

    func testDirtyWordListCount() {
        XCTAssertEqual(Structures.LOREM_WORDS_DIRTY.count, 300)
    }

    func testCleanWordListCount() {
        XCTAssertEqual(Structures.LOREM_WORDS_CLEAN.count, 65)
    }
}
