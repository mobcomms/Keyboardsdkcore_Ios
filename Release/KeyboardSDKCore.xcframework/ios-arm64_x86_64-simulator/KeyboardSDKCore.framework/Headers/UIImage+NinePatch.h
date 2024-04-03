//
//  UIImage+NinePatch.h
//  ENNinePatchImageFactory
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ENNinePatchImageFactory : NSObject

+ (UIImage*)createResizableNinePatchImageNamed:(NSString*)name;
+ (UIImage*)createResizableNinePatchImage:(UIImage*)image resize:(CGFloat)rate;

@end


