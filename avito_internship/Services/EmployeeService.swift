//
//  EmployeeService.swift
//  avito_internship
//
//  Created by Ангелина Плужникова on 21.10.2022.
//

import Foundation

enum Errors: String, Error {
    case urlError = "URL error"
    case dataTaskError = "Data task error"
    case dataError = "Data is empty"
}

protocol ServiceProtocol: AnyObject {
    func loadData(complition: @escaping (Result<ResultModel, Error>) -> Void)
}

class EmployeeService: ServiceProtocol {
    let persistencyService = DefaultPersistencyService()
    
    func loadData(complition: @escaping (Result<ResultModel, Error>) -> Void) {
        if (persistencyService.compareDateFromStore(key: "Date")){
            let urlString = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
            guard let url = URL(string: urlString) else {
                complition(.failure(Errors.urlError))
                return
            }

            let urlRequest = URLRequest(url: url)

            let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                if error != nil {
                    complition(.failure(Errors.dataTaskError))
                    return
                }

                guard let data = data else {
                    complition(.failure(Errors.dataError))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let responce = try decoder.decode(ResultModel.self, from: data)
                    self.persistencyService.save(data, key: "ResponseData")
                    self.persistencyService.saveDate(Date(), key: "Date")
                    complition(.success(responce))
                } catch let error {
                    complition(.failure(error))
                }
            }
            task.resume()
        } else {
            do {
            guard let data = self.persistencyService.get(key: "ResponseData") else { return }
            let decoder = JSONDecoder()
            let responce = try decoder.decode(ResultModel.self, from: data)
            self.persistencyService.save(data, key: "ResponseData")
            complition(.success(responce))
            }
            catch {
                complition(.failure(error))
            }
        }
    }
}
