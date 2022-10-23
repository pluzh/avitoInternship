//
//  EmployeesPresenter.swift
//  avito_internship
//
//  Created by Ангелина Плужникова on 22.10.2022.
//

import UIKit

protocol EmployeesViewInput: AnyObject {
    func fetchData(activitiIndicator: UIActivityIndicatorView)
}

protocol EmployeesPresenterProtocol: AnyObject {
    var dataArray: [Employees] {get set}
    func receiveData(dataViewModel: ResultModel, activitiIndicator: UIActivityIndicatorView)
    func didReceive(error: Error, activitiIndicator: UIActivityIndicatorView)
}

class EmployeesPresenter: EmployeesPresenterProtocol {
    
    weak var view: EmployeesViewController?
    var interactor: EmployeeInteractorProtocol!
    
    var dataArray: [Employees] = []
    
    init(interactor: EmployeeInteractorProtocol, view: EmployeesViewController?) {
        self.interactor = interactor
        self.view = view
    }
    
    func receiveData(dataViewModel: ResultModel, activitiIndicator: UIActivityIndicatorView) {
        dataArray = dataViewModel.company.employees.sorted { $0.name < $1.name}
        let title = dataViewModel.company.name

        view?.employees = dataArray
        view?.tableView.reloadData()
        activitiIndicator.stopAnimating()
        activitiIndicator.isHidden = true
        view?.navigationItem.title = title
    }
    
    func didReceive(error: Error, activitiIndicator: UIActivityIndicatorView) {
        
        activitiIndicator.stopAnimating()
        activitiIndicator.isHidden = true
        let alert = UIAlertController(title: "Oшибка", message: error.localizedDescription.localizedCapitalized, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
        })
        let retry = UIAlertAction(title: "Retry", style: .default) { (action) -> Void in
            alert.dismiss(animated: true) {
                self.interactor.loadDataFromJson(activitiIndicator: activitiIndicator)
                activitiIndicator.startAnimating()
                activitiIndicator.isHidden = false
            }
        }
        alert.addAction(ok)
        alert.addAction(retry)
        view?.navigationController?.present(alert, animated: true)
    }
}

extension EmployeesPresenter: EmployeesViewInput {
    func fetchData(activitiIndicator: UIActivityIndicatorView) {
        interactor.loadDataFromJson(activitiIndicator: activitiIndicator)
    }
}
