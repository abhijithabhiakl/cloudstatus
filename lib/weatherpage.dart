import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  void initState() {
    getweather();
    super.initState();
  }

  WeatherFactory wf = new WeatherFactory("9e8638e0e66018f75db6fc0ed9512f3b");
  late Weather mylocation;
  bool loading = true;
  getweather() async {
    //1
    await Geolocator.requestPermission();
    print('gotlocation');
    //2
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print('latitude: ${position.latitude} longitude : ${position.longitude}');
    //3
    Weather w = await wf.currentWeatherByLocation(
        position.latitude, position.longitude);
    //4
    setState(() {
      mylocation = w;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loading == true
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                ),
              )
            : Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    color: Colors.redAccent[700],
                    height: 310,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Currently in ${mylocation.areaName}',
                            style:
                                TextStyle(color: Colors.white, fontSize: 26)),
                        Text(
                            '  ${mylocation.temperature!.celsius!.toStringAsFixed(1)}°',
                            style:
                                TextStyle(color: Colors.white, fontSize: 60)),
                        Text('${mylocation.weatherDescription}',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    color: Colors.white30,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.thermostat_outlined),
                          title: Text('Temperature'),
                          trailing: Text(
                              '${mylocation.temperature!.celsius!.toStringAsFixed(1)} °'),
                        ),
                        ListTile(
                          leading: Icon(Icons.cloud),
                          title: Text('Weather'),
                          trailing: Text('${mylocation.weatherDescription}'),
                        ),
                        ListTile(
                          leading: Icon(CupertinoIcons.cloud),
                          title: Text('Feels like'),
                          trailing: Text('${mylocation.tempFeelsLike}'),
                        ),
                        ListTile(
                          leading: Icon(CupertinoIcons.wind),
                          title: Text('Wind'),
                          trailing: Text('${mylocation.windSpeed}'),
                        )
                      ],
                    ),
                  ))
                ],
              ));
  }
}
