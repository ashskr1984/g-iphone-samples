//
//  AppDelegate.m
//

#import "FileBrowserViewController.h"
#import "AppDelegate.h"

#import "FGFileManager.h"

@implementation AppDelegate

@synthesize window,rootViewController,navigationController;

- (void)dealloc 
{
	[rootViewController release];
	[navigationController release];
    [window release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	[FGFileManager establishBooksDirectory];
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	window.backgroundColor = [UIColor groupTableViewBackgroundColor];
		
    rootViewController   = [[FileBrowserViewController alloc] init];
	rootViewController.path = [FGFileManager booksDirectory];
	navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
	[window addSubview:[navigationController view]];
	
    [window makeKeyAndVisible];
}


@end
