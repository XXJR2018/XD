//
//  LocationManager.h
//  XXJR
//
//  Created by xxjr02 on 16/1/11.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - AddressInfo

@class CLPlacemark;


@interface AddressInfo : NSObject

//定位地址信息，跟CLPlacemark里面的数据一一对应。

/**
 *	eg. Apple Inc.
 */
@property (nonatomic, copy) NSString *nameString;
/**
 *	street address, eg. 1 Infinite Loop
 */
@property (nonatomic, copy) NSString *thoroughfareString;
/**
 *	eg. 1
 */
@property (nonatomic, copy) NSString *subThoroughfareString;
/**
 *	city, eg. Cupertino
 */
@property (nonatomic, copy) NSString *localityString;
/**
 *	neighborhood, common name, eg. Mission District
 */
@property (nonatomic, copy) NSString *subLocalityString;
/**
 *	state, eg. CA
 */
@property (nonatomic, copy) NSString *administrativeAreaString;
/**
 *	county, eg. Santa Clara
 */
@property (nonatomic, copy) NSString *subAdministrativeAreaString;
/**
 *	zip code, eg. 95014
 */
@property (nonatomic, copy) NSString *postalCodeString;
/**
 *	eg. US
 */
@property (nonatomic, copy) NSString *ISOcountryCodeString;
/**
 *	eg. United States
 */
@property (nonatomic, copy) NSString *countryString;
/**
 *	eg. Lake Tahoe
 */
@property (nonatomic, copy) NSString *inlandWaterString;
/**
 *	eg. Pacific Ocean
 */
@property (nonatomic, copy) NSString *oceanString;
/**
 *	eg. Golden Gate Park
 */
@property (nonatomic, retain) NSArray *areasOfInterestArray;
/*
 *  addressDictionary
 *
 *  Discussion:
 *    This dictionary can be formatted as an address using ABCreateStringWithAddressDictionary,
 *    defined in the AddressBookUI framework.
 */
@property (nonatomic, retain) NSDictionary *addressDictionary;

/**
 *	根据placemark信息初始化实例
 *
 *	@param	placemark	反编译地址后的地址信息
 *
 *	@return	AddressInfo实例
 */
- (id)initWithPlacemark:(CLPlacemark *)placemark;

@end


#pragma mark - LocationInfo

@class CLLocation;

@interface LocationInfo : NSObject
//定位坐标信息

/**
 *	纬度
 */
@property (nonatomic, assign) double latitude;
/**
 *	经度
 */
@property (nonatomic, assign) double longitude;
/**
 *	海拔高度
 */
@property (nonatomic, assign) double altitude;
/**
 *	水平范围的定位精度，当定位坐标无效的时候为负值。
 */
@property (nonatomic, assign) double horizontalAccuracy;
/**
 *	垂直范围的定位精度，当定位坐标无效的时候为负值。
 */
@property (nonatomic, assign) double verticalAccuracy;
/**
 *	地址信息。只做定位操作或者反编译地址失败，该值为空。
 */
@property (nonatomic, retain) AddressInfo *addressInfo;

/**
 *	根据CLLocation信息初始化
 *
 *	@param	location	定位信息
 *
 *	@return	LocationInfo实例
 */
- (id)initWithLocation:(CLLocation *)location;

@end




#pragma mark - LocationManager

typedef void (^PrivateBlock)(BOOL isFinish,LocationInfo *info,NSError *error);

/**
 *	定位错误类型
 */
typedef enum
{
    //用户关闭了定位或者用户不允许app的定位服务
    LocationManagerErrorTypeAuthorizationDenied = 100,
    //系统对定位服务有限制，该状态用户无法改变。比如开启了家长指引模式
    LocationManagerErrorTypeAuthorizationRestricted,
    
    //反编译地址成功，但是返回的地址信息里面administrativeArea和locality都为空
    LocationManagerErrorTypeGeocoderResultEmpty,
    //主动取消了定位操作，调用了stopLocationManager方法
    LocationManagerErrorTypeCancelLocation
}LocationManagerErrorType;


@interface LocationManager : NSObject

/**
 *	处理定位服务没开时
 */
@property (nonatomic, assign) BOOL showLocationCloseAlert;

/**
 *	超时时间
 */
@property (assign, nonatomic) NSTimeInterval timeoutSecond;

/**
 *	最后一次定位所获取到的信息，仅在进行反编译地址获取到地址信息的时候才会去更新这个数据。定位不成功不会抹掉之前的信息
 */
@property (retain, nonatomic) LocationInfo *locationInfo;

/**
 *	单例方法，返回定位管理器的实例
 *
 *	@return	定位管理器
 */
+ (LocationManager *)shareManager;

/**
 *	开启定位操作，纯定位功能，不会反编译地址。
 *
 *	@param	block	定位完成后会调用该block，作为回调使用。
 *	@param	key	block存放时候的key，每个地方使用的key不能重复，重复会覆盖。
 */
- (void)startLocationWithBlock:(void (^)(BOOL isFinish,LocationInfo *info,NSError *error))block
                      blockKey:(NSString *)key;

/**
 *	开启定位并反编译地址，获取地址信息。地址信息会以City这个model
 *
 *	@param	block	反编译地址完成后会调用该block，作为回调使用。
 *	@param	key	block存放时候的key，每个地方使用的key不能重复，重复会覆盖。
 */
- (void)getLocationInformationWithBlock:(void (^)(BOOL isFinish,LocationInfo *info,NSError *error))block
                               blockKey:(NSString *)key;

/**
 *	停止一切定位相关操作，调用该方法会强制让location进入失败状态。
 */
- (void)stopLocationManager;

/**
 *	将定位信息转换成字符串输出
 *
 *	@param	dic	定位信息
 *
 *	@return	字符串
 */
- (NSString *)getAddressWithDictionary:(NSDictionary *)dic;


- (void)getUserLocationSuccess:(Block_Void)successBlock failedBlock:(Block_Int)failedBlock;



@end
