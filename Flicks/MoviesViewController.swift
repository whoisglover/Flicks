//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Danny Glover on 3/28/17.
//  Copyright © 2017 Danny Glover. All rights reserved.
//

import UIKit
import AFNetworking
import PKHUD

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var moviesTableView: UITableView!
    
    var movies: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    var endpoint: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        
        
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchMovies), for: .valueChanged)
        moviesTableView.insertSubview(refreshControl, at: 0)
        
        fetchMovies()
        
        
        
    }
    
    
    func fetchMovies() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        print("here 2")
        let apiKey = "075435556d400d67b7e5482b24658ff8"
        let url = URL(string: "http://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("error from api response: \(error)")
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                self.movies = (dataDictionary["results"] as! [NSDictionary])
                self.moviesTableView.reloadData()
                self.refreshControl.endRefreshing()
                PKHUD.sharedHUD.hide()
            }
        }
        task.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableVriew: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies?[indexPath.row]
        let title = movie?["title"] as! String
        let overview = movie?["overview"] as! String
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie?["poster_path"] as? String {
            let imageUrl = URL(string: baseUrl + posterPath)
            cell.posterView.setImageWith(imageUrl!)
        }
        
        
        
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
//        cell.overviewLabel.sizeToFit()
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = moviesTableView.indexPath(for: cell)
        let movie = movies![indexPath!.row]
        
        let vc = segue.destination as! DetailViewController
        
        vc.movie = movie
        
        
        print("preparing for seguway" )
    }
    
}
