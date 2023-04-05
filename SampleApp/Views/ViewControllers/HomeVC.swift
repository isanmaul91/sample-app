//
//  ViewController.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 03/04/23.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let viewModel: HomeViewModelProtocol = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViewModel()
    }
    
    private func setup() {
        setupNavBar()
        setupTableView()
    }
    
    private func setupNavBar() {
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.title = "Games For You"
        let button: UIBarButtonItem = .init(barButtonSystemItem: .search,
                                            target: self,
                                            action: #selector(searchButtonClicked))
        button.tintColor = UIColor(red: 0.29, green: 0.33, blue: 0.55, alpha: 1.00)
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func searchButtonClicked() {
        goToSearchScreen()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "GameItemTVC", bundle: nil), forCellReuseIdentifier: "GameItemTVC")
    }
    
    private func setupViewModel() {
        viewModel.fetchGamesList()
        viewModel.gamesList.addObserver(self) { [weak self] _ in
            self?.reloadScreen()
        }
    }
    
    func reloadScreen() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func goToDetailScreen(_ gameId: Int) {
        let storyboard: UIStoryboard = .init(name: "Detail", bundle: nil)
        let vc: DetailVC = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailVC
        vc.set(gameId)
        self.present(vc, animated: true, completion: nil)
    }
    
    private func goToSearchScreen() {
        let storyboard: UIStoryboard = .init(name: "Search", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Search")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getGamesList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let game = viewModel.getGamesList()[safe: indexPath.row] else {
           return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameItemTVC", for: indexPath) as! GameItemTVC
        cell.setupUI(game: game)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.getGamesList().count - 1 {
            viewModel.loadMore()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let game = viewModel.getGamesList()[safe: indexPath.row] else { return }
        goToDetailScreen(game.id)
    }
}
