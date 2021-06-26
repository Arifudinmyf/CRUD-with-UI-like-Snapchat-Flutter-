import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1/Repositories/country_repository.dart';
import 'package:task1/models/country.dart';
import 'package:task1/tools/flag_calculation.dart';
import 'package:task1/tools/loading_animation.dart';
import 'package:task1/utils/string_extensions.dart';
import 'country_bloc.dart';
import 'country_event.dart';
import 'country_state.dart';

class CountryPage extends StatefulWidget {
  CountryPage({@required this.country});
  final ValueNotifier<Country> country;

  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  TextEditingController editingController = TextEditingController();
  CountryBloc _bloc;
  List<Country> _countries = [];
  @override
  void initState() {
    super.initState();
    _bloc = CountryBloc(CountryRepository());
    _bloc.add(FetchCountriesEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CountryBloc>(
        create: (context) {
          return _bloc;
        },
        child: BlocListener<CountryBloc, CountryState>(
          listener: _blocListener,
          child: _render(),
        ));
  }

  Widget _render() {
    return BlocBuilder<CountryBloc, CountryState>(builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
          ),
          backgroundColor: Colors.black,
          body: Container(
            color: Colors.black,
            child: Column(
              children: [_searchBox(), _renderCountries()],
            ),
          ));
    });
  }

  Widget _renderCountries() {
    return Expanded(
      child: ListView.builder(
        itemCount: _countries.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.black,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.black),
                onPressed: () => _navigateToPhonePage(index, context),
                child: _renderCountry(index),
              ),
            ),
            shape: Border(
              bottom: BorderSide(color: Colors.grey),
            ),
          );
        },
      ),
    );
  }

  Widget _renderCountry(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${calculateFlag(_countries[index].iso2_cc)} ${_countries[index].name}",
          style: TextStyle(color: Colors.white),
        ),
        Text(
          _countries[index].e164_cc,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _searchBox() {
    return Container(
      padding: const EdgeInsets.all(3.0),
      color: Colors.black,
      child: TextField(
        onChanged: (value) => _search(value),
        controller: editingController,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: "search".localizeString(context),
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            )),
      ),
    );
  }

  void _search(value) {
    _bloc.add(SearchEvent(query: value));
  }

  void _navigateToPhonePage(index, context) {
    widget.country.value = _countries[index];
    Navigator.pop(context);
  }

  void _blocListener(context, state) {
    if (state is CountryLoadingState) {
      LoadingScreen.showLoadingDialog(context);
    }
    if (state is CountryLoadedState) {
      Navigator.pop(context);
      _countries = _bloc.countries;
    }
    if (state is CountrySearchBoxChangedState) {
      _countries = state.countries;
    }
  }
}
