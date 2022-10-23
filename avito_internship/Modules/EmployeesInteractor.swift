//
//  EmployeesInteractor.swift
//  avito_internship
//
//  Created by Ангелина Плужникова on 22.10.2022.
//

import UIKit

protocol EmployeeInteractorProtocol: AnyObject {
    var employeesData: ResultModel? {get set}
    func loadDataFromJson(activitiIndicator: UIActivityIndicatorView)
}

class EmployeesInteractor: EmployeeInteractorProtocol {

    weak var presenter: EmployeesPresenterProtocol!
    
    var networkService: ServiceProtocol
    
    var employeesData: ResultModel?
    
    init(networkService: ServiceProtocol) {
        self.networkService = networkService
    }
    
    func loadDataFromJson(activitiIndicator: UIActivityIndicatorView) {
        networkService.loadData { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.employeesData = data
                    guard let data = self.employeesData else { return }
                    self.presenter.receiveData(dataViewModel: ResultModel(company: data.company), activitiIndicator: activitiIndicator)
                case .failure(let error):
                    self.presenter.didReceive(error: error, activitiIndicator: activitiIndicator)
                }
            }
        }
    }
}
