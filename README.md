# iOSAppLifeCycleExample
Observe the iOS app state transitions as they relate to using NSOperation queues.

This is a small example of transitioning an iOS app to and from the background state while managing an `NSOperationQueue`
and background tasks (`UIApplication:beginBackgroundTaskWithName:expirationHandler`).  I only wish Apple provided better
means of testing system-initiated events, like killing an app with a running background task.

It's Objective-C.  Sorry.
