//
//  UIImage+NinePatch.h
//  ENNinePatchImageFactory
//
//

#import "UIImage+NinePatch.h"

#pragma mark - UIImage Extension

@interface UIImage (Crop)

- (UIImage*)cropBy:(CGRect)rect;

@end

@implementation UIImage (Crop)

- (UIImage*)cropBy:(CGRect)rect
{
    rect = CGRectMake(rect.origin.x * self.scale,
                      rect.origin.y * self.scale,
                      rect.size.width * self.scale,
                      rect.size.height * self.scale);

    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* result = [UIImage imageWithCGImage:imageRef
                                          scale:self.scale
                                    orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

@end





#pragma mark - ENNinePatchImageFactory

@interface ENNinePatchImageFactory (Private)

+ (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count;
+ (UIImage*)createResizableImageFromNinePatchImage:(UIImage*)ninePatchImage resize:(CGFloat)rate;

@end

@implementation ENNinePatchImageFactory

+ (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count
{
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:count];

    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char* rawData = (unsigned char*)calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);

    // Now your rawData contains the image data in the RGBA8888 pixel format.
    unsigned long byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    for (int ii = 0; ii < count; ++ii) {
        CGFloat red = (rawData[byteIndex] * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4;

        NSArray* aColor = [NSArray arrayWithObjects:[NSNumber numberWithFloat:red], [NSNumber numberWithFloat:green], [NSNumber numberWithFloat:blue], [NSNumber numberWithFloat:alpha], nil];
        [result addObject:aColor];
    }

    free(rawData);

    return result;
}

+ (UIImage*)createResizableNinePatchImageNamed:(NSString*)name
{
    NSAssert([name hasSuffix:@".9"], @"The image name is not ended with .9");

    NSString* fixedImageFilename = [NSString stringWithFormat:@"%@%@", name, @".png"];
    UIImage* oriImage = [UIImage imageNamed:fixedImageFilename];

    NSAssert(oriImage != nil, @"The input image is incorrect: ");

    NSString* fixed2xImageFilename = [NSString stringWithFormat:@"%@%@", [name substringWithRange:NSMakeRange(0, name.length - 2)], @"@2x.9.png"];
    UIImage* ori2xImage = [UIImage imageNamed:fixed2xImageFilename];
    if (ori2xImage != nil) {
        oriImage = ori2xImage;
        NSLog(@"NinePatchImageFactory[Info]: Using 2X image: %@", fixed2xImageFilename);
    } else {
        NSLog(@"NinePatchImageFactory[Info]: Using image: %@", fixedImageFilename);
    }

    return [self createResizableImageFromNinePatchImage:oriImage resize: 1.0];
}

+ (UIImage*)createResizableNinePatchImage:(UIImage*)image resize:(CGFloat)rate
{
    return [self createResizableImageFromNinePatchImage:image resize:rate];
}

+ (UIImage*)createResizableImageFromNinePatchImage:(UIImage*)ninePatchImage resize:(CGFloat)rate
{
    if (ninePatchImage == nil) {
        return nil;
    }
    
    
//    NSArray* rgbaImage = [self getRGBAsFromImage:ninePatchImage atX:0 andY:0 count:ninePatchImage.size.width * ninePatchImage.size.height];
//    NSArray* topBarRgba = [rgbaImage subarrayWithRange:NSMakeRange(1, ninePatchImage.size.width - 2)];
//    NSMutableArray* leftBarRgba = [NSMutableArray arrayWithCapacity:0];
//    int count = [rgbaImage count];
//    for (int i = 0; i < count; i += ninePatchImage.size.width) {
//        [leftBarRgba addObject:rgbaImage[i]];
//    }
//
//    int top = -1, left = -1, bottom = -1, right = -1;
//    count = [topBarRgba count];
//    for (int i = 0; i <= count - 1; i++) {
//        NSArray* aColor = topBarRgba[i];
//        //        NSLog(@"topbar left color: %@,%@,%@,%@", aColor[0], aColor[1], aColor[2], aColor[3]);
//        if ([aColor[3] floatValue] > 0) {
//            left = i;
//            break;
//        }
//    }
//
//    for (int i = count - 1; i >= 0; i--) {
//        NSArray* aColor = topBarRgba[i];
//        //        NSLog(@"topbar right color: %@,%@,%@,%@", aColor[0], aColor[1], aColor[2], aColor[3]);
//        if ([aColor[3] floatValue] > 0) {
//            right = i;
//            break;
//        }
//    }
//
//    for (int i = left + 1; i <= right - 1; i++) {
//        NSArray* aColor = topBarRgba[i];
//        if ([aColor[3] floatValue] < 1) {
//        }
//    }
//    count = [leftBarRgba count];
//    for (int i = 0; i <= count - 1; i++) {
//        NSArray* aColor = leftBarRgba[i];
//
//        if ([aColor[3] floatValue] > 0) {
//            top = i;
//            break;
//        }
//    }
//
//    for (int i = count - 1; i >= 0; i--) {
//        NSArray* aColor = leftBarRgba[i];
//        //        NSLog(@"leftbar bottom color: %@,%@,%@,%@", aColor[0], aColor[1], aColor[2], aColor[3]);
//        if ([aColor[3] floatValue] > 0) {
//            bottom = i;
//            break;
//        }
//    }
//
//
//    for (int i = top + 1; i <= bottom - 1; i++) {
//        NSArray* aColor = leftBarRgba[i];
//        if ([aColor[3] floatValue] == 0) {
//        }
//    }

//    return [resizedImage resizableImageWithCapInsets:UIEdgeInsetsMake(top * rate, left * rate, bottom * rate, right * rate)];
    
    //키보드 SDK 전용으로 제작...  위 코드로 적용해야 하나, 부분적으로 이미지가 잘못 표시되는 문제가 있음. (없던 선이 생긴다거나.. 오른쪽과 하단이 짤려버린다거나....)
    UIImage* cropImage = [ninePatchImage cropBy:CGRectMake(1, 1, ninePatchImage.size.width - 2, ninePatchImage.size.height - 2)];
    
    CGSize resize = CGSizeMake(cropImage.size.width * rate, cropImage.size.height * rate);
    UIImage* resizedImage = [self imageWithImage:cropImage convertToSize:resize];
    
    return [resizedImage resizableImageWithCapInsets:UIEdgeInsetsMake(resizedImage.size.height / 2.0  - 1,
                                                                     resizedImage.size.width / 2.0  - 1,
                                                                     resizedImage.size.height / 2.0  + 1,
                                                                     resizedImage.size.width / 2.0  + 1)];
}


+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}


@end
