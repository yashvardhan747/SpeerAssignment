//
//  DecodingFailableObject.swift
//  SpreeAssignment
//
//  Created by Astrotalk on 04/01/24.
//

struct DecodingFailableObject<T: Decodable>: Decodable {
    let value: Result<T, NetworkError>

    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            let data = try container.decode(T.self)
            value = .success(data)
        } catch {
            self.value = .failure(.decodingError(error))
        }
    }
}
