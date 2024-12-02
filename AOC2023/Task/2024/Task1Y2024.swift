final class Task1Y2024: TaskProvider {
    private let data: [String]

    init(data: [String]) {
        self.data = data
    }

    func solveA() -> Int {
        let modelData = prepareData()
        return taskA(modelData: modelData)
    }

    func solveB() -> Int {
        let modelData = prepareData()
        return taskB(modelData: modelData)
    }
}

private extension Task1Y2024 {

    private struct ModelData {
        let leftList: [Int]
        let rightList: [Int]
    }

    private func prepareData() -> ModelData {
        var leftList = [Int]()
        var rightList = [Int]()

        data.forEach {
            let numbers = $0.split(separator: "   ").compactMap { Int($0) }
            leftList.append(numbers[0])
            rightList.append(numbers[1])
        }

        return .init(
            leftList: leftList.sorted(by: <),
            rightList: rightList.sorted(by: <))
    }

    private func taskA(modelData: ModelData) -> Int {
        modelData.leftList.enumerated().reduce(0, {
            $0 + abs(modelData.rightList[$1.offset] - $1.element)
        })
    }

    private func taskB(modelData: ModelData) -> Int {
        modelData.leftList.reduce(0, { sum, element in
            sum + modelData.rightList.filter { $0 == element }.count * element
        })
    }
}
