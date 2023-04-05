//
//  GameStorage.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 05/04/23.
//

import UIKit
import CoreData

class GameStorage {
    
    static var shared: GameStorage = GameStorage()
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getItems(completion: @escaping ([GameEntity]?, GameStorageError?) -> ()) {
        let fetchRequest = NSFetchRequest<GameEntity>(entityName: "GameEntity")
        do {
            let items = try context.fetch(fetchRequest)
            completion(items, nil)
        } catch {
            completion(nil, GameStorageError.cannotFetch)
        }
    }
    
    func addFavoriteItem(game: GameModel, completion: @escaping (String?, GameStorageError?) -> ()) {
        let addGames = GameEntity(context: context)
        addGames.id = Int64(game.id)
        addGames.backgroundImage = game.backgroundImage
        addGames.name = game.name
        if let publisher = game.publishers[safe: 0] {
            addGames.publisherName =  publisher.name
        }
        addGames.rating = game.rating
        addGames.released = game.released
        addGames.playtime = Int64(game.playtime)
        addGames.descriptionRaw = game.descriptionRaw
        do {
            try context.save()
            completion("success", nil)
        }
        catch {
            completion(nil, GameStorageError.cannotSave)
        }
    }
    
    func deleteFavoriteItem(gamesId: Int, completion: @escaping (String?, GameStorageError?) -> ()) {
        let fetchRequest = NSFetchRequest<GameEntity>(entityName: "GameEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %d", gamesId)

        do {
            let fetchedResults = try context.fetch(fetchRequest)
            if let result = fetchedResults.first {
                context.delete(result)
                try context.save()
                completion("success", nil)
            } else {
                completion(nil, GameStorageError.cannotRemove)
            }
        } catch {
            completion(nil, GameStorageError.cannotRemove)
        }
    }
}
