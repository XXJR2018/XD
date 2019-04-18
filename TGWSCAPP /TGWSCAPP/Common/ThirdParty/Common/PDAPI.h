//
//  PDAPI.h
//  DDGProject
//
//  Created by Cary on 15/2/27.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>



// 发送登录短信接口一（拿到登录SmsTokenID）
static NSString *const kDDGgetSmsToken = @"appMall/smsSend/getSmsToken/kjLogin";
// 发送登录短信接口二（发送登录短信）
static NSString *const kDDGnologin = @"appMall/smsSend/nologin/kjLogin";
// 发送普通短信接口一（拿到SmsTokenID）  请求URL：/appMall/smsSend/getSmsToken/{type}
static NSString *const kDDGgetSmsTokenByType = @"appMall/smsSend/getSmsToken";
// 发送普通短信接口二（发送短信） 请求URL：/appMall/smsSend/login/{type}
static NSString *const kDDGnologinByType = @"appMall/smsSend/login";

// 跳转h5之前，获取xcode
static NSString *const kURLGetXCode = @"appMall/account/cust/info/getXCode";

#pragma mark --- 首页页面相关接口
// 获取首页菜单
static NSString *const kURLqueryCateList = @"appMall/category/queryCateList";
// 获取首页子Tab中各个页面的元素
static NSString *const kURLqueryShowTypeList = @"appMall/home/queryShowTypeList";


#pragma mark ---  商品详情页面相关接口
// 获取商品基本信息
static NSString *const kURLqueryGoodsBaseInfo = @"appMall/goods/queryGoodsBaseInfo";
// 获取商品的附加信息
static NSString *const kURLqueryGoodsDetailInfo = @"appMall/goods/queryGoodsDetailInfo";
// 查询商品SKU展示规格列表 （展示）
static NSString *const kURLquerySkuProList = @"appMall/sku/querySkuProList";
// 查询商品SKU所有列表
static NSString *const kURLquerySkuList = @"appMall/sku/querySkuList";
// 收藏商品，取消商品
static NSString *const kURLaddFavorite = @"appMall/account/cust/favorite/addFavorite";
// 查询更多商品 (按类型查)
static NSString *const kURLqueryTypeMoreInfoList = @"appMall/home/queryTypeMoreInfoList";
// 按名称和条件查询商品详情
static NSString *const kURLqueryGoodsByCondition = @"appMall/goods/queryGoodsByCondition";
// 搜索时，即时匹配的字符
static NSString *const kURLqueryGoodsKey = @"appMall/goodskey/queryGoodsKey";
// 得到商品的分享图片(包含二维码)
static NSString *const kURLgetShareQrcode = @"appMall/goods/getShareQrcode";
// 得到商品的二维码  (只有二维码，没有商品)
static NSString *const kURLgetXcxQrcode = @"appMall/goods/getXcxQrcode";
// 获取所有的商品
static NSString *const kURLqueryGoodsAllList = @"appMall/goods/queryGoodsAllList";


#pragma mark ---- 购物车相关
//  购物车列表
static NSString *const kURLorderCartList = @"appMall/account/orderCart/list";
//  购物车面中，加入购物车
static NSString *const kURLorderCartAdd = @"appMall/account/orderCart/add";
//  修改购物车
static NSString *const kURLorderCartUpdate = @"appMall/account/orderCart/update";
//  删除购物车
static NSString *const kURLorderCartDelete = @"appMall/account/orderCart/delete";
// 购物车页面 的抬头
static NSString *const kURLgetSaleTitle = @"appMall/account/orderCart/getSaleTitle";


#pragma mark ---- 订单详情
//  商品详情页面中，立即购买获取订单详情， 需要调用此接口（相当于下单接口）
static NSString *const kURLsingleOrderInfo = @"appMall/account/commitOrder/singleOrderInfo";
//  购物车页面下单，获取订单详情
static NSString *const kURLbatchOrderInfo = @"appMall/account/commitOrder/batchOrderInfo";
//  提交订单，获取最重要的支付参数 (注意：如果是余额充足，并且选择余额支付， 提交订单后会直接成功)
static NSString *const kURLcommitOrder = @"appMall/account/commitOrder/commitOrder";
// 去支付
static NSString *const kURLgoPay = @"appMall/account/payOrder/goPay";


#pragma mark ---- 退款/售后
// 退款原因
static NSString *const kURLresionList = @"appMall/account/orderRefund/resionList";
// 退款商品列表
static NSString *const kURLrefundGoodsList = @"appMall/account/orderRefund/refundGoodsList";
// 退款商品(申请页面的展示)
static NSString *const kURLselectRefundGoods = @"appMall/account/orderRefund/selectRefundGoods";
// 退款申请
static NSString *const kURLapplyRefund = @"appMall/account/orderRefund/applyRefund";
// 退款申请 (重新申请)
static NSString *const kURLagainApplyRefund = @"appMall/account/orderRefund/againApply";
// 退款/售后列表
static NSString *const kURLrefundList = @"appMall/account/orderRefund/list";
// 退款详情
static NSString *const kURLrefundDetailInfo = @"appMall/account/orderRefund/detailInfo";
// 取消申请
static NSString *const kURcancelApply = @"appMall/account/orderRefund/cancelApply";
// 保存退款物流信息
static NSString *const kURLsaveLogistics = @"appMall/account/orderRefund/saveLogistics";
// 退款详情
static NSString *const kURLqueryLogistics = @"account/orderRefund/queryLogistics";
// 删除订单
static NSString *const kURLdeleteOrder = @"appMall/account/myOrder/deleteOrder";
// 确认收货
static NSString *const kURLconfirmGoods = @"appMall/account/myOrder/confirmGoods";
// 修改地址
static NSString *const kURLupdateOrderAddr = @"appMall/account/myOrder/updateOrderAddr";
// 查询物流信息
static NSString *const kURLlogisticsInfo = @"appMall/account/myOrder/logisticsInfo";
// 查询物流详细信息
static NSString *const kURLlogisticsInfoDtl = @"appMall/account/myOrder/logisticsInfoDtl";
// 售后进度
static NSString *const kURLquerySaleSchedule = @"appMall/account/orderRefund/querySaleSchedule";


#pragma mark   ---  消息相关
// 客户消息列表
static NSString *const kURLmsgList = @"appMall/account/cust/message/msgList";
// 修改为已读
static NSString *const kURLupdateShow = @"appMall/account/cust/message/updateShow";


#pragma mark   ---  登录弹框相关
// 首页获取弹框
static NSString *const kURLpopups = @"appMall/account/cust/info/popups";
// 弹框后领取奖励接口
static NSString *const kURLgetCustReward = @"appMall/account/cust/activity/getCustReward";


#pragma mark   ---  评价相关 （部分接口）
// 商品评价的标签
static NSString *const kURLqueryGoodsLable = @"appMall/account/orderComment/queryGoodsLable";
// 商品评论列表
static NSString *const kURLqueryAllCommList = @"appMall/account/orderComment/queryAllCommList";

#pragma mark   ---  聊天相关 （部分接口）
// 获取所有热门问题
static NSString *const kURLqueryqueryHotQuestion = @"appMall/kf/manager/queryHotQuestion";

/*!
 @brief 管理所有接口URL
 */
@interface PDAPI : NSObject

/*!
 @brief     服务器地址
 @return    base url string
 */
+ (NSString *)getBaseUrlString;


/*!
 @brief     服务器地址 （业务）
 @return    base url string
 */
+ (NSString *)getBusiUrlString;

/*!
 @brief     跳转h5路径
 @return    NSString
 */
+ (NSString *)WXSysRouteAPI;

#pragma mark === Function
/*!
 @brief     版本检测
 @return    NSString
 */
+ (NSString *)getCheckVersionAPI;

/*!
 @brief     上传材料、图片
 @return    NSString
 */
+ (NSString *)getSendFileAPI;


#pragma mark 登陆
/*!
 @brief    验证码登陆
 @return    NSString
 */
+ (NSString *)userKJLoginInfoAPI;

/*!
 @brief   微信登陆
 @return    NSString
 */
+ (NSString *)userWXLoginInfoAPI;

/*!
 @brief   获取用户信息，需要登录
 @return    NSString
 */
+ (NSString *)getUserBaseInfoAPI;




@end





