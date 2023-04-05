//
//  SearchVC.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 03/04/23.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private lazy var searchBar: UISearchBar = .init()
    private lazy var viewModel: SearchViewModelProtocol = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        setupViewModel()
    }
    
    private func setup() {
        setupSearchBar()
        setupTableView()
    }
    
    private func setupViewModel() {
        viewModel.gamesList.addObserver(self) { [weak self] _ in
            self?.reloadScreen()
        }
    }
    
    func reloadScreen() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setupSearchBar() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        doneToolbar.setItems([flexSpace, done], animated: false)
        searchBar.inputAccessoryView = doneToolbar
        searchBar.delegate = self
        searchBar.placeholder = "Search games"
        navigationItem.titleView = searchBar
        navigationItem.backButtonDisplayMode = .minimal
        searchBar.becomeFirstResponder()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "GameItemTVC", bundle: nil), forCellReuseIdentifier: "GameItemTVC")
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
            perform(#selector(updateSearch(with:)), with: searchText, afterDelay: 0.5)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let query = searchBar.text {
            updateSearch(with: query)
        }
    }
    
    @objc private func doneButtonAction() {
        searchBar.resignFirstResponder()
    }
    
    @objc private func updateSearch(with query: String) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3 else { return }
        viewModel.search(query)
    }
    
    private func goToDetailScreen(_ gameId: Int) {
        let storyboard: UIStoryboard = .init(name: "Detail", bundle: nil)
        let vc: DetailVC = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailVC
        vc.set(gameId)
        self.present(vc, animated: true, completion: nil)
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
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
