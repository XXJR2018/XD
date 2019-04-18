//
//  LocationManager.m
//  XXJR
//
//  Created by xxjr02 on 16/1/11.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

@implementation LocationInfo

- (id)initWithLocation:(CLLocation *)location
{
    if (self = [self init])
    {
        self.latitude = location.coordinate.latitude;
        self.longitude = location.coordinate.longitude;
        self.altitude = location.altitude;
        self.horizontalAccuracy = location.horizontalAccuracy;
        self.verticalAccuracy = location.verticalAccuracy;
        self.addressInfo = nil;
    }
    return self;
}

@end

@implementation AddressInfo

- (id)initWithPlacemark:(CLPlacemark *)placemark
{
    if (self = [self init])
    {
        self.nameString = placemark.name;
        self.thoroughfareString = placemark.thoroughfare;
        self.subThoroughfareString = placemark.subThoroughfare;
        self.localityString = placemark.locality;
        self.subLocalityString = placemark.subLocality;
        self.administrativeAreaString = placemark.administrativeArea;
        self.subAdministrativeAreaString = placemark.subAdministrativeArea;
        self.postalCodeString = placemark.postalCode;
        self.ISOcountryCodeString = placemark.ISOcountryCode;
        self.countryString = placemark.country;
        self.inlandWaterString = placemark.inlandWater;
        self.oceanString = placemark.ocean;
        self.areasOfInterestArray = placemark.areasOfInterest;
        self.addressDictionary = placemark.addressDictionary;
    }
    return self;
}

@end



@interface LocationManager ()<CLLocationManagerDelegate>

/**
 *	定位操作是否完成
 */
@property (assign) BOOL isLocatingFinish;

/**
 *	存放定位操作回调的block的字典
 */
@property (retain, nonatomic) NSMutableDictionary *locationDictionary;

/**
 *	存放反编译地址操作回调的block的字典
 */
@property (retain, nonatomic) NSMutableDictionary *geocodeDictionary;

/**
 *	定位管理器
 */
@property (retain, nonatomic) CLLocationManager *locationManager;

/**
 *	反编译地址的操作工具
 */
@property (retain, nonatomic) CLGeocoder *geocoder;

/**
 *	是否正在定位
 */
@property (assign, nonatomic) BOOL isLocating;

/**
 *	是否开启反编译操作
 */
@property (assign, nonatomic) BOOL isStartReverseGeocoder;

/**
 *	开始定位
 */
- (void)startLocation;

/**
 *	遍历触发字典里面的block方法。调用方法后会移除block。
 *
 *	@param	dictionary	存放block的字典
 *	@param	isSuccess	操作是否成功
 *	@param	info	定位信息
 *	@param	error	错误信息
 */
- (void)triggerBlockWithDictionary:(NSMutableDictionary *)dictionary
                         isSuccess:(BOOL)isSuccess
                              info:(LocationInfo *)info
                             error:(NSError *)error;

/**
 *	开始反编译地址
 *
 *	@param	location    坐标信息
 */
- (void)startReverseGeocoderLocation:(CLLocation *)location;

/**
 *	定位超时，这里的定位在有反编译地址操作的时候，包括整个定位流程
 */
- (void)locationManagerDidTimeout;

/**
 *	定位结束
 */
- (void)endLocation;

/**
 *	反编译地址结束
 */
- (void)endReverseGeocoder;

@end

@implementation LocationManager

static NSUInteger repeatCount = 0;

#pragma mark -
#pragma mark ==== Live cycle ====
#pragma mark -

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

+ (LocationManager *)shareManager
{
    static dispatch_once_t once;
    static LocationManager *singleton;
    dispatch_once(&once, ^ { singleton = [[LocationManager alloc] init]; });
    return singleton;
}

+ (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    if (self = [super init])
    {
        self.isLocating = NO;
        self.isStartReverseGeocoder = NO;
        self.timeoutSecond = 0.f;
        self.showLocationCloseAlert = NO;
    }
    return self;
}

#pragma mark -
#pragma mark ==== Property methods ====
#pragma mark -

- (NSMutableDictionary *)locationDictionary
{
    if (!_locationDictionary)
    {
        _locationDictionary = [[NSMutableDictionary alloc] init];
    }
    return _locationDictionary;
}

- (NSMutableDictionary *)geocodeDictionary
{
    if (!_geocodeDictionary)
    {
        _geocodeDictionary = [[NSMutableDictionary alloc] init];
    }
    return _geocodeDictionary;
}

- (BOOL)allowAppcationLocation {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways){
        return YES;
    } else {
        return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways);
    }
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager){
        if ([self allowAppcationLocation]) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
            _locationManager.distanceFilter = 1000.f;
            _locationManager.delegate = self;
            if (iOS8) {
                [_locationManager requestAlwaysAuthorization];
            }
        }
    }
    return _locationManager;
}

- (CLGeocoder *)geocoder
{
    if (!_geocoder)
    {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

#pragma mark -
#pragma mark ==== Public methods ====
#pragma mark -
- (void)getUserLocationSuccess:(Block_Void)successBlock failedBlock:(Block_Int)failedBlock{
//    //判断距上次定位是否超过30秒，超过则重新定位，否则不定位
//    if ([[NSDate date] minutesAfterDate:[DDGSetting sharedSettings].lastLocationDate] <= 0.05){
//        return;
//    }
    
    [[LocationManager shareManager] startLocationWithBlock:^(BOOL isFinish, LocationInfo *info, NSError *error) {
        [DDGSetting sharedSettings].canLocate = isFinish;        
        if (error &&
            (error.code == LocationManagerErrorTypeAuthorizationDenied ||
             error.code == LocationManagerErrorTypeAuthorizationRestricted)){
            if ([ToolsUtlis isAppFirstLoaded]){
                self.showLocationCloseAlert = YES;
            } else {
                if (failedBlock){                   
                    failedBlock((int)error.code);
                }
            }
        }

    } blockKey:@"checkLocation"];
    
    
    [[LocationManager shareManager] getLocationInformationWithBlock:^(BOOL isFinish,LocationInfo *info, NSError *error){
         if (isFinish){
             // 防止崩溃
             if (! info.addressInfo.localityString) {
                 return;
              }
             [DDGSetting sharedSettings].locationCityString = info.addressInfo.localityString;
             if ([CommonInfo getKey:@"LocationCity"].length > 0) {
                 if (![info.addressInfo.localityString isEqualToString:[CommonInfo getKey:@"LocationCity"]]) {
                     //发送定位城市和上次定位城市不同通知
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"PositioningCitiesDifferent" object:info.addressInfo.localityString];
                 }else{
                     //缓存定位城市
                    [CommonInfo setKey:@"LocationCity" withValue:info.addressInfo.localityString];
                 }
             }else{
                 //缓存定位城市
                 [CommonInfo setKey:@"LocationCity" withValue:info.addressInfo.localityString];
             }
             
             [DDGSetting sharedSettings].latitude = info.latitude;
             [DDGSetting sharedSettings].longitude = info.longitude;
             NSLog(@"addressDictionary is %@",info.addressInfo.addressDictionary);
             
             if (info.addressInfo.administrativeAreaString.length > 0)
                 [DDGSetting sharedSettings].locationProvinceString = info.addressInfo.administrativeAreaString;
             else
                 [DDGSetting sharedSettings].locationProvinceString = info.addressInfo.localityString;
             
             [DDGSetting sharedSettings].locationSucceed = YES;
             //定位成功后存储当前定位时间
             [DDGSetting sharedSettings].lastLocationDate = [NSDate date];
             self.isLocatingFinish = YES;
             
//             // 查找cityCode
//             NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"areaList" ofType:@"plist"];
//             NSArray *data = [[NSArray alloc] initWithContentsOfFile:plistPath];
//             BOOL need = YES;
//             for (NSDictionary *provinceDic in data) {
//                 if (need) {
//                     for (NSDictionary *dic in provinceDic[@"citys"]) {
//                         if ([dic[@"nameCn"] isEqualToString:[info.addressInfo.addressDictionary objectForKey:@"City"]]) {
//                             [DDGSetting sharedSettings].locationCityCode = dic[@"code"];
//                             need = NO;
//                             break;
//                         }
//                     }
//                 }else break;
//             }
             
             
             if (successBlock) {
                 successBlock();
             }
         }else{
             if (failedBlock){
                 failedBlock((int)error.code);
             }
         }
         
     } blockKey:@"checkLocation"];
    
    //开启3秒超时
//    if (![DDGSetting sharedSettings].currentAreaId || [[DDGSetting sharedSettings].currentAreaId isEmpty])
//    {
//        [self performSelector:@selector(locationTimeout) withObject:nil afterDelay:3.f];
//    }
}

- (void)locationTimeout
{
    [[LocationManager shareManager] stopLocationManager];
    [self endLocation];
}

- (void)startLocationWithBlock:(void (^)(BOOL, LocationInfo *, NSError *))block blockKey:(NSString *)key
{
    [self.locationDictionary setObject:[block copy] forKey:key];
    
    [self startLocation];
}

- (void)getLocationInformationWithBlock:(void (^)(BOOL, LocationInfo *, NSError *))block blockKey:(NSString *)key
{
    [self.geocodeDictionary setObject:[block copy] forKey:key];
    self.isStartReverseGeocoder = YES;
    [self startLocation];
}

- (void)stopLocationManager
{
    [_locationManager stopUpdatingHeading];
    [_locationManager stopUpdatingLocation];
    _locationManager.delegate = nil;
    if (![self allowAppcationLocation])
    {
        _locationManager = nil;
    }
    
    repeatCount = 3;
    [self.geocoder cancelGeocode];
    self.geocoder = nil;
    
    self.isLocating = NO;
    
    DDGError *error = [DDGError errorWithCode:LocationManagerErrorTypeCancelLocation
                               errorMessage:@"Location manager did cancled."];
    
    [self triggerBlockWithDictionary:self.locationDictionary
                           isSuccess:NO
                                info:nil
                               error:error];
    [self triggerBlockWithDictionary:self.geocodeDictionary
                           isSuccess:NO
                                info:nil
                               error:error];
}

- (NSString *)getAddressWithDictionary:(NSDictionary *)dic
{
    NSString *addressString = @"";
    
    NSArray *languagesArray = [NSLocale preferredLanguages];
    NSString *currentLanguageString = [languagesArray objectAtIndex:0];
    BOOL isEnglishLanguage = [currentLanguageString isEqualToString:@"en"];
    
    if ([dic objectForKey:@"City"])
    {
        addressString = [addressString stringByAppendingString:[dic objectForKey:@"City"]];
        if (isEnglishLanguage)
        {
            addressString = [addressString stringByAppendingString:@" "];
        }
    }
    if ([dic objectForKey:@"SubLocality"])
    {
        addressString = [addressString stringByAppendingString:[dic objectForKey:@"SubLocality"]];
        if (isEnglishLanguage)
        {
            addressString = [addressString stringByAppendingString:@" "];
        }
    }
    if ([dic objectForKey:@"Street"])
    {
        addressString = [addressString stringByAppendingString:[dic objectForKey:@"Street"]];
    }
    return [NSString stringWithFormat:@"%@",addressString];
}


#pragma mark -
#pragma mark ==== Private methods ====
#pragma mark -

- (void)startLocation
{
    NSLog(@"%@",@"调用startLocation函数");
    if (self.locationManager)
    {
        if (!self.isLocating)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:LocationGPSNotOnNotification object:[NSNumber numberWithBool:YES]];
            NSLog(@"%@",@"一切正常，开始定位");
            self.isLocating = YES;
            self.locationManager = nil;
            [self.locationManager startUpdatingLocation];
            //开启超时判断
            if (self.timeoutSecond > 0.f)
            {
                NSLog(@"%@",@"超时时间大于0，开启超时操作函数");
                [self performSelector:@selector(locationManagerDidTimeout)
                           withObject:nil
                           afterDelay:self.timeoutSecond];
            }
        }
    }
    else
    {
        NSLog(@"%@",@"locationManager为空，定位失败！");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LocationGPSNotOnNotification object:[NSNumber numberWithBool:NO]];
        NSError *error = nil;
        switch ([CLLocationManager authorizationStatus])
        {
            case kCLAuthorizationStatusDenied:
            {
                error = [NSError errorWithDomain:@"Location service did not authorize."
                                            code:LocationManagerErrorTypeAuthorizationDenied
                                        userInfo:nil];
            }
                break;
            case kCLAuthorizationStatusRestricted:
            {
                error = [NSError errorWithDomain:@"Location service did limit by system."
                                            code:LocationManagerErrorTypeAuthorizationRestricted
                                        userInfo:nil];
            }
                break;
            case kCLAuthorizationStatusNotDetermined:
            case kCLAuthorizationStatusAuthorizedAlways:
                break;
            default:
                break;
        }
        [self triggerBlockWithDictionary:self.locationDictionary
                               isSuccess:NO
                                    info:nil
                                   error:error];
        [self triggerBlockWithDictionary:self.geocodeDictionary
                               isSuccess:NO
                                    info:nil
                                   error:error];
        [self endLocation];
    }
}

- (void)triggerBlockWithDictionary:(NSMutableDictionary *)dictionary
                         isSuccess:(BOOL)isSuccess
                              info:(LocationInfo *)info
                             error:(NSError *)error
{
    NSArray *blockArray = [dictionary allValues];
    for (PrivateBlock block in blockArray)
    {
        block(isSuccess,info,error);
    }
    
    [dictionary removeAllObjects];
}

- (void)startReverseGeocoderLocation:(CLLocation *)location
{
    self.isStartReverseGeocoder = NO;
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarksArray, NSError *error) {
        if (placemarksArray)
        {
            NSLog(@"%@",@"反编译成功！");
            
            CLPlacemark *placemark = [placemarksArray objectAtIndex:0];
            
            NSLog(@"编译后 location is %f  %f",placemark.location.coordinate.longitude,placemark.location.coordinate.latitude);
            if (!placemark.administrativeArea && !placemark.locality)
            {
                NSError *error = [NSError errorWithDomain:
                                  @"Reverse geocoder complte but city infomation in the result is empty."
                                                     code:LocationManagerErrorTypeGeocoderResultEmpty
                                                 userInfo:nil];
                
                NSLog(@"error = %@", [error localizedDescription]);
                [self triggerBlockWithDictionary:self.geocodeDictionary
                                       isSuccess:NO
                                            info:nil
                                           error:error];
            }
            else
            {
                AddressInfo *addressInfo = [[AddressInfo alloc] initWithPlacemark:placemark];
                LocationInfo *locationInfo = [[LocationInfo alloc] initWithLocation:location];
                locationInfo.addressInfo = addressInfo;
                
                self.locationInfo = locationInfo;
                
                [self triggerBlockWithDictionary:self.geocodeDictionary
                                       isSuccess:YES
                                            info:locationInfo
                                           error:nil];
                
            }
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            self.isLocating = NO;
            [self endReverseGeocoder];
        }
        else
        {
            if (repeatCount < 2)
            {
                ++repeatCount;
                NSLog(@"%@(%lu)",@"反编译失败，正在重试中...",(unsigned long)repeatCount);
                [self startReverseGeocoderLocation:location];
            }
            else
            {
                repeatCount = 0;
                NSLog(@"%@",@"反编译获得信息为空，反编译失败！");
                [self triggerBlockWithDictionary:self.geocodeDictionary
                                       isSuccess:NO
                                            info:nil
                                           error:error];
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                self.isLocating = NO;
                [self endReverseGeocoder];
            }
        }
    }];
}

- (void)locationManagerDidTimeout{
    [self stopLocationManager];
}

- (void)endLocation{
    [_locationManager stopUpdatingHeading];
    [_locationManager stopUpdatingLocation];
    _locationManager.delegate = nil;
    if (![self allowAppcationLocation])
    {
        _locationManager = nil;
    }
}

- (void)endReverseGeocoder{
    [self.geocoder cancelGeocode];
    self.geocoder = nil;
}

#pragma mark -
#pragma mark ==== CLLocationManagerDelegate ====
#pragma mark -
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
        break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@",@"定位成功！");
    CLLocation *newLocation = (CLLocation *)[locations lastObject];
    //设置经纬度
//    [VJQSetting sharedSettings].longitude = newLocation.coordinate.longitude;
//    [VJQSetting sharedSettings].longitude = newLocation.coordinate.latitude;
    NSLog(@"编译前 longitude latitude  %f  %f",newLocation.coordinate.longitude,newLocation.coordinate.latitude);
    
    LocationInfo *info = [[LocationInfo alloc] initWithLocation:newLocation];
    
    [self triggerBlockWithDictionary:self.locationDictionary
                           isSuccess:YES
                                info:info
                               error:nil];
    
    self.isLocating = NO;
    
    //反编译地址
    if (self.isStartReverseGeocoder && !self.geocoder.geocoding)
    {
        NSLog(@"%@",@"需要获取地址信息，开启反编译操作");
        [self startReverseGeocoderLocation:newLocation];
    }
    else
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    [self endLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",@"回调到didFail函数");
    if (error.code != kCLErrorLocationUnknown)//这个错误系统会自动处理，并尝试再次定位
    {

    }
    NSLog(@"%@",@"定位失败！");
    //发送定位失败手动选择城市通知
     [[NSNotificationCenter defaultCenter] postNotificationName:@"ManuallySelectCity" object:nil];
    
    if (error.code == kCLErrorDenied)
    {
        error = [NSError errorWithDomain:@"Location service did not authorize."
                                    code:LocationManagerErrorTypeAuthorizationDenied
                                userInfo:nil];
    }
    
    [self triggerBlockWithDictionary:self.locationDictionary
                           isSuccess:NO
                                info:nil
                               error:error];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.isLocating = NO;
}





@end
