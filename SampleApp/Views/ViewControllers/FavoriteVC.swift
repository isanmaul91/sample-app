//
//  FavoriteVC.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 03/04/23.
//

import UIKit

class FavoriteVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let viewModel: FavoriteViewModelProtocol = FavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.fetchGamesList()
    }
    
    private func setup() {
        setupNavBar()
        setupTableView()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Favorite"
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "GameItemTVC", bundle: nil), forCellReuseIdentifier: "GameItemTVC")
    }
    
    private func setupViewModel() {
        viewModel.gamesList.addObserver(self) { [weak self] _ in
            self?.reloadScreen()
        }
    }
    
    private func reloadScreen() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func goToDetailScreen(_ gameId: Int) {
        let storyboard: UIStoryboard = .init(name: "Detail", bundle: nil)
        let vc: DetailVC = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailVC
        vc.set(gameId)
        vc.onDismiss = { [weak self] in
            self?.viewModel.fetchGamesList()
        }
        self.present(vc, animated: true, completion: nil)
    }
}

extension FavoriteVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getGamesList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let game = viewModel.getGamesList()[safe: indexPath.row] else {
           return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameItemTVC", for: indexPath) as! GameItemTVC
        cell.setupUI(entity: game)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let game = viewModel.getGamesList()[safe: indexPath.row] else { return }
        goToDetailScreen(Int(game.id))
    }
}
