//
//  UIProgressiveImageView.h
//  ProgressiveImageDownload
//
//  Created by hSATAC on 12/8/15.
//
//

#import <UIKit/UIKit.h>
#import "DownloadPictureOperation.h"

@class DownloadPictureOperation;

@interface UIProgressiveImageView : UIImageView <DownloadPictureOperationDelegate>
{

}
- (void)loadImageWithURL:(NSURL*)url;
@end
