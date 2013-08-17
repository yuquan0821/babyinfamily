//
//  BabyAlbumsViewController.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-8-7.
//
//

#import <UIKit/UIKit.h>
#import "ThumbnailListView.h"
#import "BabyStickerView.h"

@interface BabyAlbumsViewController : UIViewController<ThumbnailListViewDataSource,ThumbnailListViewDelegate,BabyStickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic, retain) UIImageView            *babyBigAlbumsView;
@property(nonatomic, retain) ThumbnailListView      *thumbnailListView;
@property(nonatomic, retain) NSMutableArray         * stickerviewArray;
@property(nonatomic, assign) BabyStickerView        *selectedSticker;
@property(nonatomic, retain) BabyStickerView        *Sticker;
@property(nonatomic, retain) BabyStickerView        *Sticker1;


@end
