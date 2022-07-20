//

import 'package:charts_flutter/flutter.dart' as fl;
import 'package:crm_smart/api/api.dart';
import 'package:crm_smart/function_global.dart';
import 'package:crm_smart/model/chartmodel.dart';
import 'package:crm_smart/model/invoiceModel.dart';
import 'package:crm_smart/model/usermodel.dart';
import 'package:crm_smart/provider/selected_button_provider.dart';
import 'package:crm_smart/ui/screen/client/profileclient.dart';
import 'package:crm_smart/ui/widgets/client_widget/cardAllclient.dart';
import 'package:crm_smart/ui/widgets/custom_widget/rowtitle.dart';
import 'package:crm_smart/ui/widgets/custom_widget/text_uitil.dart';
import 'package:crm_smart/view_model/privilge_vm.dart';
import 'package:crm_smart/view_model/user_vm_provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as myui;
import '../../../constants.dart';

class delayafterinstall extends StatefulWidget {
  const delayafterinstall({Key? key}) : super(key: key);

  @override
  State<delayafterinstall> createState() => _delayafterinstallState();
}

class _delayafterinstallState extends State<delayafterinstall> {
  static const secondaryMeasureAxisId = 'secondaryMeasureAxisId';
  List<InvoiceModel> listInvoicesAccept=[];
  List<BarModel> salesresult = [];
  List<BarModel> salestempdataclientresult = [];
  List<DataRow> rowsdata = [];
  String iduser='';
  bool loading = true;
  String type = 'userSum';
  String typeproduct = 'الكل';
  double totalval = 0;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_)async{
      Provider.of<selected_button_provider>(context,listen: false)
          .selectValuebarsalestype(0);
      Provider.of<selected_button_provider>(context,listen: false)
          .selectValuebarsales(0);
      Provider.of<user_vm_provider>(context,listen: false).changevalueuser(null);

    });
    super.initState();
    getData();
  }

  Future<void> getData() async {
    // if(_selectedDateto!=DateTime(1, 1, 1)&&_selectedDatefrom!=DateTime(1, 1, 1)
    // &&_selectedDate!=DateTime(1, 1, 1)&&_selectedDatemonth!=DateTime(1, 1, 1)
    // )

    // if(_se)
    setState(() {
      loading = true;
    });
    List<BarModel> tempdata = [];
    rowsdata.clear();
    UserModel usermodel = Provider
        .of<user_vm_provider>(context, listen: false)
        .currentUser;
    String fkcountry = usermodel.fkCountry.toString();
    // String iduser = usermodel.idUser.toString();
    // String idregoin = usermodel.fkRegoin.toString();

    String paramprivilge = '';
    if(iduser!='')  paramprivilge='&id_user=${iduser}';
    // if(Provider.of<privilge_vm>(context,listen: false)
    //     .checkprivlge('80')==true )
    //   paramprivilge='&id_user=${iduser}';
    // else {
    //   if(Provider.of<privilge_vm>(context,listen: false)
    //       .checkprivlge('81')==true )
    //     paramprivilge='&id_regoin=${idregoin}';
    // }
    // if(Provider.of<privilge_vm>(context,listen: false).checkprivlge('82')==true ||
    //     Provider.of<privilge_vm>(context,listen: false)
    //         .checkprivlge('80')==true||Provider.of<privilge_vm>(context,listen: false)
    //     .checkprivlge('81')==true){
    var data;
print(paramprivilge);
print(type);
    switch (type) {
      case "userSum":
        data = await Api().post(
            url: url +
                "reports/delayafterinstall.php?fk_country=$fkcountry$paramprivilge",
            body: {'type': type});
        break;
        case "date":
        data = await Api().post(
            url: url +
                "reports/delayafterinstall.php?fk_country=$fkcountry&from=${_selectedDatefrom.toString()}&to=${_selectedDateto.toString()}$paramprivilge",
            body: {'type': type});
        break;
    }

    //userSum
    totalval = 0;
    listInvoicesAccept=[];
    for (int i = 0; i < data.length; i++) {
      listInvoicesAccept.add(InvoiceModel.fromJson(data[i]));
    }

    print('length result'+listInvoicesAccept.length.toString());
    // for(int i=0;i<salesresult.length;i++)
    setState (() {

      salesresult = tempdata;
      // salestempdataclientresult = tempdataclient;
      loading = false;
    });
  }


  DateTime _selectedDate = DateTime(1, 1, 1);
  DateTime _selectedDatemonth = DateTime(1, 1, 1);
  DateTime _selectedDatefrom = DateTime(1, 1, 1);
  DateTime _selectedDateto = DateTime(1, 1, 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("تقرير التأخير عن التركيب للعملاء "),
      ),
      body:
      SafeArea(
        child: Directionality(
          textDirection: myui.TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8,),
                    child:
                    Consumer<user_vm_provider>(
                      builder: (context, cart, child){
                        return  DropdownSearch<UserModel>(
                          mode: Mode.DIALOG,
                          // label: " الموظف ",
                          //hint: 'الموظف',
                          //onFind: (String filter) => cart.getfilteruser(filter),
                          filterFn: (user, filter) => user!.getfilteruser(filter!),
                          //compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
                          // itemAsString: (UserModel u) => u.userAsStringByName(),
                          items: cart.userall,
                          itemAsString: (u) => u!.userAsString(),
                          onChanged: (data) {
                            iduser=data!.idUser!;
                            // idregoin='';
                            cart.changevalueuser(data);
                            getData();
                            //filtershow();
                          } ,
                          selectedItem: cart.selecteduser,
                          showSearchBox: true,
                          dropdownSearchDecoration:
                          InputDecoration(
                            //filled: true,
                            isCollapsed: true,
                            hintText: 'الموظف',
                            alignLabelWithHint: true,
                            fillColor:  Colors.grey.withOpacity(0.2),
                            //labelText: "choose a user",
                            contentPadding: EdgeInsets.all(0),
                            //contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            // focusedBorder: OutlineInputBorder(
                            //     borderRadius: BorderRadius.circular(10),
                            //     borderSide: const BorderSide(color: Colors.white)),
                            border:
                            UnderlineInputBorder(
                                borderSide: const BorderSide(  color: Colors.grey)
                            ),
                            // OutlineInputBorder(
                            //     borderRadius: BorderRadius.circular(10),
                            //     borderSide: const BorderSide( color: Colors.white)),
                          ),
                          // InputDecoration(border: InputBorder.none),

                        );

                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0,left: 15,top: 8,bottom: 8),
                    child: Row (
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('from'),
                              TextFormField(
                                validator: (value) {
                                  if (_selectedDatefrom == DateTime(1, 1, 1)) {
                                    return 'يرجى تعيين التاريخ ';
                                  }
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.date_range,
                                    color: kMainColor,
                                  ),
                                  hintStyle: const TextStyle(
                                      color: Colors.black45,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  hintText: _selectedDatefrom == DateTime(1, 1, 1)
                                      ? 'from' //_currentDate.toString()
                                      : DateFormat('yyyy-MM-dd').format(_selectedDatefrom),
                                  //_invoice!.dateinstall_task.toString(),
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                ),
                                readOnly: true,
                                onTap: () {
                                  _selectDatefrom(context, DateTime.now());


                                  // _selectDate(context, DateTime.now());
                                },
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            children: [
                              Text('to'),
                              TextFormField(
                                validator: (value) {
                                  if (_selectedDateto == DateTime(1, 1, 1)) {
                                    return 'يرجى تعيين التاريخ ';
                                  }
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.date_range,
                                    color: kMainColor,
                                  ),
                                  hintStyle: const TextStyle(
                                      color: Colors.black45,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  hintText: _selectedDateto == DateTime(1, 1, 1)
                                      ? 'to' //_currentDate.toString()
                                      : DateFormat('yyyy-MM-dd').format(_selectedDateto),
                                  //_invoice!.dateinstall_task.toString(),
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                ),
                                readOnly: true,
                                onTap: () {
                                  _selectDateto(context, DateTime.now());
                                  // if(_selectedDateto!=DateTime(1, 1, 1)&&_selectedDatefrom!=DateTime(1, 1, 1))
                                  //   getData();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        )),
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2, left: 8, right: 8, bottom: 2),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          title: TextField(
                            textInputAction: TextInputAction.search,
                            onChanged: (pattern) async {
                              String searchKey =pattern;
                              List<InvoiceModel> clientlistsearch=[];
                              if(pattern.isNotEmpty ) {
                                listInvoicesAccept.forEach((element) {
                                  if (element.name_enterprise!.contains(searchKey, 0)
                                      || element.nameClient!.contains(searchKey, 0)
                                      || element.mobile!.contains(searchKey, 0))
                                    clientlistsearch.add(element);
                                });
                             setState(() {
                               listInvoicesAccept = List.from(clientlistsearch);
                             });
                              } else getData();
                            },
                            decoration: InputDecoration(
                              hintText: 'المؤسسة , العميل ....',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: loading
                        ? CircularProgressIndicator()
                        : Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        // scrollDirection: Axis.horizontal,
                          children:[

                            Container(
                              height: MediaQuery.of(context).size.height*0.65,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: listInvoicesAccept.length,
                                    itemBuilder: (context, index) {

                                      return SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(30)),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                  offset: Offset(1.0, 1.0),
                                                  blurRadius: 8.0,
                                                  color: Colors.black87.withOpacity(0.2),
                                                ),
                                              ],
                                              color: Colors.white30,
                                            ),
                                            child: Center(
                                              child: InkWell(
                                                onTap: (){//pushReplacement
                                                  Navigator.push(context,
                                                      MaterialPageRoute(builder:
                                                          (context) =>
                                                          ProfileClient(
                                                            idclient: listInvoicesAccept[index].fkIdClient,)));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                  ),
                                                  //height: 70,//MediaQuery.of(context).size.height*0.15,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Flex(
                                                      direction: Axis.vertical,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  listInvoicesAccept[index].name_regoin.toString(),
                                                                  style: TextStyle(
                                                                    //fontWeight: FontWeight.bold,
                                                                      fontSize: 12,
                                                                      fontFamily: kfontfamily2,
                                                                      color: kMainColor),
                                                                ),
                                                                Text(
                                                                  listInvoicesAccept[index].hoursdelayinstall.toString()=='-1'?
                                                                  'لم يتم التركيب بعد':
                                                              ' ساعة '+    listInvoicesAccept[index].hoursdelayinstall.toString(),
                                                                  style: TextStyle(
                                                                      fontSize: 12,
                                                                      // fontWeight: FontWeight.bold,
                                                                      fontFamily: kfontfamily2,
                                                                      color: kMainColor),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: [
                                                                Text(
                                                                  listInvoicesAccept[index].name_enterprise.toString(),
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 12,
                                                                    fontFamily: kfontfamily2,
                                                                  ),
                                                                ),
                                                                // Text(
                                                                //   itemapprove.nameUser.toString(),
                                                                //   style: TextStyle(fontFamily: kfontfamily2),
                                                                // ),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            )

                          ] ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDatefrom(BuildContext context, DateTime currentDate) async {
    DateTime? pickedDate = await showDatePicker(

        context: context,
        currentDate: currentDate,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(3010));
    if (pickedDate != null)
      setState(() {
        // Navigator.pop(context);
        _selectedDatefrom = pickedDate;
        print(_selectedDatefrom.toString());
        if(_selectedDateto!=DateTime(1, 1, 1)&&_selectedDatefrom!=DateTime(1, 1, 1))
          getData();
      });
  }
  Future<void> _selectDateto(BuildContext context, DateTime currentDate) async {
    DateTime? pickedDate = await showDatePicker(
      // initialEntryMode: DatePickerEntryMode.calendarOnly,
      // initialDatePickerMode: DatePickerMode.year,
        context: context,
        currentDate: currentDate,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(3010));
    if (pickedDate != null)
      setState(() {
        // Navigator.pop(context);
        _selectedDateto = pickedDate;
        print(_selectedDateto.toString());
        if(_selectedDateto!=DateTime(1, 1, 1)&&_selectedDatefrom!=DateTime(1, 1, 1))
          getData();
      });
  }
}
