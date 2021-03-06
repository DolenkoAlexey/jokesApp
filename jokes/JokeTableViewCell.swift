//
//  JokeTableViewCell.swift
//  jokes
//
//  Created by Alex Dolenko on 08/10/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class JokeTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var votesCountLabel: UILabel!
    @IBOutlet weak var jokeTextView: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    
    
    @IBAction func likeTapped(_ sender: UIButton) {
        viewModel.likeJoke().disposed(by: disposeBag)
    }
    
    
    var viewModel: JokeViewModelType! {
        didSet {
            usernameLabel.text = viewModel.joke.username
            votesCountLabel.text = "\(viewModel.joke.votes)"
            jokeTextView.text = viewModel.joke.text
            
            setup()
        }
    }
    
    private func setup() {
        viewModel.likesCount.drive(onNext: {[weak self] likesCount in
            self?.votesCountLabel.text = likesCount
        }).disposed(by: disposeBag)
        
        viewModel.isUserLikedJoke.drive(onNext: {[weak self] isLiked in
            self?.setupLike(isLiked: isLiked)
        }).disposed(by: disposeBag)
    }
    
    private func setupLike(isLiked: Bool) {
        likeButton.setTitle(isLiked ? "Unlike" : "Like", for: .normal)
    }
    
    private let disposeBag = DisposeBag()
}
