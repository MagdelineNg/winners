import 'package:hidden_gems_sg/helper/favourites_controller.dart';
import 'package:hidden_gems_sg/helper/places_api.dart';
import 'package:hidden_gems_sg/helper/utils.dart';
import 'package:hidden_gems_sg/screens/place_ui.dart';
import 'package:flutter/material.dart';
import 'package:hidden_gems_sg/models/place.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FavouriteScreen();
  }
}

class _FavouriteScreen extends State<FavouriteScreen> {
  final PlacesApi _placesApi = PlacesApi();
  List<String> _favourites = [];
  List<Place> _favourite_places = [];
  bool _isLoaded = false;
  final FavouritesController _favouritesController = FavouritesController();

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Widget _addFav(int index, Place place, double height, double width) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () async {
                  await _favouritesController.addOrRemoveFav(place.id);
                  _favourites =
                      await _favouritesController.getFavouritesList(context);
                  _favourite_places = await _favouritesController
                      .removeFavourites(index, _favourite_places);
                  setState(() {});
                },
                child: _favourites.contains(place.id)
                    ? const Icon(
                        Icons.favorite,
                        color: Color(0xffE56372),
                      )
                    : const Icon(
                        Icons.favorite_border,
                        color: Color(0xffE56372),
                      ),
              ),
              const SizedBox(
                width: 10,
              ),
              textMinor(
                _favourites.contains(place.id)
                    ? 'added to favourites'
                    : 'add to favourites',
                const Color(0xffD1D1D6),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget recommendedList(List<Place> places, double height, double width) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: places.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, PlaceScreen.routeName,
                        arguments:
                            PlaceScreenArguments(places[index], _favourites));
                  },
                  child: placeContainer(
                    places[index],
                    0.8 * width,
                    0.215 * height,
                    _addFav(index, places[index], 0.05 * height, 0.8 * width),
                    Container(),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        );
      },
    );
  }

  Future<void> _reload() async {
    _isLoaded = false;
    _favourite_places = [];
    _favourites = await _favouritesController.getFavouritesList(context);
    if (_favourites != []) {
      for (var fav in _favourites) {
        var _place = await _placesApi.placeDetailsSearchFromText(fav);
        _favourite_places.add(_place!);
      }
    } else {
      _favourite_places = [];
    }
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return _isLoaded
        ? RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _isLoaded = false;
              });
              _reload();
            },
            child: Scaffold(
              backgroundColor: const Color(0xFFFFF9ED),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _reload();
                      },
                      child: topBar('favourites', height, width,
                          'assets/img/favourites-top.svg'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    recommendedList(_favourite_places, height, width),
                    Container(
                        child: _favourite_places.isEmpty
                            ? textMinor("No favourites", Colors.black)
                            : Container(
                                height: 10,
                              )),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
          )
        : Container(
            color: const Color(0XffFFF9ED),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
