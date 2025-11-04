//
//  TextAnalyzer.swift
//  SwiftUILearning
//
//  Created by 오정석 on 4/11/2025.
//

import Foundation
import NaturalLanguage

/// 텍스트 분석 도구
class TextAnalyzer {
    
    // MARK: - Language Detection
    
    /// 언어 감지
    func detectLanguage(text: String) -> String? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        
        guard let language = recognizer.dominantLanguage else {
            return nil
        }
        
        return language.rawValue  // "ko", "en", "ja" 등
    }
    
    // MARK: - Tokenization
    
    /// 단어 단위로 분리
    func tokenize(text: String) -> [String] {
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = text
        
        var tokens: [String] = []
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { tokenRange, _ in
            let token = String(text[tokenRange])
            tokens.append(token)
            return true
        }
        
        return tokens
    }
    
    // MARK: - Named Entity Recognition
    
    /// 개체명 인식 (인명, 지명, 조직명 등)
    func recognizeNamedEntities(text: String) -> [(entity: String, type: String)] {
        let tagger = NLTagger(tagSchemes: [.nameType])
        tagger.string = text
        
        var results: [(String, String)] = []
        
        tagger.enumerateTags(
            in: text.startIndex..<text.endIndex,
            unit: .word,
            scheme: .nameType
        ) { tag, tokenRange in
            if let tag = tag {
                let entity = String(text[tokenRange])
                let type = tag.rawValue
                results.append((entity, type))
            }
            return true
        }
        
        return results
    }
    
    // MARK: - Statistics
    
    /// 텍스트 통계
    func getStatistics(text: String) -> TextStatistics {
        let words = tokenize(text: text)
        let characters = text.filter { !$0.isWhitespace }
        let sentences = text.components(separatedBy: CharacterSet(charactersIn: ".!?"))
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        return TextStatistics(
            characterCount: characters.count,
            wordCount: words.count,
            sentenceCount: sentences.count
        )
    }
}

/// 텍스트 통계
struct TextStatistics {
    let characterCount: Int
    let wordCount: Int
    let sentenceCount: Int
}
