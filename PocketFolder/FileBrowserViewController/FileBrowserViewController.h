//
//  FileTableViewController.h
//

#import <UIKit/UIKit.h>

@class BookShareViewController,File;

enum {
    FGPasswordTargetNone		= 0,
    FGPasswordTargetLock		= 1 << 0,
    FGPasswordTargetLockConfirm = 1 << 1,
    FGPasswordTargetUnlock		= 1 << 2,
    FGPasswordTargetOpen		= 1 << 3,
    FGPasswordTargetDelete		= 1 << 4
};
typedef NSUInteger FGPasswordTarget;

#define PASSWORD_LEN_MIN  4
#define PASSWORD_LEN_MAX 12

@interface FileBrowserViewController : UITableViewController <UITextFieldDelegate>
{
@private
	NSString		* curPath;
	NSArray			* visibleExtensions;
	NSMutableArray	* files;

	UIBarButtonItem * shareButton;
	UIBarButtonItem * newFolderButton;
	BookShareViewController * shareViewController;
	
	File            * newFile;
	
	FGPasswordTarget  pwdTarget;
	NSString        * pwdAlertTitle;
	NSString        * pwdAlertMessage;
	NSIndexPath     * curIndexPath;
}

@property (nonatomic,retain) NSString		* curPath;
@property (nonatomic,retain) NSArray		* visibleExtensions;
@property (nonatomic,retain) NSMutableArray	* files;
@property (nonatomic,retain) NSIndexPath    * curIndexPath;

- (void)reloadFiles;

@end
