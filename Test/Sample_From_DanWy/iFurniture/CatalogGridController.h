/**
 *
 */

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "ImageDemoCellChooser.h"


@interface CatalogGridController : UIViewController<AQGridViewDelegate, AQGridViewDataSource, ImageDemoCellChooserDelegate> {

    NSArray * _orderedImageNames;
    NSArray * _imageNames;

    NSArray * _orderedFolderNames;
    NSArray * _folderNames;

    AQGridView * _gridView;
    
    NSUInteger _cellType;
}

@property (nonatomic, retain) IBOutlet AQGridView * gridView;

- (IBAction) shuffle;
- (IBAction) resetOrder;

@end
