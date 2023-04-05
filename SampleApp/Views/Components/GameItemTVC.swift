//
//  GameItemTVC.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 03/04/23.
//

import UIKit

class GameItemTVC: UITableViewCell {
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        gameImage.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gameImage.image = nil
    }
    
    func setupUI(game: GameModel) {
        name.text = game.name
        releaseDate.text = "Release date \(game.released)"
        rating.text = "\(game.rating)"
        gameImage.loadUrl(from: game.backgroundImage, contentMode: .scaleAspectFill)
    }
    
    func setupUI(entity: GameEntity) {
        name.text = entity.name
        releaseDate.text = "Release date \(entity.released ?? "")"
        rating.text = "\(entity.rating)"
        if let imageUrl = entity.backgroundImage {
            gameImage.loadUrl(from: imageUrl, contentMode: .scaleAspectFill)
        }
        
    }
}
