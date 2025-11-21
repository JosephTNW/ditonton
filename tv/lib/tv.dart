library tv;

// Domain - Entities
export 'domain/entities/tv.dart';
export 'domain/entities/tv_detail.dart';

// Domain - Repositories
export 'domain/repositories/tv_repository.dart';

// Domain - Usecases
export 'domain/usecases/get_tv_detail.dart';
export 'domain/usecases/get_tv_recommendations.dart';
export 'domain/usecases/get_tv_watchlist_status.dart';
export 'domain/usecases/get_on_the_air_tvs.dart';
export 'domain/usecases/get_popular_tvs.dart';
export 'domain/usecases/get_top_rated_tvs.dart';
export 'domain/usecases/get_watchlist_tvs.dart';
export 'domain/usecases/remove_watchlist_tv.dart';
export 'domain/usecases/save_watchlist_tv.dart';
export 'domain/usecases/search_tvs.dart';

// Data - Datasources
export 'data/datasources/tv_local_data_source.dart';
export 'data/datasources/tv_remote_data_source.dart';

// Data - Models
export 'data/models/tv_detail_response.dart';
export 'data/models/tv_model.dart';
export 'data/models/tv_response.dart';
export 'data/models/tv_table.dart';

// Data - Repositories
export 'data/repositories/tv_repository_impl.dart';

// Presentation - Bloc
export 'presentation/bloc/tv_detail_bloc.dart';
export 'presentation/bloc/tv_detail_event.dart';
export 'presentation/bloc/tv_detail_state.dart';
export 'presentation/bloc/tv_list_bloc.dart';
export 'presentation/bloc/tv_list_event.dart';
export 'presentation/bloc/tv_list_state.dart';
export 'presentation/bloc/tv_search_bloc.dart';
export 'presentation/bloc/tv_search_event.dart';
export 'presentation/bloc/tv_search_state.dart';
export 'presentation/bloc/on_the_air_tvs_bloc.dart';
export 'presentation/bloc/on_the_air_tvs_event.dart';
export 'presentation/bloc/on_the_air_tvs_state.dart';
export 'presentation/bloc/popular_tvs_bloc.dart';
export 'presentation/bloc/popular_tvs_event.dart';
export 'presentation/bloc/popular_tvs_state.dart';
export 'presentation/bloc/top_rated_tvs_bloc.dart';
export 'presentation/bloc/top_rated_tvs_event.dart';
export 'presentation/bloc/top_rated_tvs_state.dart';
export 'presentation/bloc/watchlist_tvs_bloc.dart';
export 'presentation/bloc/watchlist_tvs_event.dart';
export 'presentation/bloc/watchlist_tvs_state.dart';

// Presentation - Pages
export 'presentation/pages/home_tv_page.dart';
export 'presentation/pages/tv_detail_page.dart';
export 'presentation/pages/on_the_air_tvs_page.dart';
export 'presentation/pages/popular_tvs_page.dart';
export 'presentation/pages/top_rated_tvs_page.dart';
export 'presentation/pages/watchlist_tvs_page.dart';
export 'presentation/pages/search_tv_page.dart';

// Presentation - Widgets
export 'presentation/widgets/tv_card_list.dart';
