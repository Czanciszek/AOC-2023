//
//  Task5.swift
//  AOC2023
//
//  Created by Franciszek Czana on 14/12/2023.
//

import Foundation

final class Task5: TaskProvider {
    private let data: [String]

    init(data: [String]) {
        self.data = data
    }

    func solveA() -> Int {
        let seeds = data[0]
            .split(separator: " ")
            .compactMap { Int($0) }

        guard let seedMap = makeSeedMap() else {
            return -1
        }

        return seeds
            .map { mapSeedToLocation(seedMap: seedMap, seed: $0) }
            .min() ?? -1
    }

    func solveB() -> Int {
        #warning("Task B works, but takes a lot of time")
        return -1

//        let seeds = data[0]
//            .split(separator: " ")
//            .compactMap { Int($0) }
//            .enumerated()
//            .filter { $0.offset % 2 == 0 }
//            .map {
//                let range = Int(data[$0.offset + 1]) ?? 0
//                return Seed(min: $0.element, max: $0.element + range - 1)
//            }
//
//        guard let seedMap = makeSeedMap() else {
//            return -1
//        }
//
//        for locations in seedMap.humidityToLocation.sorted(by: { $0[0] < $1[0] }).suffix(from: 2) {
//            for location in locations[0] ..< (locations[0] + locations[2]) {
//                let humidity = findBackInMap(map: seedMap.humidityToLocation, value: location)
//                let temperature = findBackInMap(map: seedMap.temperatureToHumidity, value: humidity)
//                let light = findBackInMap(map: seedMap.lightToTemperature, value: temperature)
//                let water = findBackInMap(map: seedMap.waterToLight, value: light)
//                let fertilizer = findBackInMap(map: seedMap.fertilizerToWater, value: water)
//                let soil = findBackInMap(map: seedMap.soilToFertilizer, value: fertilizer)
//                let seed = findBackInMap(map: seedMap.seedToSoil, value: soil)
//
//                if seeds.contains(where: { seed >= $0.min && seed <= $0.max }) {
//                    return location
//                }
//            }
//        }
//        return -1
    }
}

private extension Task5 {
    func makeSeedMap() -> SeedMap? {
        let seedToSoilIndex = data.firstIndex { $0.contains("seed-to-soil") }
        let soilToFertilizerIndex = data.firstIndex { $0.contains("soil-to-fertilizer") }
        let fertilizerToWaterIndex = data.firstIndex { $0.contains("fertilizer-to-water") }
        let waterToLightIndex = data.firstIndex { $0.contains("water-to-light") }
        let lightToTemperatureIndex = data.firstIndex { $0.contains("light-to-temperature") }
        let temperatureToHumidityIndex = data.firstIndex { $0.contains("temperature-to-humidity") }
        let humidityToLocationIndex = data.firstIndex { $0.contains("humidity-to-location") }

        guard let seedToSoilIndex, let soilToFertilizerIndex, let fertilizerToWaterIndex, let waterToLightIndex,
              let lightToTemperatureIndex, let temperatureToHumidityIndex, let humidityToLocationIndex
        else {
            return nil
        }

        return SeedMap(
            seedToSoil: obtainMap(from: seedToSoilIndex + 1, to: soilToFertilizerIndex - 1),
            soilToFertilizer: obtainMap(from: soilToFertilizerIndex + 1, to: fertilizerToWaterIndex - 1),
            fertilizerToWater: obtainMap(from: fertilizerToWaterIndex + 1, to: waterToLightIndex - 1),
            waterToLight: obtainMap(from: waterToLightIndex + 1, to: lightToTemperatureIndex - 1),
            lightToTemperature: obtainMap(from: lightToTemperatureIndex + 1, to: temperatureToHumidityIndex - 1),
            temperatureToHumidity: obtainMap(from: temperatureToHumidityIndex + 1, to: humidityToLocationIndex - 1),
            humidityToLocation: obtainMap(from: humidityToLocationIndex + 1, to: data.count - 1)
        )
    }

    func mapSeedToLocation(seedMap: SeedMap, seed: Int) -> Int {
        let soil = findInMap(map: seedMap.seedToSoil, value: seed)
        let fertilizer = findInMap(map: seedMap.soilToFertilizer, value: soil)
        let water = findInMap(map: seedMap.fertilizerToWater, value: fertilizer)
        let light = findInMap(map: seedMap.waterToLight, value: water)
        let temperature = findInMap(map: seedMap.lightToTemperature, value: light)
        let humidity = findInMap(map: seedMap.temperatureToHumidity, value: temperature)
        let location = findInMap(map: seedMap.humidityToLocation, value: humidity)
        return location
    }

    func findBackInMap(map: [[Int]], value: Int) -> Int {
        if let mappedValue = map.first(where: { value >= $0[0] && value < ($0[0] + $0[2]) }) {
            let difference = abs(mappedValue[0] - value)
            return mappedValue[1] + difference
        } else {
            return value
        }
    }

    func obtainMap(from: Int, to: Int) -> [[Int]] {
        data[from ... to]
            .map { mapItem in
                mapItem
                    .split(separator: " ")
                    .compactMap { Int($0) }
            }
    }

    func findInMap(map: [[Int]], value: Int) -> Int {
        let locationMap = map.first(where: { value >= $0[1] && value <= ($0[1] + $0[2]) - 1 })
        guard let locationMap else { return value }
        return locationMap[0] + (value - locationMap[1])
    }

    struct SeedMap {
        let seedToSoil: [[Int]]
        let soilToFertilizer: [[Int]]
        let fertilizerToWater: [[Int]]
        let waterToLight: [[Int]]
        let lightToTemperature: [[Int]]
        let temperatureToHumidity: [[Int]]
        let humidityToLocation: [[Int]]
    }

    struct Seed {
        var min: Int
        var max: Int
    }
}
