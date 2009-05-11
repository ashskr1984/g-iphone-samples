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
    NSString *writableFullPath = [docPath stringByAppendingPathComponent:@"My Books"];
    if (![fileManager fileExistsAtPath:writableFullPath]) 
	{
		NSString *defaultFullPath = [[[NSBundle mainBundle] resourcePath] 
									 stringByAppendingPathComponent:@"My Books"];
		[fileManager copyItemAtPath:defaultFullPath toPath:writableFullPath error:&error];
	}
}

+ (NSString*)booksDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *writableFullPath = [docPath stringByAppendingPathComponent:@"My Books"];
	return writableFullPath;
}

@end
