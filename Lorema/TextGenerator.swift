import Foundation

enum GenerationMode {
    case lorem
    case random
}

struct TextGenerator {
    static func generate(wordCount: Int, mode: GenerationMode) -> String {
        guard wordCount > 0 else { return "" }

        let amountOfWords = min(wordCount, Structures.MAX_WORD_LIMIT)

        var finalText = amountOfWords <= 10 ? Structures.LOREM_WORDS_CLEAN : Structures.LOREM_WORDS_DIRTY
        var finalLength = Structures.textLength

        while amountOfWords > finalLength {
            finalLength += Structures.textLength
            finalText.append(contentsOf: Structures.LOREM_WORDS_DIRTY)
        }

        var result = finalText.shuffled().prefix(amountOfWords)

        if mode == .lorem {
            if amountOfWords <= 5 {
                result = Structures.LOREM_START_TEXT.prefix(amountOfWords)
            } else {
                result.removeSubrange(0...4)
                result.insert(contentsOf: Structures.LOREM_START_TEXT, at: 0)
            }
        } else {
            let firstWord = result[0]
            result[0] = firstWord.capitalized
        }

        for i in result.indices {
            if result[i].contains(".") {
                let isIndexValid = result.indices.contains(i + 1)
                if isIndexValid {
                    result[i + 1] = result[i + 1].capitalized
                }
            }
        }

        if amountOfWords > 10 {
            let lastWord = result[result.count - 1]
            result.removeLast()
            if !lastWord.hasSuffix(".") && !lastWord.hasSuffix(",") {
                result.append(lastWord + ".")
            } else {
                result.append(String(lastWord.dropLast()) + ".")
            }
        }

        return Array(result).joined(separator: " ")
    }
}
