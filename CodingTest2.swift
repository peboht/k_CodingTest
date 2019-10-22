import Foundation

class CodingTest2 {

/**
     문제 2: 문자열 A와 B를 비교하여, 문자열이 거의 같다고 볼수 있는지 파악해야한다. 글자가 3자 초과하여 다르다면 다른 것으로 간주하고 NO를 3자 이하라면
     YES를 뱉도록 하자. (a와 b의 길이는 같다)
     abbcccc / aaabbbc

     a / 1 - 3 = 2
     b / 2 - 3 = 1
     c / 4 - 1 = 3
     result = "YES"

     abbcbbb / aabcccc

     a / 1 - 2 = 1
     b / 2 - 1 = 1
     c / 5 - 1 = 4
     result = "NO"

     풀이 : 문제 설명에 있던대로 각 글자별로 count를 먼저 세어야 하기에 다음과 같은 순서로 진행
       1. 어떤 글자가 있는지 알기 위해 string을 한자씩 쪼갠다.
       2. 중복제거
           2.1 두 배열을 합쳐 Set으로 제거하는 방법
           2.2 dictionary나 array을 이용해서 동일한 글자가 있는지 보면 제거하는 방법
       3. 중복제거 완료 후 string에 각 글자가 몇개씩 있나 count 한다.
       4. 각 글자별 count의 차이가 3이 넘어가면 no를 뱉고 아니면 yes를 밷는다.
*/

    func run() {
        let aString = ["abbcccc", "abbcbbb"]
        let bString = ["aaabbbc", "aabcccc"]

        print(compare2(a: aString, b: bString))

    }

/**
     코데 제출용 답
     결과 : testcode 전부 통과
*/
    func compare1(a: [String], b: [String]) -> [String] {

        let merge = zip(a, b).map { ($0, $1) }

        return merge.map { (a1, b1) -> String in

            let splitA = a1.map { String($0) }
            let splitB = b1.map { String($0) }

            let chars: [String] = Array(Set(splitA + splitB))

            let diff = chars.map { char -> Int in
                let aCharCount = splitA.filter { $0 == char }.count
                let bCharCount = splitB.filter { $0 == char }.count

                return abs(aCharCount - bCharCount)
            }

            return diff.max() ?? 0 > 3 ? "NO" : "YES"

        }

    }

    /**
        개선할 수 있는 부분들을 찾아보자.
        1. 굳이 zip을 하고 map으로 a[i], b[i]끼리 묶을 필요가 없을듯.
        2. 글자별 차이가 3개를 초과하면 바로 "NO"를 뱉어 덜 돌수 있도록 하자.
    */
    func compare2(a: [String], b: [String]) -> [String] {
        var result: [String] = []

        for index in 0...a.count - 1 {
            let lettersA = a[index].map { String($0) }
            let lettersB = b[index].map { String($0) }

            result.append(equal(lettersA: lettersA, lettersB: lettersB))
        }

        return result
    }

    func equal(lettersA: [String], lettersB: [String]) -> String {
        let letters: [String] = Array(Set(lettersA + lettersB))

        for letter in letters {
           let aCount = lettersA.filter { $0 == letter }.count
           let bCount = lettersB.filter { $0 == letter }.count

           guard abs(aCount - bCount) < 4 else {
               return "NO"
           }
       }
        return "YES"
    }
}
