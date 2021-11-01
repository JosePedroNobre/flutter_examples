import 'dart:typed_data';
import 'package:customer/constants/styles.dart';
import 'package:customer/features/home/bloc/qr_code_bloc.dart';
import 'package:customer/features/home/pages/map_style.dart';
import 'package:customer/features/store_info/pages/store_info_screen.dart';
import 'package:customer/network/model/store.dart';
import 'package:customer/widgets/sensei_drawer/sensei_drawer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreMap extends StatefulWidget {
  final LatLng latLng;
  final SenseiDrawerController senseiDrawerController;

  StoreMap({this.latLng, this.senseiDrawerController});

  @override
  _StoreMapState createState() => _StoreMapState();
}

class _StoreMapState extends State<StoreMap> {
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor pinLocationIcon;
  Store choosedStore;
  bool isMapReady = false;
  List<Store> stores = [];
  String url =
      'https://www.google.com/maps/dir/?api=1&origin=43.7967876,-79.5331616&destination=43.5184049,-79.8473993&waypoints=43.1941283,-79.59179|43.7991083,-79.5339667|43.8387033,-79.3453417|43.836424,-79.3024487&travelmode=driving&dir_action=navigate';

  PanelController _panelController = new PanelController();
  bool isPanelOpen = false;

  @override
  void initState() {
    BlocProvider.of<QrCodeBloc>(context).add(GetStores());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          title: SvgPicture.asset(
            "images/variable_images/Logo.svg",
            color: Color(0XFFCED4DA),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                icon: Icon(
                  Icons.shopping_basket_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: Future.wait([]),
          builder: (context, snapshot) {
            return _buildBody();
          },
        ));
  }

  _buildBody() {
    return Stack(
      children: [
        Center(
          child: _buildMap(),
        ),
        InkWell(
          onTap: () {
            if (isPanelOpen) {
              isPanelOpen = false;
              _panelController.close();
            } else {
              isPanelOpen = true;
              _panelController.open();
            }
          },
          child: SlidingUpPanel(
            controller: _panelController,
            maxHeight: 1000,
            minHeight: 300,
            panelBuilder: (sc) {
              return Container(
                color: Colors.white,
                child: Wrap(
                  children: [
                    Center(
                        child: Container(
                            height: 35,
                            child: Center(
                              child: Container(
                                height: 3.0,
                                width: 32.0,
                                color: Color(0XFFF1F3F5),
                              ),
                            ))),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(title: _buildBottomSheetContent());
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _buildMap() {
    return GoogleMap(
      markers: Set<Marker>.of(markers.values),
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      initialCameraPosition: CameraPosition(
        target: widget.latLng,
        zoom: 17,
      ),
      padding: EdgeInsets.only(bottom: 150),
      onMapCreated: (GoogleMapController controller) async {
        controller.setMapStyle(MapStyle.mapStyles);
      },
    );
  }

  Widget _buildBottomSheetContent() {
    return BlocConsumer<QrCodeBloc, QrCodeState>(
        cubit: BlocProvider.of<QrCodeBloc>(context),
        listenWhen: (previous, current) => current is StoresLoaded,
        buildWhen: (previous, current) => current is StoresLoaded,
        builder: (context, state) {
          if (state is StoresLoaded) {
            stores = state.stores;
            // mocked data to be replaces with lat and long from the network
            stores[0].lat = 38.83473160335532;
            stores[0].long = -9.156555352969276;

            stores[1].lat = 38.75066697419888;
            stores[1].long = -9.204790415257163;

            stores.forEach((element) async {
              await _addMarker(element, element.lat ?? 0.0, element.long ?? 0.0,
                  element.id, () {});
            });
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: choosedStore == null,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      child: Text(
                        "Stores near this area",
                        style: font2(
                          size: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0XFF6A7178),
                        ),
                      ),
                    ),
                  ),
                  choosedStore == null
                      ? _buildStoreList(stores)
                      : _buildStoreDetails()
                ],
              ),
            );
          } else {
            return Container(
              width: double.infinity,
              height: 44,
              color: Colors.white,
              child: Row(
                children: [
                  Spacer(),
                  CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.black)),
                  Spacer()
                ],
              ),
            );
          }
        },
        listener: (context, state) async {});
  }

  _buildStoreList(List<Store> stores) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      removeTop: true,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: stores.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildBottomSheetItem(stores[index]);
        },
      ),
    );
  }

  _buildStoreDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 300,
                    child: Text(choosedStore.name,
                        style: font1(fontWeight: FontWeight.w600, size: 16)),
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        setState(() {
                          choosedStore = null;
                        });
                      },
                      child: Icon(Icons.close))
                ],
              ),
              SizedBox(height: 4),
              Text(
                "Open until 9:30 PM",
                style: font2(
                    color: Color(0xff33D887),
                    fontWeight: FontWeight.w500,
                    size: 14),
              ),
              SizedBox(height: 9),
              Divider(),
              SizedBox(height: 17),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    choosedStore = null;
                    Navigator.pop(context);
                  });
                },
                child: Text("Select store"),
              ),
              SizedBox(height: 17),
              Divider(),
              SizedBox(height: 12),
              Text("Address",
                  style: font2(
                      color: Color(0xffADB5BD),
                      fontWeight: FontWeight.w400,
                      size: 16)),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(choosedStore.address.address,
                      style: font2(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          size: 14)),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        launch(url);
                      },
                      child: SvgPicture.asset("images/ic_direction.svg")),
                ],
              ),
              SizedBox(height: 8),
              Divider(),
              SizedBox(height: 16),
              Text("Store hours",
                  style: font2(
                      color: Color(0xffADB5BD),
                      fontWeight: FontWeight.w400,
                      size: 16)),
              SizedBox(height: 10),
              _buildStoreHourList(),
              SizedBox(height: 17),
              Divider(),
              SizedBox(height: 12),
              Text("Selection",
                  style: font2(
                      color: Color(0xffADB5BD),
                      fontWeight: FontWeight.w400,
                      size: 16)),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StoreInfoScreen()),
                  );
                },
                child: Row(
                  children: [
                    Text("Discover our selection",
                        style: font2(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            size: 14)),
                    Spacer(),
                    SvgPicture.asset("images/ic_restaurant.svg")
                  ],
                ),
              )
            ],
          )),
    );
  }

  // mocked data, to be replace with data from the network
  _buildStoreHourList() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Today",
              style: font2(
                  fontWeight: FontWeight.w400,
                  color: Color(0xff3D454D),
                  size: 14),
            ),
            Spacer(),
            Text("9:00 AM - 21:00 PM",
                style: font2(
                    fontWeight: FontWeight.w400,
                    color: Color(0xff3D454D),
                    size: 14))
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Text(
              "Tomorrow",
              style: font2(
                  fontWeight: FontWeight.w400,
                  color: Color(0xff3D454D),
                  size: 14),
            ),
            Spacer(),
            Text("9:00 AM - 21:00 PM",
                style: font2(
                    fontWeight: FontWeight.w400,
                    color: Color(0xff3D454D),
                    size: 14))
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Text(
              "Thursday",
              style: font2(
                  fontWeight: FontWeight.w400,
                  color: Color(0xff3D454D),
                  size: 14),
            ),
            Spacer(),
            Text("9:00 AM - 21:00 PM",
                style: font2(
                    fontWeight: FontWeight.w400,
                    color: Color(0xff3D454D),
                    size: 14))
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Text(
              "Friday",
              style: font2(
                  fontWeight: FontWeight.w400,
                  color: Color(0xff3D454D),
                  size: 14),
            ),
            Spacer(),
            Text("9:00 AM - 21:00 PM",
                style: font2(
                    fontWeight: FontWeight.w400,
                    color: Color(0xff3D454D),
                    size: 14))
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Text(
              "Saturday",
              style: font2(
                  fontWeight: FontWeight.w400,
                  color: Color(0xff3D454D),
                  size: 14),
            ),
            Spacer(),
            Text("9:00 AM - 21:00 PM",
                style: font2(
                    fontWeight: FontWeight.w400,
                    color: Color(0xff3D454D),
                    size: 14))
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Text(
              "Sunday",
              style: font2(
                  fontWeight: FontWeight.w400,
                  color: Color(0xff3D454D),
                  size: 14),
            ),
            Spacer(),
            Text("Closed",
                style: font2(
                    fontWeight: FontWeight.w400,
                    color: Color(0xffFB5354),
                    size: 14))
          ],
        ),
        SizedBox(height: 12)
      ],
    );
  }

  _buildBottomSheetItem(Store store) {
    return InkWell(
      onTap: () {
        isPanelOpen = true;
        _panelController.open();
        setState(() {
          choosedStore = store;
        });
      },
      child: Container(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: font1(
                        size: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    store?.address?.address ?? "Address unavailable",
                    style: font2(
                      size: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0XFF6A7178),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Opening time unavailable",
                    style: font2(
                      size: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF33D887),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Icon(Icons.chevron_right),
            ],
          )),
    );
  }

  Future<void> _addMarker(
      Store store, double lat, double long, int id, Function onTap) async {
    var markerIdVal = id.toString();
    final MarkerId markerId = MarkerId(markerIdVal);
    final Uint8List markerIcon = await getBytesFromAsset(
        'images/variable_images/continente_log.png', 100);

    // creating a new MARKER
    final Marker marker = Marker(
      onTap: () {
        setState(() {
          choosedStore = store;
        });
      },
      icon: BitmapDescriptor.fromBytes(markerIcon),
      markerId: markerId,
      position: LatLng(lat, long),
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
