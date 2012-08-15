@class ProgressiveImageDownloadViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate>
{

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ProgressiveImageDownloadViewController *viewController;
@property (nonatomic, readonly) NSOperationQueue* operationQueue;

@end
