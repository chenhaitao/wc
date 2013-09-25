//
//  PhotoDataSource.m
//  ReallyBigPhotoLibrary
//
//  Created by Kirby Turner on 9/14/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "PhotoDataSource.h"
#import "KTPhotoView+SDWebImage.h"
#import "KTThumbView+SDWebImage.h"


@implementation PhotoDataSource



- (id)initWithImages:(NSArray *)images
{
   self = [super init];
   if (self) {
      data_ = [[NSMutableArray alloc] init];
       for (UIImage *imageName in images) {
               NSString *imageUrl= [[RequestLinkUtil getUrlByKey:DOWNLOAD_FILE] stringByAppendingFormat:@"%@",imageName];
           NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:imageUrl, @"thumbnail", imageUrl, @"fullsize", nil];
           [data_ addObject:dict];
       }
      
   }
   return self;
}


- (NSInteger)numberOfPhotos
{

   return [data_ count];
}



- (void)imageAtIndex:(NSInteger)index photoView:(KTPhotoView *)photoView {
    NSDictionary *dic = [data_ objectAtIndex:index];
    NSString *url = [dic objectForKey:@"fullsize"];
    [photoView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"photoDefault.png"]];
}

- (void)thumbImageAtIndex:(NSInteger)index thumbView:(KTThumbView *)thumbView {
    NSDictionary *dic = [data_ objectAtIndex:index];
    NSString *url = [dic objectForKey:@"thumbnail"];
    [thumbView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"photoDefault.png"]];
}

@end
