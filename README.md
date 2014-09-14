rotten
======
Rotten tomatoes , tried to mimic the gif. 

<b>GIF</b>:

 <img src="https://github.com/cre81ve/rotten/blob/master/rotten_lcap.gif" ></img>

<b>Time Taken</b> : 6 hours 20 mins

<b> Instructions </b>
- Use Xcode Beta 6 to build and run this app.

<h3><b>CHECKLIST</b> </h3>
- [x] Used Cocoapods - <i>AFNetoworking , MBProgreessHUD</i>
- [x] User can view a list of movies from Rotten Tomatoes. Poster images must be loading asynchronously. 
- [x] User can view movie details by tapping on a cell 
- [x] User sees loading state while waiting for movies API. You can use one of the 3rd party libraries at cocoacontrols.com. 
    (Used MBProgressHUD cocoa Control)
- [x] User sees error message when there's a networking error. You may not use UIAlertView to display the error. 
    (Used a View to address this)
- [x] User can pull to refresh the movie list. 
    (UIRefreshControl)
- [x] Add a search bar. (optional) - DONE (FUNCTIONAL as well)   
- [x] All images fade in (optional) DONE (UIImageView animation options)
- [x] For the large poster, load the low-res image first, switch to high-res when complete (optional) DONE
- [x] All images should be cached in memory and disk. In other words, images load immediately upon cold start (optional) -
  (Not sure about this ,using AFNetworking pod , might be doing this)
- [ ] Customize the highlight and selection effect of the cell. (optional)
- [ ] Customize the navigation bar. (optional)
- [ ] Add a tab bar for Box Office and DVD. (optional)

<b>Observations </b>
- Time spent went into - UX elements (Label - vertical aligning , Animation of ImageView - stopAnimation checking) etc.


<h3>License </h3>
MIT

<h3>Libraries used.</h3>

- https://github.com/jdg/MBProgressHUD
- https://github.com/AFNetworking/AFNetworking
- Used http://api.rottentomatoes.com/api/public/v1.0/ API





