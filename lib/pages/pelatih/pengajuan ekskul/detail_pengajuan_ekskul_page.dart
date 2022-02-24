import 'package:adistetsa/models/pengajuanekskul_model.dart';
import 'package:adistetsa/providers/provider.dart';
import 'package:adistetsa/services/service.dart';
import 'package:adistetsa/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPengajuanEkskulPage extends StatefulWidget {
  @override
  _DetailPengajuanEkskulPageState createState() =>
      _DetailPengajuanEkskulPageState();
}

class _DetailPengajuanEkskulPageState extends State<DetailPengajuanEkskulPage> {
  String valueAcc = '';
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Providers provider = Provider.of<Providers>(context);
    PengajuanEkskulModel pengajuanEkskulModel = provider.pengajuanEkskul;
    PreferredSizeWidget header() {
      return AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: mono6Color,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: mono1Color,
          ),
        ),
        title: Text(
          'Detail Pengajuan Siswa',
          style: mono1TextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      );
    }

    Widget nameCard({
      required name,
      required nis,
      required kelas,
    }) {
      return Container(
        padding: EdgeInsets.only(top: 12, bottom: 14, left: 15, right: 15),
        color: m2Color,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: mono6TextStyle.copyWith(
                fontSize: 20,
                fontWeight: bold,
              ),
            ),
            RichText(
              text: TextSpan(
                  text: nis,
                  style: mono6TextStyle.copyWith(
                    fontSize: 10,
                  ),
                  children: [
                    TextSpan(
                      text: ' - ',
                      style: mono6TextStyle.copyWith(
                        fontSize: 10,
                      ),
                    ),
                    TextSpan(
                      text: kelas,
                      style: mono6TextStyle.copyWith(
                        fontSize: 10,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      );
    }

    Widget listItem({required String name, required String value}) {
      return Container(
        margin: EdgeInsets.only(
          bottom: 25,
          left: 33,
          right: 33,
        ),
        child: Row(
          children: [
            Container(
              width: 130,
              child: Text(
                name,
                style: mono1TextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: semiBold,
                ),
              ),
            ),
            Text(
              value,
              style: mono1TextStyle.copyWith(
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    confirmAccept() async {
      return showDialog(
        context: context,
        builder: (BuildContext confirmContext) {
          return Dialog(
            backgroundColor: mono6Color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 20,
              ),
              width: 305,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Text(
                          'Konfirmasi',
                          style: mono1TextStyle.copyWith(
                            fontWeight: semiBold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            'assets/cancel_button.png',
                            width: 14,
                            height: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Apakah anda yakin untuk melakukan persetujuan?',
                    style: mono1TextStyle.copyWith(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  isLoading == false
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 46,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: mono3Color,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Batal',
                                  style: mono6TextStyle.copyWith(
                                    fontWeight: semiBold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: 120,
                              height: 46,
                              child: TextButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Navigator.pop(confirmContext);
                                  confirmAccept();
                                  if (await Services().terimaPengajuanEkskul(
                                      id: pengajuanEkskulModel.iD.toString())) {
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            backgroundColor: dangerColor,
                                            content: Text(
                                              'Gagal Setuju Pengajuan Ekskul',
                                              textAlign: TextAlign.center,
                                            )));
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: successColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Setuju',
                                  style: mono6TextStyle.copyWith(
                                    fontWeight: semiBold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          alignment: Alignment.center,
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            color: m1Color,
                            strokeWidth: 2,
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      );
    }

    confirmDecline() async {
      return showDialog(
        context: context,
        builder: (BuildContext declineContext) {
          return Dialog(
            backgroundColor: mono6Color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 20,
              ),
              width: 305,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Text(
                          'Konfirmasi',
                          style: mono1TextStyle.copyWith(
                            fontWeight: semiBold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            'assets/cancel_button.png',
                            width: 14,
                            height: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Apakah anda yakin untuk melakukan penolakan?',
                    style: mono1TextStyle.copyWith(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  isLoading == false
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 46,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: mono3Color,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Batal',
                                  style: mono6TextStyle.copyWith(
                                    fontWeight: semiBold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: 120,
                              height: 46,
                              child: TextButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Navigator.pop(declineContext);
                                  confirmDecline();
                                  if (await Services().tolakPengajuanEkskul(
                                      id: pengajuanEkskulModel.iD.toString())) {
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            backgroundColor: dangerColor,
                                            content: Text(
                                              'Gagal Tolak Pengajuan Ekskul',
                                              textAlign: TextAlign.center,
                                            )));
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: dangerColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Tolak',
                                  style: mono6TextStyle.copyWith(
                                    fontWeight: semiBold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          alignment: Alignment.center,
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            color: m1Color,
                            strokeWidth: 2,
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      );
    }

    Widget buttonSubmit() {
      return Container(
        margin: EdgeInsets.only(
          left: 45,
          right: 46,
          bottom: 20,
        ),
        height: 46,
        width: double.infinity,
        child: TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: BorderSide(
              color: h1Color,
              width: 2,
            ),
            backgroundColor: h1Color,
          ),
          onPressed: () {
            confirmAccept();
          },
          child: Text(
            'Setuju',
            style: mono6TextStyle.copyWith(
              fontWeight: bold,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    Widget buttonTolak() {
      return Container(
          margin: EdgeInsets.only(
            left: 45,
            right: 46,
            bottom: 20,
          ),
          height: 46,
          width: double.infinity,
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(
                  width: 1,
                  color: dangerColor,
                ),
              ),
              onPressed: () {
                confirmDecline();
              },
              child: Text(
                'Tolak',
                style: dangerTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 16,
                ),
              )));
    }

    return Scaffold(
        backgroundColor: mono6Color,
        appBar: header(),
        body: Column(
          children: [
            nameCard(
              name: '${pengajuanEkskulModel.nAMA}',
              nis: '${pengajuanEkskulModel.nIS}'.split(' - ')[0],
              kelas: '${pengajuanEkskulModel.kELAS}',
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView(
                children: [
                  listItem(
                    name: 'Ekstrakurikuler',
                    value: '${pengajuanEkskulModel.eKSKUL}',
                  ),
                  listItem(
                    name: 'Tahun',
                    value: '${pengajuanEkskulModel.tAHUNAJARAN}',
                  ),
                  listItem(
                    name: 'Tanggal',
                    value: '${pengajuanEkskulModel.tANGGALPENGAJUAN}',
                  ),
                  listItem(
                    name: 'Status',
                    value: '${pengajuanEkskulModel.sTATUSPENGAJUAN}',
                  ),
                  buttonSubmit(),
                  buttonTolak(),
                ],
              ),
            ),
          ],
        ));
  }
}