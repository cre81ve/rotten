//
//  MovieDetailsController.swift
//  rotten
//
//  Created by CK on 9/13/14.
//  Copyright (c) 2014 Chaitanya Kannali. All rights reserved.
//

import UIKit

class MovieDetailsController: UIViewController {

    @IBOutlet weak var movieTitleYear: UILabel!
//    @IBOutlet weak var selectedMovie: UILabel!
    @IBOutlet weak var movieSynopsis: UILabel!
    @IBOutlet weak var scoreString: UILabel!
    var selMovie = ""
    
    var movieImage: UIImage = UIImage()
    
    var panned = false
    var url = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=v2xqpyhtv5pdqa3ej2vuwmb2&page_limit=20&page=1&q=REPLACEME"
    
    var movieuniqueurl = "http://api.rottentomatoes.com/api/public/v1.0/movies/IDREPLACE.json?apikey=v2xqpyhtv5pdqa3ej2vuwmb2"
    
    var movie: [NSDictionary] = []
    @IBOutlet weak var moviePoster: UIImageView!
   
    @IBOutlet weak var mdetailView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selMovie
//        self.view.hidden = true
        MBProgressHUD.showHUDAddedTo(self.view!, animated: true)
        renderMovieData()
//          self.movieSynopsis.numberOfLines = 0
//        self.movieSynopsis.frame = CGRectMake(20,20,200,800)
//        
//
//        self.movieSynopsis.sizeToFit()
//        if(countElements(selMovie) > 10) {
//            selMovie = selMovie.substringToIndex(advance(0, <#n: T.Distance#>))
//            selMovie.substringWithRange(Range.0..9)

//        }

//        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), {
//            // Do something...
//            dispatch_async(dispatch_get_main_queue(), {
//                MBProgressHUD.hideHUDForView(self.view!, animated: true)
//                });
//            });
        
//        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), dispatch_async(dispatch_get_main_queue(), ^{
//            MBProgressHUD.hideHUDForView(self.view!, animated: true)
//}))
    }


    
    @IBAction func onPan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        recognizer.view!.center = CGPoint(x:recognizer.view!.center.x ,
            y:recognizer.view!.center.y + translation.y)
        recognizer.setTranslation(CGPointZero, inView: self.view)
      //        if(recognizer.view!.center.y < 315) {
//            self.movieSynopsis.frame.size.height =  self.movieSynopsis.frame.size.height + 50
//        }
        
        if recognizer.state == UIGestureRecognizerState.Ended {
            let velocity = recognizer.velocityInView(self.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200
            let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
            var finalPoint = CGPoint(x:160,
                y:534)
//            UIView.animateWithDuration(Double(slideFactor * 2),
//                delay: 0,
//                // 6
//                options: UIViewAnimationOptions.CurveEaseOut,
//                animations: {recognizer.view!.center = finalPoint },
//                completion: nil)
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
//        self.moviePoster.stopAnimating()
//        self.moviePoster.image = movieImage
        self.navigationItem.title = selMovie 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


func renderMovieData(){
    var defaults = NSUserDefaults.standardUserDefaults()
    defaults.synchronize()
    var selm =  defaults.stringForKey("selectedmovie")
    selMovie = selm!
    var selmovieid =  defaults.stringForKey("selectedmovieid")
    selm = selm?.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
    movieuniqueurl = movieuniqueurl.stringByReplacingOccurrencesOfString("IDREPLACE", withString: selmovieid!, options: NSStringCompareOptions.LiteralSearch, range: nil)
    var request = NSURLRequest(URL: NSURL(string: movieuniqueurl))
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
        (response: NSURLResponse!,data: NSData!,error:NSError!) -> Void in
        if( (error) != nil ) {
            NSLog("Error Communicating")
            self.selMovie = "Network Error , Please check your connection!!!"
        }else {
        var object =  NSJSONSerialization.JSONObjectWithData(data, options: nil, error:     nil) as NSDictionary
        var posters = object["posters"] as NSDictionary
        var thumburl = posters["thumbnail"] as String
        var profileurl = thumburl.stringByReplacingOccurrencesOfString("tmb", withString: "pro", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var detailurl = thumburl.stringByReplacingOccurrencesOfString("tmb", withString: "det", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var originalurl = thumburl.stringByReplacingOccurrencesOfString("tmb", withString: "big", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var tdata: NSData = NSData.dataWithContentsOfURL(NSURL(string:thumburl), options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        var pdata: NSData = NSData.dataWithContentsOfURL(NSURL(string:profileurl), options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        var ddata: NSData = NSData.dataWithContentsOfURL(NSURL(string:detailurl), options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        var bdata: NSData = NSData.dataWithContentsOfURL(NSURL(string:originalurl), options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        var timage: UIImage = UIImage(data: tdata)
        var pimage: UIImage = UIImage(data: pdata)
        var dimage: UIImage = UIImage(data: ddata)
        var bimage: UIImage = UIImage(data: bdata)
        self.movieImage = bimage
        let uiimgarr = [timage, pimage, dimage, bimage]
        
//
//        
//        UIView.animateWithDuration(1.5, animations: { () -> Void in
//            self.moviePoster.animationImages = uiimgarr as Array
//            self.moviePoster.animationDuration = 2
//            self.moviePoster.startAnimating()
//            
//        }, completion: { (YES) -> Void in
//            self.moviePoster.setImageWithURL(NSURL(string: detailurl));
//
//        })
            var timerloaded = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: Selector("showhideview"), userInfo: nil, repeats: false)
    
        self.moviePoster.animationImages = uiimgarr
        self.moviePoster.animationDuration = 2
        self.moviePoster.animationRepeatCount = 1
        self.moviePoster.startAnimating()
        var timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("stopblur"), userInfo: nil, repeats: false)

        
        var year = object["year"] as Int
        var title = object["title"] as String
        var yearTitle = title + "(" + String(year) + ")"
        self.movieTitleYear.text = yearTitle
        var synopsis =  object["synopsis"] as String
        self.movieSynopsis.text = synopsis
        var ratings = object["ratings"] as NSDictionary
        var criticsR = ratings["critics_score"] as Int
        var audienceR = ratings["audience_score"] as Int
        var caStr = "Critics Rating: " + String(criticsR) + " , " + "Audience Rating: " + String(audienceR)
        self.scoreString.text = caStr
        }
    }
    }
    
    func stopblur() {
        self.moviePoster.stopAnimating()
        self.moviePoster.image = movieImage

    }
    
    func showhideview() {
//    self.view.hidden = false
    MBProgressHUD.hideHUDForView(self.view!, animated: true)    }
}
