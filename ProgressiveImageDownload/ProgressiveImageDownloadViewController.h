@class UIProgressiveImageView;

@interface ProgressiveImageDownloadViewController : UIViewController{
@private
	IBOutlet UIProgressiveImageView* _imageView;
    IBOutlet UIProgressiveImageView *_imageView2;
}

-(IBAction)downloadPicture:(id)sender;

@end
