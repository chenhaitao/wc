//
//  SDWebImageDataSource.h
//  Sample
//
//  Created by Kirby Turner on 3/18/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTPhotoBrowserDataSource.h"


@interface SDWebImageDataSource : NSObject <KTPhotoBrowserDataSource> {
   NSMutableArray *images_;
}

-(id)initWithImageArray:(NSMutableArray *)_imageArray;

@end
