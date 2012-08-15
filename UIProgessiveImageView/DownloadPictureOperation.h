//
// origin code and idea from Nyx0uf
// ref: http://www.cocoaintheshell.com/2011/05/progressive-images-download-imageio/
//

@protocol DownloadPictureOperationDelegate
-(void)downloadOperationCompleted:(UIImage*)img;
-(void)downloadOperationFailedWithBytesCount:(NSUInteger)bc;
-(void)downloadedImageUpdated:(CGImageRef)partialImage;
@end


@interface DownloadPictureOperation : NSOperation
{
@private
	/// Image URL
	NSURL* _url;
	/// Connection
	NSURLConnection* _connection;
	/// Temporary downloaded data
	NSMutableData* _dataTemp;
	/// Delegate
	id<DownloadPictureOperationDelegate> _delegate;
	/// Expected image size
	NSUInteger _expectedSize;
	/// Image source
	CGImageSourceRef _imageSource;
	/// Image width
	size_t _fullWidth;
	/// Image height
	size_t _fullHeight;
	/// Executing flag
	BOOL _isExecuting;
	/// Finished flag
	BOOL _isFinished;
}
@property (readonly) BOOL isExecuting;
@property (readonly) BOOL isFinished;
@property (nonatomic, assign) id<DownloadPictureOperationDelegate> delegate;

-(id)initWithURL:(NSURL*)url;

@end
