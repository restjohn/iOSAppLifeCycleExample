# iOSAppLifeCycleExample
Observe the iOS app state transitions as they relate to using NSOperation queues.

This is a small example of transitioning an iOS app to and from the background state while managing an `NSOperationQueue`
and background tasks (`UIApplication:beginBackgroundTaskWithName:expirationHandler`).  I only wish Apple provided better
means of testing system-initiated events, like killing an app with a running background task.

Open the project in Xcode, make it run on the simulator or your device.  The `AppDelegate` sets up an `NSOperationQueue`
and `NSTimer` to add operations to it.  The one-and-only view displays the count of queued operations and the count of 
total operations run.  You can suspend the queue by toggling the _Run Ops_ switch, which will stop the queue from 
running operations but the timer will continue queueing them.  The _Enable Background_ switch controls whether the 
`AppDelegate` will request backgtround task time to drain the queue after transitioning to the background.  You can play
with that switch and pressing the home button to send the app to the background, then bring it back to the foreground.  
Observe the logging in the console to see the queue size and behavior as the app moves through the `UIApplicationState`
life cycle states.

It's Objective-C.  Sorry.
