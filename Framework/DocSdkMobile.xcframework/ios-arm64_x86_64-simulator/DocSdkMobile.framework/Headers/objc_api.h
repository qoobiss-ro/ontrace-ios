/* Copyright 2024 ID R&D Inc. All Rights Reserved. */

#pragma once

#import <Foundation/Foundation.h>

#define DOC_SDK_MOBILE_OBJC_API __attribute__((visibility("default")))

#ifndef __APPLE__
// overwrite NS_SWIFT_NAME macro since its implementation generates compilation error in linux clang
#define NS_SWIFT_NAME(x)
#endif

NS_ASSUME_NONNULL_BEGIN

/*!
 * @brief IDLive Doc SDK Mobile error codes enumeration.
 */
typedef NS_ENUM(NSInteger, IDLDErrorCode) {
    /*!
     * @brief No error.
     */
    IDLDErrorCodeOk = 0,

    /*!
     * @brief Null pointer was passed as a parameter.
     */
    IDLDErrorCodeNullptr = 1,

    /*!
     * @brief Internal error was generated.
     */
    IDLDErrorCodeInternalError = 2,

    /*!
     * @brief Invalid image size passed.
     */
    IDLDErrorCodeInvalidImageSize = 3,

    /*!
     * @brief SDK license is expired.
     */
    IDLDErrorCodeLicenseExpired = 4,
};

/*!
  * @brief Image representation.
  */
DOC_SDK_MOBILE_OBJC_API
@interface IDLDImage : NSObject

/*!
 * @brief Constructs an image from a buffer containing raw data in RGB888 format.
 * 
 * @param imageData A row-major ordered array of imageWidth * imageHeight * 3 size holding raw image data in
 * RGB888 format
 * @param imageWidth Image width in pixels, should be positive
 * @param imageHeight Image height in pixels, should be positive
 * @param error A reference to an NSError object to receive error information in case of failure
 */
- (instancetype _Nullable)initWithImageDataRGB888:(NSData*)imageData
                                       imageWidth:(uint32_t)imageWidth
                                      imageHeight:(uint32_t)imageHeight
                                            error:(NSError**)error;

/*!
 * @brief Constructs an image from a buffer containing raw data in YUV420_888 (YCbCr420_888) format.
 *
 * @param imageDataY A row-major ordered array of image_width * image_height size containing
 * Y (luminance/brightness) component data
 * @param imageDataU A row-major ordered array of ((imageWidth+1)/2)*((imageHeight+1)/2) size containing
 * U (Cb/chrominance/blue-difference) component data
 * @param imageDataV A row-major ordered array of ((imageWidth+1)/2)*((imageHeight+1)/2) size containing
 * V (Cr/chrominance/red-difference) component data
 * @param imageWidth Image width in pixels, should be positive
 * @param imageHeight Image height in pixels, should be positive
 * @param error A reference to an NSError object to receive error information in case of failure.
 */
- (instancetype _Nullable)initWithImageDataY:(NSData*)imageDataY
                                  imageDataU:(NSData*)imageDataU
                                  imageDataV:(NSData*)imageDataV
                                  imageWidth:(uint32_t)imageWidth
                                 imageHeight:(uint32_t)imageHeight
                                       error:(NSError**)error;

@end

/*!
 * @brief Two-dimensional point representation.
 */
DOC_SDK_MOBILE_OBJC_API
@interface IDLDPoint2d : NSObject

/*!
 * @brief X coordinate, can be negative.
 */
@property(assign) int32_t x;

/*!
 * @brief Y coordinate, can be negative.
 */
@property(assign) int32_t y;

@end

/*!
 * @brief Quadrilateral-shaped document detection representation.
 */
DOC_SDK_MOBILE_OBJC_API
@interface IDLDQuadrilateral : NSObject

/*!
 * @brief Vertex #1.
 */
@property(strong) IDLDPoint2d* p1;

/*!
 * @brief Vertex #2.
 */
@property(strong) IDLDPoint2d* p2;

/*!
 * @brief Vertex #3.
 */
@property(strong) IDLDPoint2d* p3;

/*!
 * @brief Vertex #4.
 */
@property(strong) IDLDPoint2d* p4;

@end

/*!
 * @brief IDLive Doc SDK Mobile error codes enumeration.
 */
typedef NS_ENUM(NSInteger, IDLDIQAWarning) {
    /*!
     * @brief Document is not detected in the image.
     */
    IDLDIQAWarningDocumentNotFound = 0,

    /*!
     * @brief Document size (area) is lower than 10% of the frame size.
     */
    IDLDIQAWarningDocumentSizeLowerThan10Percent = 1,

    /*!
     * @brief Document border(s) are outside the frame.
     */
    IDLDIQAWarningDocumentBordersOutsideOfFrame = 2,

    /*!
     * @brief More than one document are present in the frame.
     */
    IDLDIQAWarningMultipleDocumentsInFrame = 3,

    /*!
     * @brief Document is too close to the frame border.
     */
    IDLDIQAWarningDocumentTooCloseToBorder = 4,
};

/*!
 * @brief Document detection and image quality assessment (IQA) result.
 */
DOC_SDK_MOBILE_OBJC_API
@interface IDLDDocumentDetectionResult : NSObject

/*!
 * @brief Quadrilateral-shaped document detections.
 */
@property(strong) NSArray<IDLDQuadrilateral*>* detections;

/*!
 * @brief Image quality warnings, empty if no warnings were generated (image quality is good). 
 * Contains raw integer values corresponding to the IDLDIQAWarning values.
 */
@property(strong) NSArray<NSNumber*>* iqaWarnings;

@end

/*!
 * @brief Document detector.
 */
DOC_SDK_MOBILE_OBJC_API
@interface IDLDDocumentDetector : NSObject

/*!
 * @brief Document detector initializer.
 * Note: overwrite default init
 *
 * @param error A reference to an NSError object to receive error information in case of failure
 */
- (instancetype _Nullable)initWithError:(NSError**)error NS_SWIFT_NAME(init());

/*!
 * @brief Performs document detection on the input image.
 * Note: this function is not thread safe, please ensure proper synchronization mechanisms
 * if used in multithreaded environment
 *
 * @param image Input image
 * @param error A reference to an NSError object to receive error information in case of failure
 * @return IDLDDocumentDetectionResult object on success, nil on error
 */
- (IDLDDocumentDetectionResult* _Nullable)detectWithImage:(IDLDImage*)image error:(NSError**)error;

@end

/*!
 * @brief Provides a way to control global DocSDKMobile configuration.
 */
DOC_SDK_MOBILE_OBJC_API
@interface IDLDSettings : NSObject

/*!
 * @brief Installs the runtime license. Should be called before any other SDK invocation.
 * Note: this function is not thread safe, please ensure proper synchronization mechanisms
 * if used in multithreaded environment
 * 
 * @param licenseStr A string holding the license content
 * @param error A reference to an NSError object to receive error information in case of failure
 */
+ (BOOL)installLicense:(NSString*)licenseStr error:(NSError**)error;

/*!
 * @brief Returns the expiration date of the currently installed license in UTC time
 * formatted as YYYY-mm-ddTHH:MM:SSZ
 * 
 */
+ (NSString*)getLicenseExpirationDate;

@end

NS_ASSUME_NONNULL_END

#ifndef __APPLE__
#undef NS_SWIFT_NAME
#endif
