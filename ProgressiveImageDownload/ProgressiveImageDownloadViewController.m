#import "ProgressiveImageDownloadViewController.h"
#import "AppDelegate.h"
#import "UIProgressiveImageView.h"

@implementation ProgressiveImageDownloadViewController


-(void)dealloc
{
	[_imageView release];
    [_imageView2 release];
    [super dealloc];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBActions
-(IBAction)downloadPicture:(id)sender
{
    NSURL* url = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/c/c4/Savannah_Cat_portrait.jpg"];
    
    [_imageView loadImageWithURL:url];
    NSURL* url2 = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/c/c1/Six_weeks_old_cat_(aka).jpg"];
    
    [_imageView2 loadImageWithURL:url2];

}

#pragma mark - DownloadPictureOperationDelegate
-(void)downloadOperationCompleted:(UIImage*)img
{
	NSLog(@"done.");
	_imageView.image = img;
}

-(void)downloadOperationFailedWithBytesCount:(NSUInteger)bc
{
	NSLog(@"fail.");
}

-(void)downloadedImageUpdated:(CGImageRef)partialImage
{
	//_imageView.layer.contents = (id)partialImage;
	[_imageView setImage:[UIImage imageWithCGImage:partialImage]];
}

@end
