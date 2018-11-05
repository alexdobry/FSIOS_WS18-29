//
//  MatchingCardViewController.swift
//  MatchingCardGame
//
//  Created by Student on 16.10.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class MatchingCardViewController: UIViewController {
    
    // View
    @IBOutlet var cardViews: [CardView]!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // Model
    var game: MatchingCardGame!
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardViews.forEach { cardView in
            cardView.delegate = self
        }
        
        initGame()
    }
    
    // Interaction
    @IBAction func playAgain(_ sender: Any) {

        cardViews.forEach { cardView in
            cardView.matched = false
            cardView.card = nil
        }
        
        initGame()
    }
    
    // Helper
    private func initGame() {
        scoreLabel.text = "Score: 0"
        game = MatchingCardGame(numberOfCards: cardViews.count)
        game.delegate = self
    }
    
    func cardView(matching card: Card) -> CardView {
        return cardViews.first(where: { (cardView: CardView) -> Bool in
            return cardView.card == card
        })!
    }
}

extension MatchingCardViewController: CardViewDelegate {
    
    func cardView(_ cardView: CardView, tapped card: Card?) {
        let index = cardViews.firstIndex(of: cardView)!
        game.flipCard(at: index)
    }
}

extension MatchingCardViewController: MatchingCardGameDelegate {
//    func pending(index: Int, card: Card) {
//        let cView = cardViews?[index]
//        cView!.card = card
//
//    }
//
//    func match(index: Int, first: Card, second: Card) {
//        let cView = cardViews?[index]
//        cView!.card = first
//
//        let other = self.cardView(matching: second)
//        other.matched = true
//        cView!.matched = true
//    }
//
//    func noMatch(index: Int, first: Card, second: Card) {
//        let cView = cardViews?[index]
//        cView!.card = first
//
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
//            cView!.card = nil
//
//            let other = self.cardView(matching: first)
//            other.card = nil
//        }
//
//    }
    func match(_ index: Int, _ pending: Card, _ card: Card){
        cardViews?[index].card = card
        let other = self.cardView(matching: pending)
        other.matched = true
        cardViews?[index].matched = true
    }
    
    func noMatch(_ index: Int, _ pending: Card, _ card: Card){
        cardViews?[index].card = card
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.cardViews?[index].card = nil
            
            let other = self.cardView(matching: pending)
            other.card = nil
        }
    }
    
    func pending(_ index: Int, _ card: Card){
        cardViews?[index].card = card
    }
    
    func alreadySelected(index: Int, card: Card) {
        
    }
    
    func matchingCardGameScoreDidChange(to value: Int) {
        scoreLabel.text = "Score: \(value)"
    }
}
