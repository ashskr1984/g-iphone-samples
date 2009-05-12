//
//  FGFileManager.m
//

#import "FGFileManager.h"

@implementation FGFileManager

+ (void)establishBooksDirectory
{
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writableFullPath = [docPath stringByAppendingPathComponent:@"Pocket Books"];
    if (![fileManager fileExistsAtPath:writableFullPath]) 
	{
		NSString *defaultFullPath = [[[NSBundle mainBundle] resourcePath] 
									 stringByAppendingPathComponent:@"Pocket Books"];
		[fileManager copyItemAtPath:defaultFullPath toPath:writableFullPath error:&error];
	}
}

+ (NSString*)booksDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *writableFullPath = [docPath stringByAppendingPathComponent:@"Pocket Books"];
	return writableFullPath;
}

@end
