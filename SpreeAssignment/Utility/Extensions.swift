//
//  Extensions.swift
//  SpreeAssignment
//
//  Created by Astrotalk on 03/01/24.
//

import UIKit

//MARK: - URLSession

extension URLSession {
    
    func dataTask(with request: URLRequest, resultHandler: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask {
        
        return self.dataTask(with: request) { data, response, error in
            
            if let networkError = NetworkError(data: data, response: response, error: error) {
                resultHandler(.failure(networkError))
                return
            }
            
            resultHandler(.success(data!))
        }
    }
}

//MARK: - UIImageView

extension UIImageView {
    func setAndSaveImage(imageUrlString: String?, imageName: String){
        if let data: Data = PersistencyManager.shared.getFromCache(filename: imageName.removeWhiteSpaces()), let image = UIImage(data: data) {
            self.image = image
            return
        }
        
        guard let imageUrlString = imageUrlString else {
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async {[weak self] in
            guard let aUrl = URL(string: imageUrlString) else {return}
            if let data = try? Data(contentsOf: aUrl), let image = UIImage(data: data) {
                PersistencyManager.shared.saveInCache(image.pngData(), filename: imageName.removeWhiteSpaces())
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}

//MARK: - String

extension String {
    func removeWhiteSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}
