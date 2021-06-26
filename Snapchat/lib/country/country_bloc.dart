import 'package:flutter_bloc/flutter_bloc.dart';
import '../Repositories/country_repository.dart';
import '../models/country.dart';
import 'country_event.dart';
import 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  CountryBloc(CountryRepository countryRepository)
      : super(CountryInitialState()) {
    _countryRepository = countryRepository;
    _countries = [];
  }
  CountryRepository _countryRepository;
  List<Country> _countries;
  List<Country> get countries => _countries;

  @override
  Stream<CountryState> mapEventToState(CountryEvent event) async* {
    if (event is FetchCountriesEvent) {
      yield* mapEventFetchCountriesToState(event);
    }
    if (event is SearchEvent) {
      yield* mapEventSearchEventToState(event);
    }
  }

  Stream<CountryState> mapEventSearchEventToState(SearchEvent event) async* {
    List<Country> countries = [];
    countries = _countryRepository.filterSearchResults(event.query);
    yield CountrySearchBoxChangedState(countries: countries);
  }

  Stream<CountryState> mapEventFetchCountriesToState(
      FetchCountriesEvent event) async* {
    yield CountryLoadingState();
    try {
      _countries = await _countryRepository.getCountries();
      yield CountryLoadedState(countries: _countries);
    } catch (e) {
      yield CountryErrorState(message: e.toString());
    }
  }
}
