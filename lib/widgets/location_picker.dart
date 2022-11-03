import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as route;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import "package:google_maps_webservice/geocoding.dart";
import 'package:google_maps_webservice/places.dart';
import 'logger.dart';
class LocationPicker extends StatefulWidget {
  const LocationPicker({
    Key? key,
    this.desiredAccuracy = LocationAccuracy.high,
    required this.apiKey,
    this.geoCodingBaseUrl,
    this.geoCodingHttpClient,
    this.geoCodingApiHeaders,
    this.language,
    this.locationType = const [],
    this.resultType = const [],
    this.minMaxZoomPreference = const MinMaxZoomPreference(10, 20),
    this.padding = const EdgeInsets.all(0),
    this.compassEnabled = true,
    this.liteModeEnabled = false,
    this.topCardMargin = const EdgeInsets.all(8),
    this.topCardColor,
    this.topCardShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.searchHintText = "Start typing to search",
    this.bottomCardShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    this.bottomCardMargin = const EdgeInsets.fromLTRB(8, 8, 8, 16),
    this.bottomCardIcon = const Icon(Icons.send),
    this.bottomCardTooltip = "Continue with this location",
    this.bottomCardColor,
    this.onSuggestionSelected,
    required this.onNext,
    required this.onNextt,
    this.showBackButton = true,
    this.canPopOnNextButtonTaped = true,
    this.backButton,
    this.showMoreOptions = true,
    this.dialogTitle = 'You can also use the following options',
    this.placesHttpClient,
    this.placesApiHeaders,
    this.placesBaseUrl,
    this.sessionToken,
    this.offset,
    this.origin,
    this.location,
    this.radius,
    this.region,
    this.fields = const [],
    this.types = const [],
    this.components = const [],
    this.strictbounds = false,
    this.hideSuggestionsOnKeyboardHide = false,
  }) : super(key: key);

  final EdgeInsets padding;

  /// Compass for the map (default: true)
  final bool compassEnabled;

  /// Lite mode for the map (default: false)
  final bool liteModeEnabled;

  /// API key for the map & places
  final String apiKey;

  /// GPS accuracy for the map
  final LocationAccuracy desiredAccuracy;

  /// GeoCoding base url
  final String? geoCodingBaseUrl;

  /// GeoCoding http client
  final Client? geoCodingHttpClient;

  /// GeoCoding api headers
  final Map<String, String>? geoCodingApiHeaders;

  /// GeoCoding location type
  final List<String> locationType;

  /// GeoCoding result type
  final List<String> resultType;

  /// Map minimum zoom level & maximum zoom level
  final MinMaxZoomPreference minMaxZoomPreference;

  /// Top card margin
  final EdgeInsetsGeometry topCardMargin;

  /// Top card color
  final Color? topCardColor;

  /// Top card shape
  final ShapeBorder topCardShape;

  /// Top card text field border radius
  final BorderRadius? borderRadius;

  /// Top card text field hint text
  final String searchHintText;

  /// Bottom card shape
  final ShapeBorder bottomCardShape;

  /// Bottom card margin
  final EdgeInsetsGeometry bottomCardMargin;

  /// Bottom card icon
  final Icon bottomCardIcon;

  /// Bottom card tooltip
  final String bottomCardTooltip;

  /// Bottom card color
  final Color? bottomCardColor;

  /// On Suggestion Selected callback
  final Function(PlacesDetailsResponse?)? onSuggestionSelected;

  /// On Next Page callback
  final Function(LatLng?) onNext;
  final Function(String?) onNextt;
  /// Show back button (default: true)
  final bool showBackButton;

  /// Popup route on next press (default: false)
  final bool canPopOnNextButtonTaped;

  /// Back button replacement when [showBackButton] is false and [backButton] is not null
  final Widget? backButton;

  /// Show more suggestions
  final bool showMoreOptions;

  /// Dialog title
  final String dialogTitle;

  /// httpClient is used to make network requests.
  final Client? placesHttpClient;

  /// apiHeader is used to add headers to the request.
  final Map<String, String>? placesApiHeaders;

  /// baseUrl is used to build the url for the request.
  final String? placesBaseUrl;

  /// Session token for Google Places API
  final String? sessionToken;

  /// Offset for pagination of results
  /// offset: int,
  final num? offset;

  /// Origin location for calculating distance from results
  /// origin: Location(lat: -33.852, lng: 151.211),
  final Location? origin;

  /// Location bounds for restricting results to a radius around a location
  /// location: Location(lat: -33.867, lng: 151.195)
  final Location? location;

  /// Radius for restricting results to a radius around a location
  /// radius: Radius in meters
  final num? radius;

  /// Language code for Places API results
  /// language: 'en',
  final String? language;

  /// Types for restricting results to a set of place types
  final List<String> types;

  /// Components set results to be restricted to a specific area
  /// components: [Component(Component.country, "us")]
  final List<Component> components;

  /// Bounds for restricting results to a set of bounds
  final bool strictbounds;

  /// Region for restricting results to a set of regions
  /// region: "us"
  final String? region;

  /// fields
  final List<String> fields;

  /// Hide Suggestions on keyboard hide
  final bool hideSuggestionsOnKeyboardHide;
  @override
  State<LocationPicker> createState() => _LocationPickerState();

}


class _LocationPickerState extends State<LocationPicker> {
  final Completer<GoogleMapController> _controller = Completer();


  /// initial latitude & longitude
  late LatLng _initialPosition = const LatLng(36.74587432722343, 3.0695223435759544);

  /// initial address text
  late String _address = "Tap on map to get address";

  /// Map type (default: MapType.normal)
  late MapType _mapType = MapType.normal;

  /// initial zoom level
  late double _zoom = 18.0;

  /// GeoCoding result for further use
  GeocodingResult? _geocodingResult;

  /// GeoCoding results list for further use
  late List<GeocodingResult> _geocodingResultList = [];

  late LatLng geoAddd;

  /// Camera position moved to location
  CameraPosition cameraPosition() {
    return CameraPosition(
      target: _initialPosition,
      zoom: _zoom,
    );
  }

  /// Decode address from latitude & longitude
  void _decodeAddress(Location location) async {
    try {
      final geocoding = GoogleMapsGeocoding(
        apiKey: widget.apiKey,
        baseUrl: widget.geoCodingBaseUrl,
        apiHeaders: widget.geoCodingApiHeaders,
      );
      final response = await geocoding.searchByLocation(
        location,
        language: widget.language,
        locationType: widget.locationType,
        resultType: widget.resultType,
      );
      _address = response.results.first.formattedAddress ?? "";
      _geocodingResult = response.results.first;
      setState(() {});
      if (response.results.length > 1) {
        _geocodingResultList = response.results;
        if (kDebugMode) {
          print('$_geocodingResultList ==========================================================================D');
        }
      }

    } catch (e) {
      logger.e;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Google map view
          GoogleMap(
            onCameraMove: (CameraPosition position) {
              /// set zoom level
              _zoom = position.zoom;
            },
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: _zoom,
            ),
            onTap: (LatLng position) async {
              _initialPosition = position;
              if (kDebugMode) {
                print(_initialPosition.latitude.toString()+' haaaaaaaaaaaa '+_initialPosition.longitude.toString());
              }
              geoAddd = position;
              final controller = await _controller.future;
              controller.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition()));
              _decodeAddress(
                  Location(lat: position.latitude, lng: position.longitude));
              setState(() {
                if (kDebugMode) {
                  print('${
                    Location(
                        lat: position.latitude, lng: position.longitude)
                }   la location ');
                }
              });
            },
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);
            },
            markers: {
              Marker(
                markerId: const MarkerId('one'),
                position: _initialPosition,
              ),
            },
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            padding: widget.padding,
            compassEnabled: widget.compassEnabled,
            liteModeEnabled: widget.liteModeEnabled,
            mapType: _mapType,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(360),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(4.5),
                    child: PopupMenuButton(
                      tooltip: 'Map Type',
                      initialValue: _mapType,
                      icon: Icon(
                        Icons.layers,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      onSelected: (MapType mapType) {
                        setState(() {
                          _mapType = mapType;
                        });
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: MapType.normal,
                          child: Text('Normal'),
                        ),
                        PopupMenuItem(
                          value: MapType.hybrid,
                          child: Text('Hybrid'),
                        ),
                        PopupMenuItem(
                          value: MapType.satellite,
                          child: Text('Satellite'),
                        ),
                        PopupMenuItem(
                          value: MapType.terrain,
                          child: Text('Terrain'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  tooltip: 'My Location',
                  backgroundColor: Colors.indigo,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () async {
                    await Geolocator.requestPermission();
                    Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: widget.desiredAccuracy,
                    );
                    LatLng latLng =
                    LatLng(position.latitude, position.longitude);
                    _initialPosition = latLng;

                    final controller = await _controller.future;
                    controller.animateCamera(
                        CameraUpdate.newCameraPosition(cameraPosition()));
                    _decodeAddress(Location(
                        lat: position.latitude, lng: position.longitude));
                    setState(() {});
                  },
                  child: const Icon(Icons.my_location),
                ),
              ),
              Card(
                margin: widget.bottomCardMargin,
                shape: widget.bottomCardShape,
                color: widget.bottomCardColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(_address),
                      trailing: IconButton(
                        tooltip: widget.bottomCardTooltip,
                        icon: const Icon(Icons.send),
                        onPressed: () async {

                          if (kDebugMode) {
                            print(geoAddd.longitude.toString()+' hell yaaaaaaaaaaaaaaa'+geoAddd.latitude.toString());
                          }

                          _address =  await getAddressFromLatLong(geoAddd);
                          widget.onNext.call(geoAddd);
                          widget.onNextt.call(await getAddressFromLatLong(geoAddd));
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
Future<String> getAddressFromLatLong(LatLng position)async {
  List<route.Placemark> placers = await route.placemarkFromCoordinates(position.latitude, position.longitude);
  route.Placemark place = placers[0];
  String address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
  return address;
}