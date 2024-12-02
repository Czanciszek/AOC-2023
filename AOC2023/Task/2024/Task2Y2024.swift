final class Task2Y2024: TaskProvider {
    private let data: [String]

    init(data: [String]) {
        self.data = data
    }

    func solveA() -> Int {
        data.reduce(0) {
            $0 + processLineA(line: $1)
        }
    }

    func solveB() -> Int {
        data.reduce(0) {
            $0 + processLineB(line: $1)
        }
    }
}

private extension Task2Y2024 {
    func processLineA(line: String) -> Int {
        let numbers = line.split(separator: " ").compactMap { Int($0) }

        var lastNumber: Int?
        var increasing: Bool?

        for number in numbers {
            defer { lastNumber = number }
            guard let lastNumber else { continue }

            if increasing == nil {
                increasing = number > lastNumber
            }

            let validate = validateNumber(number, lastNumber: lastNumber, increasing: increasing)

            guard validate else { return 0 }
        }

        return 1
    }

    func processLineB(line: String) -> Int {
        let numbers = line.split(separator: " ").compactMap { Int($0) }

        var lastNumber: Int?
        var increasing: Bool?
        var hasError = false

        for number in numbers {
            defer { lastNumber = number }
            guard let lastNumber else { continue }

            if increasing == nil {
                increasing = number > lastNumber
            }

            let validate = validateNumber(number, lastNumber: lastNumber, increasing: increasing)

            if validate {
                continue
            } else if !hasError {
                hasError = true
                continue
            } else {
                return 0
            }
        }

        return 1
    }

    private func validateNumber(_ number: Int, lastNumber: Int, increasing: Bool?) -> Bool {

        guard abs(number - lastNumber) <= 3 else {
            return false
        }

        if increasing ?? (number > lastNumber) {
            guard number > lastNumber else { return false }
        } else {
            guard number < lastNumber else { return false }
        }

        return true
    }
}
