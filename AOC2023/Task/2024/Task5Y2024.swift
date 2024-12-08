final class Task5Y2024: TaskProvider {
    private let data: [String]

    private struct Rule {
        let before: Int
        let after: Int
    }

    private let rules: [Rule]
    private let updates: [[Int]]

    init(data: [String]) {
        self.data = data

        rules = data
            .filter { $0.contains("|") }
            .map {
                let rule = $0.split(separator: "|")
                return Rule(before: Int(rule[0])!, after: Int(rule[1])!)
            }

        updates = data
            .filter { !$0.contains("|") && !$0.isEmpty }
            .map {
                $0.split(separator: ",").map { Int(String($0))! }
            }
    }

    func solveA() -> Int {
        updates
            .filter { validatePages($0) }
            .reduce(0) {
                $0 + (getMiddleNumber(from: $1) ?? 0)
            }
    }

    func solveB() -> Int {
        updates
            .filter { !validatePages($0) }
            .reduce(0) {
                let orderedPages = orderPages($1)
                return $0 + (getMiddleNumber(from: orderedPages) ?? 0)
            }
    }
}

private extension Task5Y2024 {

    private func applyingRules(for number: Int) -> [Rule] {
        rules.filter {
            $0.before == number || $0.after == number
        }
    }

    private func validatePages(_ pages: [Int]) -> Bool {
        for (pageIndex, page) in pages.enumerated() {
            
            let applyingRules = applyingRules(for: page)
            
            for rule in applyingRules {
                if rule.before == page {
                    if let ruleIndex = pages.firstIndex(of: rule.after) {
                        if ruleIndex <= pageIndex {
                            return false
                        }
                    }
                } else {
                    if let ruleIndex = pages.firstIndex(of: rule.before) {
                        if ruleIndex >= pageIndex {
                            return false
                        }
                    }
                }
            }
        }

        return true
    }
    
    private func orderPages(_ pages: [Int]) -> [Int] {
        var resultPages: [Int] = []

        for page in pages {

            let rules = applyingRules(for: page).filter {
                resultPages.contains($0.after) || resultPages.contains($0.before)
            }

            var index: Int?
            for rule in rules {
                if rule.before == page {
                    if let ruleIndex = resultPages.firstIndex(of: rule.after) {
                        index = min(index ?? ruleIndex, ruleIndex)
                    }
                } else {
                    if let ruleIndex = resultPages.firstIndex(of: rule.before) {
                        index = max(index ?? (ruleIndex + 1), (ruleIndex + 1))
                    }
                }
            }

            resultPages.insert(page, at: index ?? 0)
        }

        return resultPages
    }

    private func getMiddleNumber(from pages: [Int]) -> Int? {
        pages[safe: (pages.count - 1) / 2]
    }
}
