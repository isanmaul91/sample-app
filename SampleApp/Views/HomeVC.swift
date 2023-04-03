//
//  ViewController.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 03/04/23.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupNavBar()
        setupTableView()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Games For You"
        let button: UIBarButtonItem = .init(barButtonSystemItem: .search, target: nil, action: nil)
        button.tintColor = UIColor(red: 0.29, green: 0.33, blue: 0.55, alpha: 1.00)
        navigationItem.rightBarButtonItem = button
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "GameItemTVC", bundle: nil), forCellReuseIdentifier: "GameItemTVC")
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameItemTVC", for: indexPath) as! GameItemTVC
        return cell
    }
}
