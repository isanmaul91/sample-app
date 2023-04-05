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
    var onDismiss: VoidClosure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
        viewModel.getGameDetail()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed || isMovingFromParent {
            onDismiss?()
        }
    }
    
    func set(_ gameId: Int) {
        self.viewModel.set(gameId)
    }
    
    private func setupViewModel() {
        viewModel.requestState
        .addObserver(self) { [weak self] state in
            if state == .success || state == .error {
                DispatchQueue.main.async { [weak self] in
                    self?.render()
                }
            }
        }
        viewModel.favoriteState
        .addObserver(self) { [weak self] state in
            if state == .success {
                DispatchQueue.main.async { [weak self] in
                    self?.setLoveImage()
                }
            }
        }
    }
    
    private func setupView() {
        let tapCloseGesture = UITapGestureRecognizer(target: self, action: #selector(onCloseButtonClicked))
        closeButton.isUserInteractionEnabled = true
        closeButton.addGestureRecognizer(tapCloseGesture)
        let tapFavoriteGesture = UITapGestureRecognizer(target: self, action: #selector(onFavoriteButtonClicked))
        favoriteButton.isUserInteractionEnabled = true
        favoriteButton.addGestureRecognizer(tapFavoriteGesture)
    }
    
    @objc func onCloseButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onFavoriteButtonClicked() {
        viewModel.onTapLove()
    }
    
    private func render() {
        name.text = viewModel.name
        publisher.text = viewModel.publisherName
        releaseDate.text = "Release date \(viewModel.released)"
        rating.text = "\(viewModel.rating)"
        playtime.text = "\(viewModel.playtime) played"
        descriptionLabel.text = viewModel.descriptionRaw
        gameImage.loadUrl(from: viewModel.backgroundImage, contentMode: .scaleAspectFill)
        setLoveImage()
    }
    
    private func setLoveImage() {
        if viewModel.isFavorite {
            favoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            favoriteButton.image = UIImage(systemName: "heart")
        }
    }
}
