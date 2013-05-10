/**
 * 
 */

#import "CatalogGridController.h"
#import "ImageDemoGridViewCell.h"
#import "ImageDemoFilledCell.h"
#import "PhotoViewController.h"

enum
{
    ImageDemoCellTypePlain,
    ImageDemoCellTypeFill,
    ImageDemoCellTypeOffset
};

@implementation CatalogGridController

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@synthesize gridView=_gridView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.gridView.autoresizesSubviews = YES;
	self.gridView.delegate = self;
	self.gridView.dataSource = self;
    
    ImageDemoCellChooser * chooser = [[ImageDemoCellChooser alloc] initWithItemTitles: [NSArray arrayWithObjects: NSLocalizedString(@"Plain", @""), NSLocalizedString(@"Filled", @""), nil]];
    chooser.delegate = self;
    
    if ( _orderedImageNames != nil )
        return;
    
    NSString * bundlePath = [[NSBundle mainBundle] bundlePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray * files = [manager subpathsAtPath:bundlePath];

    NSMutableArray * allImageNames = [[NSMutableArray alloc] init];
    NSMutableArray * allFolderNames = [[NSMutableArray alloc] init];
    
    BOOL isDir = NO;
    BOOL thumbExist = NO;
    for (NSString *file in files) {
        NSString * fullPath = [bundlePath stringByAppendingPathComponent:file];
        [manager fileExistsAtPath:fullPath isDirectory:(&isDir)];
        thumbExist = [manager fileExistsAtPath:[fullPath stringByAppendingPathComponent:@"thumbnail.jpg"]];

        if (isDir && thumbExist) {
            NSLog(@"isDir && thumbExist %@", fullPath);
            
            [allFolderNames addObject:file];
            [allImageNames addObject: [file stringByAppendingPathComponent: @"thumbnail.jpg"]];

        } else {
//            NSLog(@"NNNNN %@", fullPath);
        }
    }
        
    // sort alphabetically
    _orderedImageNames = [[allImageNames sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)] copy];
    _imageNames = [_orderedImageNames copy];
    
    _orderedFolderNames = [[allFolderNames sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)] copy];
    _folderNames = [_orderedFolderNames copy];
    
    [allImageNames release];
    [allFolderNames release];
    
    [self.gridView reloadData];
}

- (IBAction) shuffle
{
    NSMutableArray * sourceArray = [_imageNames mutableCopy];
    NSMutableArray * destArray = [[NSMutableArray alloc] initWithCapacity: [sourceArray count]];
    
    [self.gridView beginUpdates];
    
    srandom( time(NULL) );
    while ( [sourceArray count] != 0 )
    {
        NSUInteger index = (NSUInteger)(random() % [sourceArray count]);
        id item = [sourceArray objectAtIndex: index];
        
        // queue the animation
        [self.gridView moveItemAtIndex: [_imageNames indexOfObject: item]
                               toIndex: [destArray count]
                         withAnimation: AQGridViewItemAnimationFade];
        
        // modify source & destination arrays
        [destArray addObject: item];
        [sourceArray removeObjectAtIndex: index];
    }
    
    [_imageNames release];
    _imageNames = [destArray copy];
    
    [self.gridView endUpdates];
    
    [sourceArray release];
    [destArray release];
}

- (IBAction) resetOrder
{
    [self.gridView beginUpdates];
    
    NSUInteger index, count = [_orderedImageNames count];
    for ( index = 0; index < count; index++ )
    {
        NSUInteger oldIndex = [_imageNames indexOfObject: [_orderedImageNames objectAtIndex: index]];
        if ( oldIndex == index )
            continue;       // no changes for this item
        
        [self.gridView moveItemAtIndex: oldIndex toIndex: index withAnimation: AQGridViewItemAnimationFade];
    }
    
    [self.gridView endUpdates];
    
    [_imageNames release];
    _imageNames = [_orderedImageNames copy];
}

- (IBAction) toggleLayoutDirection: (UIBarButtonItem *) sender
{
	switch ( _gridView.layoutDirection )
	{
		default:
		case AQGridViewLayoutDirectionVertical:
			sender.title = NSLocalizedString(@"Horizontal Layout", @"");
			_gridView.layoutDirection = AQGridViewLayoutDirectionHorizontal;
			break;
			
		case AQGridViewLayoutDirectionHorizontal:
			sender.title = NSLocalizedString(@"Vertical Layout", @"");
			_gridView.layoutDirection = AQGridViewLayoutDirectionVertical;
			break;
	}
	
	// force the grid view to reflow
	CGRect bounds = CGRectZero;
	bounds.size = _gridView.frame.size;
	_gridView.bounds = bounds;
	[_gridView setNeedsLayout];
}

- (void) gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{
    NSLog(@"didSelectItemAtIndex: %d", index);
    
    NSString *s = [_imageNames objectAtIndex: index];
    NSLog(@"name: %@", s);

    NSString * folderPath = [_folderNames objectAtIndex:index];
    NSMutableArray *allFilePaths = [NSMutableArray arrayWithArray:[[NSBundle mainBundle] pathsForResourcesOfType:nil inDirectory:folderPath]];
    NSMutableArray * images = [[NSMutableArray alloc] init];
    for (NSString *path in allFilePaths) {
        // The image's file extension can be "jpg" or "JPG", and exclude the thumbnail
        if ([path rangeOfString:@"thumbnail"].location == NSNotFound && 
            ([[path pathExtension] isEqualToString:@"jpg"] || [[path pathExtension] isEqualToString:@"JPG"])) {
            [images addObject:path];
        }
    }
    
    PhotoViewController *targetViewController = [[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:nil allImagePaths:images];
    [self.navigationController pushViewController:targetViewController animated:YES];
    [targetViewController release];
    [images release];
}

- (void) cellChooser: (ImageDemoCellChooser *) chooser selectedItemAtIndex: (NSUInteger) index
{
    if ( index != _cellType )
    {
        _cellType = index;
        switch ( _cellType )
        {
            case ImageDemoCellTypePlain:
                self.gridView.separatorStyle = AQGridViewCellSeparatorStyleEmptySpace;
                self.gridView.resizesCellWidthToFit = NO;
                self.gridView.separatorColor = nil;
                //break;
                
            case ImageDemoCellTypeFill:
                self.gridView.separatorStyle = AQGridViewCellSeparatorStyleSingleLine;
                self.gridView.resizesCellWidthToFit = YES;
                self.gridView.separatorColor = [UIColor colorWithWhite: 0.85 alpha: 1.0];
                break;
                
            default:
                break;
        }
        
        [self.gridView reloadData];
    }
    
}

#pragma mark -
#pragma mark Grid View Data Source

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    return ( [_imageNames count] );
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * PlainCellIdentifier = @"PlainCellIdentifier";
    static NSString * FilledCellIdentifier = @"FilledCellIdentifier";
    //static NSString * OffsetCellIdentifier = @"OffsetCellIdentifier";
    
    AQGridViewCell * cell = nil;
    
    switch ( _cellType )
    {
        case ImageDemoCellTypePlain:
        {
            ImageDemoGridViewCell * plainCell = (ImageDemoGridViewCell *)[aGridView dequeueReusableCellWithIdentifier: PlainCellIdentifier];
            if ( plainCell == nil )
            {
                plainCell = [[[ImageDemoGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 200.0, 150.0)
                                                          reuseIdentifier: PlainCellIdentifier] autorelease];
                plainCell.selectionGlowColor = [UIColor blueColor];
            }
            
            plainCell.image = [UIImage imageNamed: [_imageNames objectAtIndex: index]];
            
            cell = plainCell;
            //break;
        }
            
        case ImageDemoCellTypeFill:
        {
            ImageDemoFilledCell * filledCell = (ImageDemoFilledCell *)[aGridView dequeueReusableCellWithIdentifier: FilledCellIdentifier];
            if ( filledCell == nil )
            {
                filledCell = [[[ImageDemoFilledCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 200.0, 150.0)
                                                         reuseIdentifier: FilledCellIdentifier] autorelease];
                filledCell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
            }
            
            //NSLog([_imageNames objectAtIndex: index]);
            filledCell.image = [UIImage imageNamed: [_imageNames objectAtIndex: index]];
            filledCell.title = [_folderNames objectAtIndex: index];
            
            cell = filledCell;
            break;
        }
            
        default:
            break;
    }
    
    return ( cell );
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(224.0, 168.0) );
}

#pragma mark -
#pragma mark Grid View Delegate


/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
//- (void)setDetailItem:(id)newDetailItem {
//    if (detailItem != newDetailItem) {
//        [detailItem release];
//        detailItem = [modifyUrlForLanguage(newDetailItem, languageString) retain];
//        
//        // Update the view.
//        [self configureView];
//    }
//    
//    if (self.popoverController != nil) {
//        [self.popoverController dismissPopoverAnimated:YES];
//    }
//	if (languagePopoverController != nil) {
//        [languagePopoverController dismissPopoverAnimated:YES];
//    }     	
//}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    return YES;
//}


#pragma mark -
#pragma mark View lifecycle

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.gridView = nil;
}


#pragma mark -
#pragma mark Memory management

/*
 - (void)didReceiveMemoryWarning {
 // Releases the view if it doesn't have a superview.
 [super didReceiveMemoryWarning];
 
 // Release any cached data, images, etc that aren't in use.
 }
 */

- (void)dealloc {

    [_gridView release];
    [_imageNames release];
    [_orderedImageNames release];
    
    [super dealloc];
}

//- (void)setLanguageString:(NSString *)newString {
//    
//    
//    if (![newString isEqualToString:languageString]) {
//        [languageString release];
//        languageString = [newString copy];
//        self.detailItem = modifyUrlForLanguage(detailItem, languageString);
//    }
//}
//
//- (IBAction)touchLanguageButton {
//    LanguageListController *languageListController = [[LanguageListController alloc]
//													  init];
//    languageListController.detailViewController = self;
//    UIPopoverController *poc = [[UIPopoverController alloc]
//								initWithContentViewController:languageListController];
//    [poc presentPopoverFromBarButtonItem:languageButton 
//                permittedArrowDirections:UIPopoverArrowDirectionAny 
//                                animated:YES];
//    self.languagePopoverController = poc;
//    [poc release];
//    [languageListController release];
//}
@end
