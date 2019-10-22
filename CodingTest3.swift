import Foundation

class CodingTest3 {

/**
     문제 3: word에서 동일한 글자가 k만큼 연속으로 나오는 경우 제거해서 최종적으로 k만큼 글자가 반복되는 경우가 없어야 한다.
     word = aabbcccb, k = 3
     aabbcccb -> aabbb -> aa
*/

    func run() {
        print(compress3_(word: "aabbccbbdddddccccccccccbbaaaaaacbaf", k: 3))
    }
/**
     코테 제출 답
     결과 : 1,2 테스트 코드는 합격하였지만, 이후 테스트 코드 실패
     풀이 : k만큼 연속되는 글자를 줄이면 된다는 해석하에 word에 있는 알파벳을 확인 후 알파벳별로 length를 k만큼 증가 시켜 replacing을 통해 줄여나감.
     원인 :
        1. 문제 해석 실패와 급한 마음에 실패 원인을 보지 않고 넘어감.
            - 예제와 번역을 통해 이해한 문제는 k만큼 줄여 나가는 것으로 판단하고 진행. k만큼만 줄이는게 맞았다면 실패원인은 타임아웃. 아니라면 문제 해석 실패
              실패인다. 아마 k 이상 연속되는 글자를 줄이는 것일 수도 있다.
        2. 타임아웃이라면?
            -
*/
    func compress1(word: String, k: Int) -> String {
        let split = word.map { String($0) }
        let tempArray = Set(split).map { String(repeating: $0, count: k) }

        var tempWord = word

        while let s = find1(word: tempWord, elements: tempArray) {
            tempWord = tempWord.replacingOccurrences(of: s, with: "")
        }
        return tempWord
    }

    func find1(word: String, elements: [String]) -> String? {
        for s in elements where word.contains(s) {
            return s
        }

        return nil
    }

/**
     원인이 타임아웃이라는 가정하에 개선해보자.

     매번 확인하면서 compress하기 보다 한번에 compress하고 문자열에 k만큼 연속되는 부분이 있는지 확인하면, 반복되는 작업이 좀더 줄 것 같다.......
*/
    func compress2(word: String, k: Int) -> String {
        let letters = Set(word.map { String($0) })
        let tempArray = letters.map { String(repeating: $0, count: k) }

        var tempWord = word
        repeat {
            tempWord = stringByRemovingAll(word: tempWord, subStrings: tempArray)
        } while find2(word: tempWord, elements: tempArray)

        return tempWord
    }

    func find2(word: String, elements: [String]) -> Bool {
        for element in elements {
            if word.contains(element) {
                return true
            }
        }
        return false
    }

    func stringByRemovingAll(word: String, subStrings: [String]) -> String {
        var resultString = word
        subStrings.forEach {
            resultString = resultString.replacingOccurrences(of: $0, with: "")
        }
        return resultString
    }


/**
     문제 해석을 잘못했다는 전제하에 k 이상만큼 연속되는 글자를 compress 하는 거라면....?
*/
    func compress3(word: String, k: Int) -> String {
        var letters = word.map { String($0) }

        while let temp = find3(letters: letters, k: k) {
            letters = temp
        }

        return letters.joined()
    }

    func find3(letters: [String], k: Int) -> [String]? {
        var tempLetter = ""
        var count = 0

        for (index, letter) in letters.enumerated() {
            if letter == tempLetter {
                count += 1
                if (letters.count - 1) == index, count >= k {
                    return removeSubrange(letters: letters, start: (index + 1) - count, end: index)
                }
            } else if count >= k {
                return removeSubrange(letters: letters, start: index - count, end: index - 1)
            } else {
                count = 1
            }

            tempLetter = letter
        }

        return nil
    }

    func removeSubrange(letters: [String], start: Int, end: Int) -> [String] {
        var tempLetters = letters
        let startIndex = tempLetters.index(tempLetters.startIndex, offsetBy: start)
        let endIndex = tempLetters.index(tempLetters.startIndex, offsetBy: end)
        tempLetters.removeSubrange(startIndex...endIndex)
        return tempLetters
    }
}
