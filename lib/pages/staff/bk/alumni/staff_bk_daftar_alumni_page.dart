import 'package:adistetsa/models/daftar_alumni_model.dart';
import 'package:adistetsa/providers/provider.dart';
import 'package:adistetsa/services/service.dart';
import 'package:adistetsa/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:adistetsa/theme.dart';
import 'package:provider/provider.dart';

class StaffBkDaftarAlumniPage extends StatefulWidget {
  @override
  _StaffBkDaftarAlumniPageState createState() =>
      _StaffBkDaftarAlumniPageState();
}

class _StaffBkDaftarAlumniPageState extends State<StaffBkDaftarAlumniPage> {
  bool isSearch = false;
  String urlSearch = '';
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  bool flag1 = false;
  Object? value1Item;
  bool flag2 = false;
  Object? value2Item;
  String filterJurusan = '';
  String filterKelas = '';
  String url = '';
  @override
  Widget build(BuildContext context) {
    Providers provider = Provider.of(context);
    PreferredSizeWidget header() {
      return AppBar(
        centerTitle: true,
        title: Text(
          'Daftar Alumni',
          style: mono1TextStyle.copyWith(
            fontWeight: semiBold,
            fontSize: 18,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: mono6Color,
        shadowColor: mono3Color,
        elevation: 4,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: mono2Color,
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearch = true;
              });
            },
            icon: Icon(Icons.search),
            color: mono2Color,
          ),
        ],
      );
    }

    PreferredSizeWidget searchAppbar() {
      return AppBar(
        backgroundColor: mono6Color,
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          onTap: () async {
            setState(() {
              searchController.clear();
              urlSearch = '';
              isSearch = false;
            });
          },
          child: Icon(
            Icons.arrow_back,
            color: mono1Color,
          ),
        ),
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search',
            isDense: true,
            border: InputBorder.none,
          ),
          onChanged: (newValue) async {
            setState(() {
              if (searchController.selection.start >
                  searchController.text.length) {
                searchController.selection = new TextSelection.fromPosition(
                    new TextPosition(offset: searchController.text.length));
                searchController.text = newValue.toString();
              }
              print(searchController.text);
              urlSearch = 'search=${searchController.text}';
              isLoading = true;
            });
            await Services().getDaftarAlumni();
            setState(() {
              isLoading = false;
            });
          },
        ),
        elevation: 4,
        centerTitle: false,
      );
    }

    Widget listItem({
      required String id,
      required String name,
      required String nis,
      required String kelas,
    }) {
      return GestureDetector(
        onTap: () async {
          loading(context);
          await provider.getDetailDaftarAlumni(id: id);
          Navigator.pushReplacementNamed(context, '/staff/bk/alumni/detail')
              .then((_) async {
            setState(() {
              isLoading = true;
            });
            await Services().getDaftarAlumni();
            setState(() {
              isLoading = false;
            });
          });
        },
        child: Container(
          color: mono6Color,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 20,
                  right: 41,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: mono1TextStyle,
                        ),
                        Text(
                          nis,
                          style: mono1TextStyle.copyWith(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      kelas,
                      style: mono1TextStyle.copyWith(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: mono3Color,
                thickness: 0.5,
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: isSearch ? searchAppbar() : header(),
      backgroundColor: mono6Color,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // filter(),
          Expanded(
            child: isLoading == true
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: FutureBuilder(
                      future: Services().getDaftarAlumni(search: urlSearch),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          List<DaftarAlumniModel> data = snapshot.data;
                          return data.isEmpty
                              ? Center(
                                  child: Text(
                                    'data tidak ditemukan',
                                    style: mono1TextStyle,
                                  ),
                                )
                              : ListView(
                                  children: data.map((item) {
                                    return listItem(
                                      id: '${item.iD}',
                                      name: '${item.nAMASISWA}',
                                      nis: '${item.nIS}',
                                      kelas: '${item.kELAS}',
                                    );
                                  }).toList(),
                                );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 4,
                              color: m1Color,
                            ),
                          );
                        }
                      },
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
