//
//  ViewController.swift
//  IOS_MVVM
//
//  Created by Nadeen on 20/09/2022.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {
   
    var personViewModel = PersonViewModel()
    let tableView:UITableView = {
        let tableView =  UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        personViewModel.person.bind{ [weak self] _ in
            DispatchQueue.main.async { // thread for data in table view
                self?.tableView.reloadData()
            }
        }
        fetchData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return personViewModel.person.value?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = personViewModel.person.value?[indexPath.row].personName
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func fetchData(){
        // setup url from Api
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {return}
        let personApi = URLSession.shared.dataTask(with: url){(data,_,_) in
            guard let data = data else {return}
            do{
                let jsonModel = try JSONDecoder().decode([ModelTest].self, from: data)
                self.personViewModel.person.value = jsonModel.compactMap({
                    PersonTableViewCellViewModel(personName: $0.name)
                })
            }
            catch{
                
            }
            
        }
        personApi.resume()
    }

}

