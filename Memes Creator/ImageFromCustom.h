//
//  ImageFromCustom.h
//  Memes Creator
//
//  Created by Vinh The on 3/9/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageFromCustom : NSObject
@property(nonatomic, strong)NSMutableDictionary *imageForKey;
+(instancetype)shareStore;
-(void)setImage:(UIImage *)image withName:(NSString *)name;
-(UIImage *)imageForKey:(NSString *)key;
-(void)deleteImage:(NSString *)name;
@end
