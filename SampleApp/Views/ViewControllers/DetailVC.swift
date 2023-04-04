//
//  DetailVC.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 03/04/23.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var favoriteButton: UIImageView!
    @IBOutlet weak var closeButton: UIImageView!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var playtime: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    private let viewModel: DetailViewModelProtocol = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        viewModel.getGameDetail()
    }
    
    func set(_ gameId: Int) {
        self.viewModel.set(gameId)
    }
    
    private func setupViewModel() {
        
    }
}
