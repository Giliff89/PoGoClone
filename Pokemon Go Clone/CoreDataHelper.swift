//
//  CoreDataHelper.swift
//  Pokemon Go Clone
//
//  Created by gina iliff on 9/15/17.
//  Copyright © 2017 gina iliff. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon() {
    
    createPokemon(name: "Pikachu", imageName: "pikachu-2")
    createPokemon(name: "Abra", imageName: "abra")
    createPokemon(name: "Bellsprout", imageName: "bellsprout")
    createPokemon(name: "Bulbasaur", imageName: "bullbasaur")
    createPokemon(name: "Caterpie", imageName: "caterpie")
    createPokemon(name: "Charmander", imageName: "charmander")
    createPokemon(name: "Dratini", imageName: "dratini")
    createPokemon(name: "Eevee", imageName: "eevee")
    createPokemon(name: "Jigglypuff", imageName: "jigglypuff")
    createPokemon(name: "Mankey", imageName: "mankey")
    createPokemon(name: "Meowth", imageName: "meowth")
    createPokemon(name: "Mew", imageName: "mew")
    createPokemon(name: "Pidgey", imageName: "pidgey")
    createPokemon(name: "Psyduck", imageName: "psyduck")
    createPokemon(name: "Rattata", imageName: "rattata")
    createPokemon(name: "Snorlax", imageName: "snorlax")
    createPokemon(name: "Squirtle", imageName: "squirtle")
    createPokemon(name: "Venonat", imageName: "venonat")
    createPokemon(name: "Weedle", imageName: "weedle")
    createPokemon(name: "Zubat", imageName: "zubat")
    
}

func createPokemon(name: String, imageName: String) {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        
        let pokemon = Pokemon(entity: Pokemon.entity(), insertInto: context)
        pokemon.name = name
        pokemon.imageName = imageName
        
        try? context.save()
    }
}

func getAllPokemon() -> [Pokemon] {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        if let pokeData = try? context.fetch(Pokemon.fetchRequest()) as? [Pokemon] {
            if let pokemons = pokeData {
                if pokemons.count == 0 {
                    addAllPokemon()
                    return getAllPokemon()
                }
                return pokemons
            }
        }
    }
    return []
}

func getCaughtPokemon() -> [Pokemon] {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest <Pokemon>
        fetchRequest.predicate = NSPredicate(format: "caught == %@", true as CVarArg)
        if let pokemons = try? context.fetch(fetchRequest) {
            return pokemons
        }
    }
    return []
}

func getUncaughtPokemon() -> [Pokemon] {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest <Pokemon>
        fetchRequest.predicate = NSPredicate(format: "caught == %@", false as CVarArg)
        if let pokemons = try? context.fetch(fetchRequest) {
            return pokemons
        }
    }
    return []
}
