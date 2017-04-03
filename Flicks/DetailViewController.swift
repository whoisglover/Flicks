//
//  DetailViewController.swift
//  Flicks
//
//  Created by Danny Glover on 4/2/17.
//  Copyright © 2017 Danny Glover. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var detailView: UIView!
    
    var movie: NSDictionary?
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: detailView.frame.origin.y + detailView.frame.size.height)
        if let movie = movie {
            let title = movie["title"] as? String
            let overview = movie["overview"] as? String
            
    
            
            titleLabel.text = title
            overviewLabel.text = overview
            overviewLabel.sizeToFit()
            
            if let posterPath = movie["poster_path"] as? String {
                let imageUrl = URL(string: baseUrl + posterPath)
                posterImageView.setImageWith(imageUrl!)
            }
            
            
        }
        print(movie)

        // Do any additional setup after loading the view.
    }


}
