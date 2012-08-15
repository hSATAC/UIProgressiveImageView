//
// origin code and idea from Nyx0uf
// ref: http://www.cocoaintheshell.com/2011/05/progressive-images-download-imageio/
//

#import "DownloadPictureOperation.h"


@interface DownloadPictureOperation()
-(void)startOperation;
-(void)stopOperation;
-(CGImageRef)createTransitoryImage:(CGImageRef)partialImg CF_RETURNS_RETAINED;
@end


@implementation DownloadPictureOperation

@synthesize isExecuting = _isExecuting;
@synthesize isFinished = _isFinished;
@synthesize delegate = _delegate;

#pragma mark - Allocations / Deallocations
-(id)initWithURL:(NSURL*)url
{
	if (!url)
		return nil;
	if ((self = [super init]))
	{
		/// Create the source - better to NULL check after
		_imageSource = CGImageSourceCreateIncremental(NULL);

		_connection = nil;
		_dataTemp = nil;
		_delegate = nil;
		
		_url = [url copy];

		_fullWidth = -1.0f;
		_fullHeight = -1.0f;
	}
	return self;
}

-(void)dealloc
{
	_delegate = nil;
	SAFE_RELEASE(_url);
	SAFE_RELEASE(_connection);
	SAFE_RELEASE(_dataTemp);
	CFRelease(_imageSource), _imageSource = NULL;
	[super dealloc];
}

#pragma mark - NSOperation overrides
-(void)start
{
	if (![NSThread isMainThread])
	{
		 [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
		 return;
	}
	[self startOperation];

	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:_url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	[request release];
}

#pragma mark - NSURLConnectionDelegate
-(NSCachedURLResponse*)connection:(NSURLConnection*)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
	return nil;
}

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
	/// Try to get the expected data length, can fail;
	_expectedSize = (NSUInteger)[response expectedContentLength];
	_dataTemp = [[NSMutableData alloc] initWithCapacity:(_expectedSize != NSUIntegerMax) ? _expectedSize : 0];
}

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
	/// Append the data
	[_dataTemp appendData:data];

	/// Get the total bytes downloaded
	const NSUInteger totalSize = [_dataTemp length];
	/// Update the data source, we must pass ALL the data, not just the new bytes
	CGImageSourceUpdateData(_imageSource, (CFDataRef)_dataTemp, (totalSize == _expectedSize) ? true : false);

	/// We know the expected size of the image
	if (_fullHeight > 0 && _fullWidth > 0)
	{
		/// Create the image
		CGImageRef image = CGImageSourceCreateImageAtIndex(_imageSource, 0, NULL);
		if (image)
		{
#ifdef __IPHONE_4_0 // iOS
			CGImageRef imgTmp = [self createTransitoryImage:image];
			if (imgTmp)
			{
				[_delegate downloadedImageUpdated:imgTmp];
				CGImageRelease(imgTmp);
			}
#else // Mac OS
			[_delegate downloadedImageUpdated:image];
#endif
			CGImageRelease(image);
		}
	}
	else
	{
		CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(_imageSource, 0, NULL);
		if (properties)
		{
			CFTypeRef val = CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight);
			if (val)
				CFNumberGetValue(val, kCFNumberLongType, &_fullHeight);
			val = CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth);
			if (val)
				CFNumberGetValue(val, kCFNumberLongType, &_fullWidth);
			CFRelease(properties);
		}
	}
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{
	/// We're done
	UIImage* img = [UIImage imageWithData:_dataTemp];
	[_delegate downloadOperationCompleted:img];
	[self stopOperation];
}

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
	NSLog(@"Downloading picture error : %@", error);
	[_delegate downloadOperationFailedWithBytesCount:[_dataTemp length]];
	[self stopOperation];
}

-(CGImageRef)createTransitoryImage:(CGImageRef)partialImg
{
	const size_t height = CGImageGetHeight(partialImg);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bmContext = CGBitmapContextCreate(NULL, _fullWidth, _fullHeight, 8, _fullWidth * 4, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
	CGColorSpaceRelease(colorSpace);
	if (!bmContext)
	{
		NSLog(@"fail creating context");
		return NULL;
	}
	CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = _fullWidth, .size.height = height}, partialImg);
	CGImageRef goodImageRef = CGBitmapContextCreateImage(bmContext);
	CGContextRelease(bmContext);
	return goodImageRef;
}

#pragma mark - Private
-(void)startOperation
{
	[self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

-(void)stopOperation
{
	[self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    _isExecuting = NO;
    _isFinished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end
