
import 'package:charts_flutter/flutter.dart' as fl;
import 'package:crm_smart/api/api.dart';
import 'package:crm_smart/function_global.dart';
import 'package:crm_smart/model/chartmodel.dart';
import 'package:crm_smart/model/usermodel.dart';
import 'package:crm_smart/provider/selected_button_provider.dart';
import 'package:crm_smart/ui/widgets/custom_widget/rowtitle.dart';
import 'package:crm_smart/ui/widgets/custom_widget/text_uitil.dart';
import 'package:crm_smart/view_model/privilge_vm.dart';
import 'package:crm_smart/view_model/regoin_vm.dart';
import 'package:crm_smart/view_model/user_vm_provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as myui;
import '../../../constants.dart';

class salesproduct extends StatefulWidget {
  const salesproduct({Key? key}) : super(key: key);

  @override
  State<salesproduct> createState() => _salesproductState();
}
class _salesproductState extends State<salesproduct> {
  static const secondaryMeasureAxisId = 'secondaryMeasureAxisId';

  List<BarModel> salesresult = [];
  List<BarModel> salestempdataclientresult = [];
  List<DataRow> rowsdata=[];
  late String iduser ='0';
  late String idregoin='0';
  bool loading = true;
  String type = 'dateyear';
  String typeproduct = 'الكل';
  double totalval=0;
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedDatemonth = DateTime.now();
  DateTime _selectedDatefrom = DateTime.now();
  DateTime _selectedDateto = DateTime.now();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      Provider.of<selected_button_provider>(context,listen: false)
          .selectValuebarsalestype(0);
      Provider.of<selected_button_provider>(context,listen: false)
          .selectValuebarsales(0);
      Provider.of<user_vm_provider>(context,listen: false).changevalueuser(null);

    });
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_)async {
    // if(  Provider.of<privilge_vm>(context,listen: false)
    //       .checkprivlge('89')==true)
    //    type='userSum';
    // if(  Provider.of<privilge_vm>(context,listen: false)
    //       .checkprivlge('90')==true)
    //    type='userSum';
    // if(  Provider.of<privilge_vm>(context,listen: false)
    //       .checkprivlge('89')==true)
    //    type='userSum';
    // });
      getData();
  }

  Future<void> getData() async {

    setState(() {
      loading=true;
    });
    List<BarModel> tempdata = [];
    rowsdata.clear();
    UserModel usermodel=Provider.of<user_vm_provider>(context, listen: false)
        .currentUser;
    String fkcountry = usermodel.fkCountry.toString();
    if(iduser=='0')
    iduser=usermodel.idUser.toString();

    if(idregoin=='0')
    idregoin=usermodel.fkRegoin.toString();

    String paramprivilge='';
    if(Provider.of<privilge_vm>(context,listen: false)
        .checkprivlge('87')==true )
      paramprivilge='&id_user=${iduser}';

    if(Provider.of<privilge_vm>(context,listen: false)
        .checkprivlge('90')==true )
      paramprivilge='&id_regoin=${idregoin}';

    if(Provider.of<privilge_vm>(context,listen: false)
        .checkprivlge('89')==true ) {

      if(iduser==''&&idregoin!='')
      paramprivilge='&id_regoin=${idregoin}';

      if(iduser!=''&&idregoin=='')
        paramprivilge='&id_user=${iduser}';
    }
    if(Provider.of<privilge_vm>(context,listen: false)
        .checkprivlge('87')==true ||
       Provider.of<privilge_vm>(context,listen: false)
        .checkprivlge('89')==true ||
       Provider.of<privilge_vm>(context,listen: false)
        .checkprivlge('90')==true ) {
      String params='';
      if(typeproduct=='أجهزة') params='&product=0';
      if(typeproduct=='برامج') params='&product=1';
      var data;
      switch (type) {
        case "userSum":
          data = await Api().post(
              url: url + "reports/sales_product.php?fk_country=$fkcountry$paramprivilge$params",
              body: {'type': type});
          break;
        case "dateyear":
          data = await Api().post(
              url: url +
                  "reports/sales_product.php?fk_country=$fkcountry&year=${_selectedDate.year.toString()}$paramprivilge$params",
              body: {'type': type});
          break;
        case "datemonth":
          data = await Api().post(
              url: url +
                  "reports/sales_product.php?fk_country=$fkcountry&month=${_selectedDatemonth.toString()}$paramprivilge$params",
              body: {'type': type});
          break;
        case "datedays":
          data = await Api().post(
              url: url +
                  "reports/sales_product.php?fk_country=$fkcountry&from=${_selectedDatefrom.toString()}&to=${_selectedDateto.toString()}$paramprivilge$params",
              body: {'type': type});
          break;
      }
      List<BarModel> tempdataclient = [];
      totalval=0;rowsdata=[];
      for (int i = 0; i < data.length; i++) {
        tempdata.add(BarModel.fromJson(data[i]));
        print(tempdata[i].y);
        totalval+=tempdata[i].y;
        rowsdata.add(
            DataRow(
              cells: <DataCell>[
                DataCell( SizedBox(
                  width: 15.0,
                  height: 15.0,
                  child:  DecoratedBox(
                    decoration:  BoxDecoration(
                        color: tempdata[i].colorval
                    ),
                  ),
                )),
                DataCell(
                  TextUtilis(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  textstring:tempdata[i].x,//getnamelong(tempdata[i].x),
                  underline: TextDecoration.none,
                )),
                DataCell( 
                    TextUtilis(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  textstring: tempdata[i].y.toStringAsFixed(2),
                  underline: TextDecoration.none,
                )),
                DataCell( TextUtilis(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                  textstring: tempdata[i].countclient.toString(),
                  underline: TextDecoration.none,
                )),
              ],
            ));
      }}
    setState(() {
      salesresult = tempdata;
      loading = false;
    });
  }

  List<charts.Series<BarModel, String>> _createSampleData() {
    return [
      charts.Series<BarModel, String>(
        data: salesresult,
        id: 'المبيعات',

        // colorFn: (_, __) =>
        //
        //     // charts.ColorUtil.fromDartColor(
        //     // //    Colors.primaries[Random().nextInt(Colors.primaries.length)]
        //     //     Colors.primaries[Random().nextInt(Colors.primaries.length)]
        //     // ),
        //     charts.MaterialPalette.teal.shadeDefault,
        colorFn: (BarModel bar,_) =>charts.ColorUtil.fromDartColor(bar.colorval),
        // charts.MaterialPalette.indigo.shadeDefault,
        domainFn: (BarModel genderModel, _) =>getnameshort(genderModel.x),
        measureFn: (BarModel genderModel,__) =>  genderModel.y,
        // measureFormatterFn: (BarModel genderModel,_) => ,
        labelAccessorFn:  (BarModel row, __) => '${row.y}',
        fillPatternFn: (_,__)=>charts.FillPatternType.solid,
        // insideLabelStyleAccessorFn:
        // displayName: 'll',
      ),
      //   charts.Series<BarModel, String>(
      //     data: salesresult,
      //     id: 'العملاء',
      //     colorFn:   (_, __) =>
      //         // charts.ColorUtil.fromDartColor(
      //         //     Colors.primaries[Random().nextInt(Colors.primaries.length)]),
      //     //Colors.primaries[Random().nextInt(Colors.primaries.length)],//
      //      charts.MaterialPalette.blue.shadeDefault,//charts.MaterialPalette.indigo.shadeDefault,
      //     domainFn:  (BarModel genderModel, _) => genderModel.x,
      //     measureFn: (BarModel genderModel, _) => genderModel.y,
      //     displayName: "Income",
      // )..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(" تقارير مبيعات المنتجات"),
      ),
      body:
      SafeArea(
        child: Directionality(
          textDirection: myui.TextDirection.rtl,
          child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0,bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Consumer<selected_button_provider>(
                          builder: (context, selectedProvider, child) {
                            return GroupButton(
                                controller: GroupButtonController(
                                  selectedIndex: selectedProvider.isbarsales,
                                ),
                                options: GroupButtonOptions(
                                    buttonWidth: 75, borderRadius: BorderRadius.circular(10)),
                                buttons: ['سنوي', 'شهري', 'يومي'],
                                onSelected: (_,index, isselected) {
                                  print(index);
                                  switch(index){
                                    case 0:
                                      type='dateyear';
                                      if(_selectedDate != DateTime(1, 1, 1) )
                                        getData();
                                      break;
                                    case 1:
                                      type='datemonth';
                                      if(_selectedDatemonth != DateTime(1, 1, 1) )
                                        getData();
                                      break;
                                    case 2:
                                      type='datedays';
                                      if(_selectedDatefrom != DateTime(1, 1, 1)&& _selectedDateto != DateTime(1, 1, 1))
                                        getData();
                                      break;

                                  }


                                  // datedays
                                  //setState(() {
                                  //typeinstallController=index.toString();
                                  selectedProvider.selectValuebarsales(index);
                                  //  });
                                });
                          }),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Provider.of<privilge_vm>(context,listen: true)
                        .checkprivlge('89')==true?
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0,right: 8),
                        child: Consumer<regoin_vm>(
                          builder: (context, cart, child){
                            return
                              DropdownButton(
                                isExpanded: true,
                                hint: Text("الفرع"),
                                items: cart.listregoinfilter.map((level_one) {
                                  return DropdownMenuItem(

                                    child: Text(level_one.name_regoin), //label of item
                                    value: level_one.id_regoin, //value of item
                                  );
                                }).toList(),
                                value:cart.selectedValueLevel,
                                onChanged:(value) {
                                  //  setState(() {
                                  cart.changeVal(value.toString());
                                   idregoin=value.toString();
                                   // iduser='';
                                   getData();
                                },
                              );
                          },
                        ),
                      ),
                    )
                        :Container(),
                    Expanded(
                      child:
                      Provider.of<privilge_vm>(context,listen: true)
                          .checkprivlge('89')==true||
                          Provider.of<privilge_vm>(context,listen: true)
                              .checkprivlge('90')==true ? //user
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
                      ):Container(),
                    ),
                  ],
                ),
                Provider.of<selected_button_provider>(context, listen: true)
                    .isbarsales == 0 ?
                TextFormField(
                  validator: (value) {
                    if (_selectedDate == DateTime(1, 1, 1)) {
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
                    hintText: _selectedDate == DateTime(1, 1, 1)
                        ? 'السنة' //_currentDate.toString()
                        : DateFormat('yyyy').format(_selectedDate),
                    //_invoice!.dateinstall_task.toString(),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                  ),
                  readOnly: true,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Select Year"),
                          content: Container(
                            // Need to use container to add size constraint.
                            width: 300,
                            height: 300,
                            child: YearPicker(
                              firstDate: DateTime(DateTime.now().year - 3, 1),
                              lastDate:
                              DateTime(DateTime.now().year + 100, 1),
                              initialDate: DateTime.now(),
                              // save the selected date to _selectedDate DateTime variable.
                              // It's used to set the previous selected date when
                              // re-showing the dialog.
                              selectedDate: _selectedDate,
                              onChanged: (DateTime dateTime) {
                                setState(() {
                                  _selectedDate = dateTime;
                                });

                                // close the dialog when year is selected.
                                Navigator.pop(context);
                                getData();

                                // Do something with the dateTime selected.
                                // Remember that you need to use dateTime.year to get the year
                              },
                            ),
                          ),
                        );
                      },
                    );

                    // _selectDate(context, DateTime.now());
                  },
                )
                    : Provider.of<selected_button_provider>(context, listen: true)
                    .isbarsales == 1
                    ? Row(
                      children: [
                        Flexible(
                  child: TextFormField(
                        validator: (value) {
                          if (_selectedDatemonth == DateTime(1, 1, 1)) {
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
                          hintText: _selectedDatemonth == DateTime(1, 1, 1)
                              ? 'الشهر' //_currentDate.toString()
                              : DateFormat('yyyy-MM').format(_selectedDatemonth),
                          //_invoice!.dateinstall_task.toString(),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                        ),
                        readOnly: true,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Select month"),
                                content: Container(
                                  // Need to use container to add size constraint.
                                  width: 300,
                                  height: 300,
                                  child: CalendarDatePicker(
                                    initialDate: DateTime(DateTime.now().year ,1),
                                    firstDate: DateTime(DateTime.now().year-100, 1),
                                    lastDate:
                                    DateTime(DateTime.now().year+100,1),
                                    // : DateTime.now(),
                                    // save the selected date to _selectedDate DateTime variable.
                                    // It's used to set the previous selected date when
                                    // re-showing the dialog.
                                    currentDate:DateTime.now(), //_selectedDatemonth,
                                    onDateChanged: (DateTime dateTime) {
                                      setState(() {
                                        _selectedDatemonth = dateTime;
                                      });

                                      print(_selectedDatemonth);
                                      // close the dialog when year is selected.
                                      Navigator.pop(context);
                                      getData();

                                      // Do something with the dateTime selected.
                                      // Remember that you need to use dateTime.year to get the year
                                    },
                                  ),
                                ),
                              );
                            },
                          );

                          // _selectDate(context, DateTime.now());
                        },
                  ),
                ),
                      ],
                    ): Provider.of<selected_button_provider>(context, listen: true)
                    .isbarsales == 2
                    ? Row (
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
                              // _selectDate(context, DateTime.now());
                            },
                          ),
                        ],
                      ),
                    ),
                  ],): Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Consumer<selected_button_provider>(
                          builder: (context, selectedProvider, child) {
                            return GroupButton(
                                controller: GroupButtonController(
                                  selectedIndex: selectedProvider.isbarsalestype,
                                ),
                                options: GroupButtonOptions(
                                    buttonWidth: 110,
                                    borderRadius: BorderRadius.circular(10)),
                                buttons: ['الكل', 'أجهزة', 'برامج'],
                                onSelected: (_,index, isselected) {

                                  print(index);
                                  switch(index){
                                    case 0:
                                      typeproduct = 'الكل';
                                      break;
                                    case 1:
                                      typeproduct = 'أجهزة';
                                      break;
                                    case 2:
                                      typeproduct = 'برامج';
                                      break;

                                  }
                                  if(_selectedDateto!=DateTime(1, 1, 1)&&_selectedDatefrom!=DateTime(1, 1, 1)
                                      ||_selectedDate!=DateTime(1, 1, 1)||_selectedDatemonth!=DateTime(1, 1, 1)
                                  )
                                    getData();
                                  //setState(() {
                                  //typeinstallController=index.toString();
                                  selectedProvider.selectValuebarsalestype(index);
                                  //  });
                                });
                          }),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: loading
                        ? CircularProgressIndicator()
                        : Padding(
                      padding: const EdgeInsets.only(top: 35.0),
                      child: SingleChildScrollView(
                        child: Column(
                          // scrollDirection: Axis.horizontal,
                            children:[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('إجمالي المبيعات'),
                                  Text(
                                      totalval.toStringAsFixed(2)),
                                ],
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height*0.75, //BarChart
                               child: charts.PieChart(
                                 _createSampleData(),
                                 // barRendererDecorator: new charts.BarLabelDecorator<String>(),
                                 // barGroupingType: charts.BarGroupingType.grouped,
                                 animate: true,
                                 // barRendererDecorator: (
                                 //     charts.BarLabelDecorator<String>(
                                 //       insideLabelStyleSpec: fl.TextStyleSpec(
                                 //           fontSize: 12, color: fl.Color.black),
                                 //       labelPosition: fl.BarLabelPosition.inside,
                                 //       labelAnchor:fl. BarLabelAnchor.middle,
                                 //     )),
                                 // vertical: false,
                                 // barGroupingType: charts.BarGroupingType.grouped,
                                 // defaultRenderer: charts.BarRendererConfig(
                                 //   groupingType: charts.BarGroupingType.grouped,
                                 //   strokeWidthPx: 1.0,
                                 // ),
                                 /*domainAxis: charts.OrdinalAxisSpec(
                                   renderSpec: charts.GridlineRendererSpec(),
                                 ),*/
                                 // Set a bar label decorator.
                                 // Example configuring different styles for inside/outside:

                                 // barRendererDecorator: new charts.BarLabelDecorator<String>(),
                                 // // Hide domain axis.
                                 // domainAxis:
                                 // new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),

                                 // behaviors: [
                                 //      new charts.SeriesLegend(
                                 //
                                 //      )
                                 //    // new charts.DatumLegend(//SeriesLegend
                                 //    //   outsideJustification:
                                 //    //       charts.OutsideJustification.start,
                                 //    //   horizontalFirst: false,
                                 //    //   desiredMaxRows: 2,
                                 //    //   cellPadding: new EdgeInsets.only(
                                 //    //       right: 4.0, bottom: 4.0, top: 4.0,left: 10),
                                 //    //   entryTextStyle: charts.TextStyleSpec(
                                 //    //       color: charts.MaterialPalette.purple.shadeDefault,
                                 //    //       fontFamily: 'Georgia',
                                 //    //       fontSize: 18),
                                 //    // )
                                 // ],
                                 //  defaultRenderer: new charts.ArcRendererConfig(
                                 //      arcWidth: 100,
                                 //      arcRendererDecorators: [
                                 //        new charts.ArcLabelDecorator(
                                 //            labelPosition: charts.ArcLabelPosition.inside)
                                 //      ]),

                                 // defaultRenderer: charts.ArcRendererConfig(
                                 //     arcRendererDecorators: [
                                 //       charts.ArcLabelDecorator(
                                 //           labelPosition: charts.ArcLabelPosition.inside)
                                 //     ])
                               ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: SingleChildScrollView(
                                    child:
                                    DataTable(

                                      columns: const <DataColumn>[
                                        DataColumn(
                                          label: Text(
                                            '',
                                            style: TextStyle(fontStyle: FontStyle.normal),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'المنتج',
                                            style: TextStyle(fontStyle: FontStyle.normal),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'المبيعات',
                                            style: TextStyle(fontStyle: FontStyle.normal),
                                          ),
                                        ),    DataColumn(
                                          label: Expanded(
                                            child: Text(
                                              'الكمية  ',
                                              style: TextStyle(fontStyle: FontStyle.normal),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows:rowsdata,dividerThickness: 3,
                                      horizontalMargin: 1,columnSpacing: 10,
                                      //       RowEditTitle(color: salesresult[i].colorval,name: salesresult[i].x,
                                      //         des2: salesresult[i].y.toString(), des: salesresult[i].countclient.toString()),
                                      //     <DataRow>[
                                      //   DataRow(
                                      //     cells: <DataCell>[
                                      //       DataCell(Text('Sarah')),
                                      //       DataCell(Text('19')),
                                      //       DataCell(Text('Student')),
                                      //       DataCell(Text('Student')),
                                      //     ],
                                      //   ),
                                      // ],
                                    )
                                  // Column(
                                  //   children: [
                                  //     RowEditTitle(color: null,name: 'الموظف', des2: ' مبيعاته', des: 'عدد العملاء',),
                                  //     for(int i=0;i<salesresult.length;i++)
                                  //       RowEditTitle(color: salesresult[i].colorval,name: salesresult[i].x,
                                  //         des2: salesresult[i].y.toString(), des: salesresult[i].countclient.toString()),
                                  //   ],
                                  // ),
                                ),
                              )

                            ] ),
                      ),
                    ),
                  ),
                ),
              ]),
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
