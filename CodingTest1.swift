import Foundation

class CodingTest1 {

/**
     문제1 : n개의 발전기를 사용중이였고, 사용량이 줄게 되어 특정 개수(models.count / 2)의 발전기만 운행하게 되었다. 개수를 맞춰 운행을 멈추려면 최소한 몇개의 model을 멈추면 될까?
     models = (1, 4, 3, 4, 2, 1, 4)
     ceiling = 7(models.count) / 2 = 3.5 = 4

     풀이 :
     1. 몇개의 발전기를 멈출지 ceiling 값을 구하자.
        Int(ceil(Float(models.count)/2))
     2. 근사값을 통해 ceiling에 가까운 model의 count를 찾아보자.
        ceiling(4) = 4(3개) + 2(1개)
     */


    func run() {
        let models = [1, 4, 3, 4, 2, 1, 4]
        let ceiling = Int(ceil(Float(models.count)/2))

        print(reduce2(models: models, ceiling: ceiling))
    }

/**
     코테 제출용 답
     결과 : 절반의 테스트 코드 통과/ 나머지의 절반은 타임아웃, 절반 실패
     원인 :
        1. 실패
            - 실패의 원인을 찾아보니 근사값을 찾는 near 함수에서 min 변수의 초기 값이 100으로 세팅 되어 있어 근사값이 100안으로 떨어져야 정상적이며,
              이로 인해, TestCode에서 큰 범위의 데이터를 처리 하지 못함.
            - modelCountArray를 구할 때  model: count로 담지 않고, count만 담고 처리 할떄 index를 통해 하다 보니 순서가 바뀌는 경우 정확한
              답이 나오지 않게됨
        2. 타임아웃
            - 확인해야하는 models의 범위가 작은 경우 문제가 없지만, 범위가 넒어 지게 되면 model별 count를 세는 부분에서 오래 걸릴 것 같음.
              set을 통해 중복 제거하는 비용과, map을 통해 model별로 돌면서 filter로 models에 있는 전체 값을 비교하면 count를 찾아야 하므로.
              총 비용 : set + (map * model count) + (model count * models count)

*/
    func reduce1(models: [Int], ceiling : Int) -> Int {

        //1. Set을 통해 models를 중복제거 하여, model의 종류를 파악
        //2. map을 이용하여, model의 count array를 만든다.
        //3. count는 filter을 통해서 구한다.
        var modelCountArray = Set(models).map { n -> Int in
            return models.filter { n == $0 }.count
        }

        var sum = 0
        var copyCeiling = ceiling

        //ceiling의 근사값을 찾아가며 총 몇개의 model을 정지해야하는지 기록하자.
        repeat {
            let index = near1(array: modelCountArray, point: copyCeiling)

            copyCeiling -= modelCountArray[index]
            sum += 1
            modelCountArray.remove(at: index)
        } while copyCeiling > 0

        return sum
    }

    func near1(array: [Int], point: Int) -> Int {
        var temp = 0
        var min = 100
        var key = 0

        //point와 array[i]의 값의 차이로 가장 가까운 값을 찾는다.
        for (index, value) in array.enumerated() {
            temp = value - point

            if abs(min) > abs(temp) {
                min = temp
                key = index
            }
        }

        return key
    }


/**
     문제점을 파악 후 수정한 코드
     원인 :
        1. 실패
            - 실패의 원인을 찾아보니 근사값을 찾는 near 함수에서 min 변수의 초기 값이 100으로 세팅 되어 있어 근사값이 100안으로 떨어져야 정상적이며,
              이로 인해, TestCode에서 큰 범위의 데이터를 처리 하지 못함.
            @ min의 초기 값을 Int.max로 세팅하여 큰 범위의 데이터를 처리할 수 있도록 하자.

            - modelCountArray를 구할 때  model: count로 담지 않고, count만 담고 처리 할떄 index를 통해 하다 보니 순서가 바뀌는 경우 정확한
              답이 나오지 않게됨
            @ modelCountArray를 [model: count] 딕셔너리로 문제점을 해결하자.
        2. 타임아웃
            - 확인해야하는 models의 범위가 작은 경우 문제가 없지만, 범위가 넒어 지게 되면 model별 count를 세는 부분에서 오래 걸릴 것 같음.
              set을 통해 중복 제거하는 비용과, map을 통해 model별로 돌면서 filter로 models에 있는 전체 값을 비교하면 count를 찾아야 하므로.
              총 비용 : set + (map * model count) + (model count * models count)
            @ models를 한번만 돌고 model의 종류와 count를 파악하자

            - 추가로 반복되는 작업을 최소화 하자.
            @ near func에서 찾으려는 근사값이 딱 떨어지는 경우 for문을 더이상 안타도록 하자.

*/

    func reduce2(models: [Int], ceiling : Int) -> Int {

        var modelCountArray: [Int: Int] = [:]

        //models를 한번만 돌고 딕셔너리에 model과 count가 정리 되도록 하자.
        for model in models {
            if let count = modelCountArray[model] {
                modelCountArray[model] = count + 1
            } else {
                modelCountArray[model] = 1
            }
        }

        print(modelCountArray)
        var sum = 0
        var copyCelilng = ceiling

        repeat {
            let model = near2(array: modelCountArray, point: copyCelilng)

            copyCelilng -= modelCountArray[model] ?? 0
            sum += 1
            modelCountArray.removeValue(forKey: model)
        } while copyCelilng > 0

        return sum
    }

    func near2(array: [Int: Int], point: Int) -> Int {
        var temp = 0
        var min = Int.max
        var key = 0

        for (model, count) in array {
            temp = count - point

            //0 이 나오는 경우 딱 맞는 값이 찾아진걸로 판단하고 for문을 멈추고 해당 model을 넘기자
            guard temp != 0 else {
                return model
            }

            if abs(min) > abs(temp) {
                min = temp
                key = model
            }
        }
        return key
    }
}
