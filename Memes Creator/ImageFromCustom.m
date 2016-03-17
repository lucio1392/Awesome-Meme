//
//  ImageFromCustom.m
//  Memes Creator
//
//  Created by Vinh The on 3/9/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

#import "ImageFromCustom.h"

@interface ImageFromCustom ()

@end

@implementation ImageFromCustom

+(instancetype)shareStore{
    static ImageFromCustom *sharedStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc]initPrivate];
    });
    
    return sharedStore;
}

-(instancetype)initPrivate{
    self =  [super init];
    
    if (self) {
        if (self.imageForKey == nil) {
            self.imageForKey = [[NSMutableDictionary alloc]init];
        }
    }
    
    return self;
}

-(UIImage *)imageForKey:(NSString *)key{
    UIImage *result = self.imageForKey[key];
    
    if (!result) {
        NSString *imagePath = [self archiveImage:key];
        
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        if (result) {
            self.imageForKey[key] = result;
        }else{
            
        }
    }
    
    return result;
}


-(void)setImage:(UIImage *)image withName:(NSString *)name{
    
    [self.imageForKey setObject:image forKey:name];
    
    NSString *path = [self archiveImage:name];
    
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    [data writeToFile:path atomically:YES];
}

-(void)deleteImage:(NSString *)name{
    if (!name) {
        return;
    }
    
    [self.imageForKey removeObjectForKey:name];
    
    NSString *path =  [self archiveImage:name];
    
    [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
}
-(NSString*)archiveImage:(NSString *)name{
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    NSLog(@"%@", documentDirectory);
    return  [documentDirectory stringByAppendingPathComponent:name];
    
}
@end
