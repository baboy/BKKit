//
//  UIImagePickerController+camera.m
//  iVideo
//
//  Created by baboy on 13-12-7.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "UIImagePickerController+camera.h"
#import "BKKitDefines.h"
//#import "Utils.h"
#import "NSString+x.h"
#import "UIImage+x.h"
#import "NSThread+x.h"
#import "App.h"

@implementation UIImagePickerController(camera)
+ (UIImagePickerController *)imagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType mediaTypes:(NSArray *)mediaTypes{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    [picker setSourceType:sourceType];
    if(sourceType == UIImagePickerControllerSourceTypeCamera){
        picker.showsCameraControls = YES;
    }
    //picker.navigationBar.barStyle = UIBarStyleBlack;
    picker.mediaTypes = mediaTypes;
    
    for (NSString *mediaType in mediaTypes) {
        if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
            [picker setVideoMaximumDuration:180];
        }
    }
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    }
    return picker;
}
+ (UIImage*) thumbnailOfVideo:(NSString *)videoPath{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMakeWithSeconds(0.0, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}
+ (float)durationOfVideo:(NSString *)videoPath{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:videoPath] options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}

+ (NSString *) thumbnailPathOfVideo:(NSString*)videoPath{
    NSString *thumbnailPath = [[videoPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"jpg"];
    UIImage *img = [self thumbnailOfVideo:videoPath];
    NSData *data = UIImageJPEGRepresentation(img,0.6);
    
    NSError *err = nil;
    thumbnailPath = [data writeToFile:thumbnailPath options:NSDataWritingAtomic error:&err]?thumbnailPath:nil;
    if (err) {
        DLOG(@"write file error:%@,%@,%@",err,[videoPath stringByDeletingPathExtension],[videoPath stringByDeletingLastPathComponent]);
        DLOG(@"write file error:%@",err);
    }
    return thumbnailPath;
}
+ (BOOL)saveVideoTo:(NSString *)fp fromMediaInfo:(NSDictionary*)info{
    NSURL *videoURL = [info valueForKey:UIImagePickerControllerMediaURL];
    return [[videoURL path] renameFileTo:fp];
}
+ (BOOL)savePhotoTo:(NSString *)fp fromMediaInfo:(NSDictionary*)info{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    if (!image)
        image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    if (![info valueForKey:UIImagePickerControllerReferenceURL]) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    return [image saveTo:fp];
}
@end

@implementation VideoUtils

+ (void)convertVideoFromMov:(NSString *)movFile toMp4:(NSString *)mp4 withCallback:(void (^)(AVAssetExportSession *exportSession, NSError *error))callback{
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:movFile] options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]){
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetPassthrough];
        exportSession.outputURL = [NSURL fileURLWithPath:mp4];
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            DLOG(@"%ld",(long)[exportSession status]);
            NSError *error = nil;
            switch ([exportSession status]) {
                    
                case AVAssetExportSessionStatusFailed:
                    error = [exportSession error];
                    break;
                    
                case AVAssetExportSessionStatusCancelled:
                    error = [NSError errorWithDomain:@"AVAssetExportSession Error" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"压缩失败"}];
                    
                    break;
                    
                default:
                    
                    break;
            }
            if (callback) {
                [NSThread runOnMainQueue:^{
                    callback(exportSession,error);
                }];
            }
        }];
        
    }
}
@end

@interface CameraCapture()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end
@implementation CameraCapture


- (UIImagePickerController *)captureFromController:(UIViewController *)vc
               withSourceType:(UIImagePickerControllerSourceType)sourceType
               withMediaTypes:(NSArray *)mediaTypes{
    UIImagePickerController *picker = [UIImagePickerController imagePickerWithSourceType:sourceType mediaTypes:mediaTypes];
    picker.delegate = self;
    if(vc){
        [vc presentViewController:picker animated:YES completion:^{
            
        }];
    }
    return picker;
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (info) {
        NSString *src = nil;
        NSString *thumbnail = nil;
        NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            DLOG(@"select Image");
            
            src = [AppCache cachePath:[NSString stringWithFormat:@"%@.%@",[[NSUUID UUID] UUIDString], @"jpg"]];
            [UIImagePickerController savePhotoTo:src fromMediaInfo:info];
            if ([src fileExists]) {
                thumbnail = [AppCache cachePath:[NSString stringWithFormat:@"%@.%@",[[NSUUID UUID] UUIDString], @"jpg"]];
                [UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:src], 0.5) writeToFile:thumbnail atomically:YES];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(cameraCapture:didCaptureMedia:withThumbnail:)]) {
                [self.delegate cameraCapture:self didCaptureMedia:src withThumbnail:thumbnail];
            }
        } else {
            DLOG(@"select movie");
            
            NSString *mov = [AppCache cachePath:[NSString stringWithFormat:@"%@.%@",[[NSUUID UUID] UUIDString], @"MOV"]];
            [UIImagePickerController saveVideoTo:mov fromMediaInfo:info];
            thumbnail = [UIImagePickerController thumbnailPathOfVideo:mov];
            
            //__weak id capture = self;
            NSString *mp4 = [AppCache cachePath:[NSString stringWithFormat:@"%@.%@",[[NSUUID UUID] UUIDString], @"mp4"]];
            [VideoUtils convertVideoFromMov:mov toMp4:mp4 withCallback:^(AVAssetExportSession *exportSession, NSError *error) {
                [mov deleteFile];
                if(error){
                    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraCapture:didCaptureWithError:)]) {
                        [self.delegate cameraCapture:self didCaptureWithError:error];
                    }
                }else if (self.delegate && [self.delegate respondsToSelector:@selector(cameraCapture:didCaptureMedia:withThumbnail:)]) {
                    [self.delegate cameraCapture:self didCaptureMedia:mp4 withThumbnail:thumbnail];
                }
            }];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
