//
//  SDWebImageDataSource.m
//  Sample
//
//  Created by Kirby Turner on 3/18/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "SDWebImageDataSource.h"
#import "PhotoView+SDWebImage.h"
#import "KTThumbView+SDWebImage.h"

#define FULL_SIZE_INDEX 0
#define THUMBNAIL_INDEX 1

@implementation SDWebImageDataSource

//- (void)dealloc {
//   [images_ release], images_ = nil;
//   [super dealloc];
//}
-(id)initWithImageArray:(NSMutableArray *)_imageArray{
    self = [super init];
    if (self) {
        images_ = [[NSMutableArray alloc] init];
        for (NSString *imageName in _imageArray) {
            NSString *imageUrl= [[RequestLinkUtil getUrlByKey:DOWNLOAD_FILE] stringByAppendingFormat:@"%@",imageName];

            
            [images_ addObject:[NSArray arrayWithObjects:imageUrl, imageUrl, nil]];
        }
    }
    return self;
}

#pragma mark -
#pragma mark KTPhotoBrowserDataSource

- (NSInteger)numberOfPhotos {
   NSInteger count = [images_ count];
   return count;
}

- (void)imageAtIndex:(NSInteger)index photoView:(KTPhotoView *)photoView {
   NSArray *imageUrls = [images_ objectAtIndex:index];
   NSString *url = [imageUrls objectAtIndex:FULL_SIZE_INDEX];
   [photoView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"photoDefault.png"]];
}

//- (void)thumbImageAtIndex:(NSInteger)index thumbView:(KTThumbView *)thumbView {
//   NSArray *imageUrls = [images_ objectAtIndex:index];
//   NSString *url = [imageUrls objectAtIndex:THUMBNAIL_INDEX];
//   [thumbView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"photoDefault.png"]];
//}

-(void)deleteImageAtIndex:(NSInteger)photoIndex{
    [images_ removeObjectAtIndex:photoIndex];
}


@end
