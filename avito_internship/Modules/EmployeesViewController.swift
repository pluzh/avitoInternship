//
//  EmployeesViewController.swift
//  avito_internship
//
//  Created by Ангелина Плужникова on 21.10.2022.
//

import UIKit

class EmployeesViewController: UIViewController {
    
    @IBOutlet weak var activitiIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: EmployeesPresenter?
    var interactor: EmployeesInteractor?
    let employeesService = EmployeeService()
    var handler: EmployeesViewInput?
    
    var employees: [Employees] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let viewController = self
        let interactor = EmployeesInteractor(networkService: employeesService)
        let presenter = EmployeesPresenter(interactor: interactor, view: viewController)
        
        viewController.presenter = presenter
        viewController.handler = presenter
        interactor.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activitiIndicator.isHidden = false
        activitiIndicator.startAnimating()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "EmployeeCell", bundle: nil), forCellReuseIdentifier: "EmployeeCell")
        
        handler?.fetchData(activitiIndicator: activitiIndicator)
    }

}

extension EmployeesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath) as! EmployeeCell
        let employee = employees[indexPath.row]
        cell.configureCell(with: employee, indexPath: indexPath)
        return cell
    }
}
