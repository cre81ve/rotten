//
//  MoviewsViewController.swift
//  rotten
//
//  Created by CK on 9/10/14.
//  Copyright (c) 2014 Chaitanya Kannali. All rights reserved.
//

import UIKit

class MoviewsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate ,UITextFieldDelegate {
    @IBOutlet weak var networkView: UIView!

    @IBOutlet weak var searchMovies: UITextField!

    @IBOutlet weak var tableView: UITableView!
    
//    @IBAction func onTap(sender: AnyObject) {
//        self.view.endEditing(true)
//    }
    
    var movies: [NSDictionary] = []
    var searchurlc = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=v2xqpyhtv5pdqa3ej2vuwmb2&page_limit=20&page=1&q=REPLACEME"
    var refreshControl:UIRefreshControl!
    @IBAction func onSearch(sender: AnyObject) {
    refresh()
    }
     func textFieldShouldReturn(textField: UITextField!) -> Bool {
        searchMovies .resignFirstResponder()
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchMovies.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        MBProgressHUD.showHUDAddedTo(self.view!, animated: true)

        renderHomeMovies()
        
        self.tableView.backgroundColor = UIColor.blackColor()
        self.tableView.tintColor = UIColor.whiteColor()
        self.tableView.separatorColor = UIColor.darkGrayColor()
        
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    
    }
    
    
    func refresh() {
        var searchStr = searchMovies.text
        if(searchStr  != nil && searchStr != "") {
            renderFiltered(searchStr)
            
        }else {
            renderHomeMovies()
        }
        NSLog("Called refreshing")
        
        self.refreshControl.endRefreshing()
    }
    
    
    func renderHomeMovies() {
        var url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=v2xqpyhtv5pdqa3ej2vuwmb2&limit=20&country=us"
        var request = NSURLRequest(URL: NSURL(string: url))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response: NSURLResponse!,data: NSData!,error:NSError!) -> Void in
            if((error) != nil) {
                NSLog("Error communicating");
                self.networkView.hidden = false
            } else {
                var timerloaded = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("showhideview"), userInfo: nil, repeats: false)
    
            var object =  NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            self.movies = object["movies"] as [NSDictionary]
            self.tableView.reloadData()
            self.networkView.hidden = true
                
            }
        }
    }
    
    func renderFiltered(searchStrp: String){
        var searchStr = searchStrp
        searchStr = searchStr.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var searchurl = searchurlc
        searchurl = searchurlc.stringByReplacingOccurrencesOfString("REPLACEME", withString: searchStr, options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        NSLog("Search query : \(searchurl)")
        var request = NSURLRequest(URL: NSURL(string: searchurl))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response: NSURLResponse!,data: NSData!,error:NSError!) -> Void in
            if((error) != nil) {
                NSLog("Error communicating");
                self.networkView.hidden = false

            }else{
            var object =  NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            self.movies = object["movies"] as [NSDictionary]
            self.tableView.reloadData()
                self.networkView.hidden = true

            }
        }
        
        

    }

    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
     func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
     func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
//        var cell = UITableViewCell()
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        var movie = movies[indexPath.row]
        
        cell.movieTitleLabel.text =  movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        var posters = movie["posters"] as NSDictionary
        var posterUrl = posters["thumbnail"] as String
    cell.posterView.setImageWithURL(NSURL(string: posterUrl))
        
//        cell.textLabel!.text = "Hello , I m at row \(indexPath.row) , section : \(indexPath.section)"
        return cell
    }
    
     func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
//        Int rownum = indexPath.row
        var movie = movies[indexPath.row]
        NSLog(" Processing row \(indexPath.row) ")
        var selee =  movie["title"] as String
        var seleeid =  movie["id"] as String

        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(selee, forKey: "selectedmovie")
        defaults.setValue(seleeid, forKey: "selectedmovieid")

        defaults.synchronize()
        let storyboard = self.storyboard;
        let vc = storyboard.instantiateViewControllerWithIdentifier("movieDetails") as MovieDetailsController;
//        self.presentViewController(vc, animated: true, completion: nil);
                vc.selMovie =  selee

        var segue = UIStoryboardSegue(identifier: "movieDetailsSeque", source: self, destination: vc)
        self.prepareForSegue(segue, sender: self)
        NSLog("movie selected \(selee)")
        

    }
    
    
    func showhideview() {
        //    self.view.hidden = false
        MBProgressHUD.hideHUDForView(self.view!, animated: true)    }


}
