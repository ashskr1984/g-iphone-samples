//
//  File.m
//

#import "File.h"
#import "DefaultsController.h"

@interface File(Private)
+ (BOOL)deleteFile:(NSString*)filePath;
+ (BOOL)deleteFolder:(NSString*)folderPath;

+ (BOOL)renameFile:(NSString*)oldFilePath toFile:(NSString*)newFilePath;
+ (BOOL)renameFolder:(NSString*)oldFolderPath toFolder:(NSString*)newFolderPath;
@end

@implementation File

@synthesize isDirectory,name,parentDirectory;

- (void)dealloc
{
	[parentDirectory release];
	[name release];
	[super dealloc];
}

- (id)init
{
	NSAssert(0,@"class File don't support -init method, use -initWithParentDirectory:name: instead.");
	return self;
}

- (id)initWithParentDirectory:(NSString*)parentDir name:(NSString*)fileName
{
	if(self = [super init])
	{
		self.parentDirectory = parentDir;
		self.name = fileName;
		
		//initialize 'isDirectory' & 'locked'
		if(!parentDirectory||!name)
		{
			isDirectory = YES;
			locked = NO;
		}
		else
		{
			NSString* fullpath = [parentDirectory stringByAppendingPathComponent:name];
			[[NSFileManager defaultManager] fileExistsAtPath:fullpath isDirectory:&isDirectory];
			locked = [[DefaultsController sharedDefaultsController] isLockedOfFile:fullpath];
		}
	}
	return self;
}

static UIImage * s_folderImage = nil;
static UIImage * s_fileImage   = nil;

+ (UIImage*)folderImage
{
	if(!s_folderImage)
		s_folderImage = [[UIImage imageNamed:@"SmallFolder.png"] retain];
	return s_folderImage;
}

+ (UIImage*)fileImage
{
	if(!s_fileImage)
		s_fileImage = [[UIImage imageNamed:@"generic_small.png"] retain];
	return s_fileImage;
}

+ (BOOL)deleteFile:(NSString*)filePath
{
	[[DefaultsController sharedDefaultsController] deleteDefaultsForFile:filePath];
	[[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
	return YES;
}

+ (BOOL)deleteFolder:(NSString*)folderPath
{
	// delete the defaults for the folder recursively
	[[DefaultsController sharedDefaultsController] deleteDefaultsForFolder:folderPath];
	[[NSFileManager defaultManager] removeItemAtPath:folderPath error:NULL];
	return YES;
}

- (BOOL)delete
{
	NSString* fullpath = [parentDirectory stringByAppendingPathComponent:name];
	if(isDirectory)
		return [File deleteFolder:fullpath];
	else
		return [File deleteFile:fullpath];
}

+ (BOOL)renameFile:(NSString*)oldFilePath toFile:(NSString*)newFilePath
{
	[[DefaultsController sharedDefaultsController] moveDefaultsForFile:oldFilePath toFile:newFilePath];
	[[NSFileManager defaultManager] moveItemAtPath:oldFilePath toPath:newFilePath error:NULL];
	return YES;
}

+ (BOOL)renameFolder:(NSString*)oldFolderPath toFolder:(NSString*)newFolderPath
{
	// delete the defaults for the folder recursively
	[[DefaultsController sharedDefaultsController] moveDefaultsForFolder:oldFolderPath toFolder:newFolderPath];
	[[NSFileManager defaultManager] moveItemAtPath:oldFolderPath toPath:newFolderPath error:NULL];
	return YES;
}

- (BOOL)renameTo:(NSString*)newName
{
	BOOL success;
	NSString* oldFullpath = [parentDirectory stringByAppendingPathComponent:name];
	NSString* newFullpath = [parentDirectory stringByAppendingPathComponent:newName];
	
	if(isDirectory)
		success = [File renameFolder:oldFullpath toFolder:newFullpath];
	else
		success = [File renameFile:oldFullpath toFile:newFullpath];
	
	if(success)
		self.name = newName;
	
	return success;
}

+ (BOOL)moveFile:(NSString*)fileName fromFolder:(NSString*)oldParentDirectory toFolder:(NSString*)newParentDirectory
{
	NSString* oldFilePath = [oldParentDirectory stringByAppendingPathComponent:fileName];
	NSString* newFilePath = [newParentDirectory stringByAppendingPathComponent:fileName];
	[[DefaultsController sharedDefaultsController] dumpFileSpecificDefaults:@"Before moveFile"];
	[[DefaultsController sharedDefaultsController] moveDefaultsForFile:oldFilePath toFile:newFilePath];
	[[DefaultsController sharedDefaultsController] dumpFileSpecificDefaults:@"After  moveFile"];
	[[NSFileManager defaultManager] moveItemAtPath:oldFilePath toPath:newFilePath error:NULL];
	return YES;
}

+ (BOOL)moveFolder:(NSString*)folderName fromFolder:(NSString*)oldParentDirectory toFolder:(NSString*)newParentDirectory
{
	NSString* oldFolderPath = [oldParentDirectory stringByAppendingPathComponent:folderName];
	NSString* newFolderPath = [newParentDirectory stringByAppendingPathComponent:folderName];
	
	[[DefaultsController sharedDefaultsController] moveDefaultsForFolder:oldFolderPath toFolder:newFolderPath];
	[[NSFileManager defaultManager] moveItemAtPath:oldFolderPath toPath:newFolderPath error:NULL];
	return YES;
}

- (BOOL)moveToDirectory:(NSString*)newParentDirectory
{
	BOOL success = YES;
	
	if([parentDirectory isEqualToString:newParentDirectory])
		return success;
	
	if(isDirectory)
		success = [File moveFolder:name fromFolder:parentDirectory toFolder:newParentDirectory];
	else
		success = [File moveFile:name fromFolder:parentDirectory toFolder:newParentDirectory];
	
	if(success)
		self.parentDirectory = newParentDirectory;
	
	return success;
}

- (BOOL)create
{
	NSError * error;
	NSString *path = [parentDirectory stringByAppendingPathComponent:name];
	return [[NSFileManager defaultManager] createDirectoryAtPath:path 
									 withIntermediateDirectories:NO 
													  attributes:nil 
														   error:&error];
}

- (BOOL)locked
{
	return locked;
}

- (void)setLocked:(BOOL)lock
{
	locked = lock;
	NSString *fullpath = [parentDirectory stringByAppendingPathComponent:name];
	[[DefaultsController sharedDefaultsController] setLocked:locked forFile:fullpath];
}


@end
