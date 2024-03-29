import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

enum TypeNotify{
 ApproveRequest,Transfer,Late,ApproveDone,ApproveRefuse,InvoiceDeleted,Install
}
const kMainColor = Colors.lightBlue;//Color(0xfff2c131);
const kWhiteColor = Colors.white;
const kLogo = 'assest/images/logo.png';
const kUnActiveColor=Colors.lightBlueAccent;//Color(0xdff4dc8c);
const kfontfamily='Pacifico';
const kfontfamily2='Cairo';
const kfontfamily3='Amiri';
const url='http://smartcrm.ws/aya/api/';
const urlimage='http://smartcrm.ws/aya/api/imagesApp/profile/';
const urlfile='http://smartcrm.ws/aya/api/imagesApp/filesinvoice/';
const urlfilelogo='http://smartcrm.ws/aya/api/imagesApp/logoclient/';
const kKeepMeLoggedIn="loginstate";
const String hintnamefilter=   "المؤسسة ,العميل , رقم الهاتف....";
const Ktoast=Color(0xfff2c131);
const String messageNoData='لا يوجد بيانات';
List<String> listtext=[
  'مشرف مبيعات',
  'موظف مبيعات',
  'إدارة عناية بالعملاء',
  'موظف دعم',
  'مدير دعم',
  'إدارة عليا',
  'الإدارة المالية',
  'ادارة التحصيل',
  'إدارة العمليات'];