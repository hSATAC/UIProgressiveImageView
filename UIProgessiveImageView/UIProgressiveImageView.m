//
//  UIProgressiveImageView.m
//  ProgressiveImageDownload
//
//  Created by hSATAC on 12/8/15.
//
//

#import "UIProgressiveImageView.h"

@implementation UIProgressiveImageView

- (void)loadImageWithURL:(NSURL *)url
{
    if (!url)
		return;
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    DownloadPictureOperation* op = [[DownloadPictureOperation alloc] initWithURL:url];
    op.delegate = self;

    [queue addOperation:op];
	[op setCompletionBlock:^{
        [queue release];
	}];
	[op release];
}

#pragma mark - DownloadPictureOperationDelegate
-(void)downloadOperationCompleted:(UIImage*)img
{
	NSLog(@"done.");
	self.image = img;
}

-(void)downloadOperationFailedWithBytesCount:(NSUInteger)bc
{
	NSLog(@"fail.");
}

-(void)downloadedImageUpdated:(CGImageRef)partialImage
{
	self.layer.contents = (id)partialImage;
}


@end
