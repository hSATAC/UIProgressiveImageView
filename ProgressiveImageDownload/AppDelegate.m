#import "AppDelegate.h"
#import "ProgressiveImageDownloadViewController.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize operationQueue = _operationQueue;

-(BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
	_operationQueue = [[NSOperationQueue alloc] init];
	self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
	return YES;
}

-(void)dealloc
{
	[_operationQueue release];
	[_window release];
	[_viewController release];
	[super dealloc];
}

@end
