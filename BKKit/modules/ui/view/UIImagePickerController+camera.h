//
//  UIImagePickerController+camera.h
//  iVideo
//
//  Created by baboy on 13-12-7.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioServices.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface UIImagePickerController(camera)

+ (UIImagePickerController *)imagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType mediaTypes:(NSArray *)mediaTypes;

+ (UIImage*) thumbnailOfVideo:(NSString *)videoPath;
+ (float) durationOfVideo:(NSString *)videoPath;

+ (NSString *) thumbnailPathOfVideo:(NSString*)videoPath;
+ (BOOL) saveVideoTo:(NSString *)fp fromMediaInfo:(NSDictionary*)info;
+ (BOOL) savePhotoTo:(NSString *)fp fromMediaInfo:(NSDictionary*)info;

@end

@interface VideoUtils : NSObject
+ (void)convertVideoFromMov:(NSString *)movFile toMp4:(NSString *)mp4 withCallback:(void (^)(AVAssetExportSession *exportSession, NSError *error))callback;
@end

@protocol CameraCaptureDelegate;
@interface CameraCapture : NSObject
@property (nonatomic, assign) id<CameraCaptureDelegate> delegate;

- (UIImagePickerController *)captureFromController:(UIViewController *)vc
               withSourceType:(UIImagePickerControllerSourceType)sourceType
               withMediaTypes:(NSArray *)mediaTypes;
@end
@protocol CameraCaptureDelegate <NSObject>

//拍摄完成后回调
@optional
- (void)cameraCapture:(CameraCapture *)capture didCaptureMedia:(NSString *)path withThumbnail:(NSString *)thumbnail;
- (void)cameraCapture:(CameraCapture *)capture didCaptureWithError:(NSError *)error;

@end