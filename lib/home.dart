import 'package:alweather/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:weather/weather.dart';

import 'functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Weather? weather;
  List<Weather>? forecast;
  final wf = WeatherFactory("16212941d576264834bb758b9ff270a5");

  @override
  void initState() {
    getForecast("Awka");
    super.initState();
  }

  getForecast(String location) async {
    weather = await wf.currentWeatherByCityName(location);
    forecast = await wf.fiveDayForecastByCityName(location);

    setState(() {});
  }

  String estimateResponse() {
    if (forecast == null) return "";
    final nextWeatherEstimate = forecast?.elementAt(1);
    final next6hWeatherEstimate = forecast?.elementAt(4);
    /*  print("In 3h: $nextWeatherEstimate");
    print("In 12h: $next6hWeatherEstimate");*/
    return "${firstToUpper(nextWeatherEstimate?.weatherDescription)} expected in the next "
        "3 hours, while ${next6hWeatherEstimate?.weatherDescription} "
        "in 12 hours";
  }

  @override
  Widget build(BuildContext context) {
    print(weather);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DecoratedBox(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    appBackground(weather?.weatherConditionCode, dayTime())),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: RefreshIndicator(
              onRefresh: () async {
                return getForecast(weather?.areaName ?? "Awka");
              },
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dayTime(),
                            ),
                            CustomSearchBar(
                              search: (location) => getForecast(location),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 20,
                            ),
                            Text(
                              weather?.areaName ?? "Awka",
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Text(formatDate(weather?.date)),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              "${weather?.temperature?.celsius?.round() ?? 0}\u00B0C",
                              style: const TextStyle(
                                  fontSize: 75, fontWeight: FontWeight.w500),
                            ),
                            const Spacer(),
                            Image.asset(
                                constructLocalIconUrl(weather?.weatherIcon))
                          ],
                        ),
                        Text(
                          firstToUpper(weather?.weatherDescription),
                          style: const TextStyle(fontSize: 19),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.75,
                          child: Text(
                            estimateResponse(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        const Spacer(),
                        const Row(
                          children: [
                            Text("Next day", style: TextStyle(fontSize: 18)),
                            Icon(Icons.navigate_next_sharp),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 130,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: forecast?.length ?? 0,
                              itemBuilder: (context, index) {
                                final subPart = forecast?.elementAt(index);
                                final date = subPart?.date ?? DateTime.now();

                                final jiffyTime =
                                    Jiffy.parse(date.toString()).fromNow();
                                return Center(
                                  child: Container(
                                    height: 125,
                                    width: 90,
                                    decoration: const BoxDecoration(
                                        color: Colors.deepPurple,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            constructLocalIconUrl(
                                                subPart?.weatherIcon),
                                            height: 50,
                                            width: 60,
                                          ),
                                          Text(
                                            jiffyTime,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                              "${subPart?.temperature?.celsius?.round() ?? 0}\u00B0"),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const SizedBox(
                                        width: 10,
                                      )),
                        ),
                        SizedBox(
                          height:
                              MediaQuery.sizeOf(context).height * 0.12, //120
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
