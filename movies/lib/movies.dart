library movies;

// Domain - Entities
export 'domain/entities/movie.dart';
export 'domain/entities/movie_detail.dart';

// Domain - Repositories
export 'domain/repositories/movie_repository.dart';

// Domain - Usecases
export 'domain/usecases/get_movie_detail.dart';
export 'domain/usecases/get_movie_recommendations.dart';
export 'domain/usecases/get_movie_watchlist_status.dart';
export 'domain/usecases/get_now_playing_movies.dart';
export 'domain/usecases/get_popular_movies.dart';
export 'domain/usecases/get_top_rated_movies.dart';
export 'domain/usecases/get_watchlist_movies.dart';
export 'domain/usecases/remove_watchlist_movie.dart';
export 'domain/usecases/save_watchlist_movie.dart';
export 'domain/usecases/search_movies.dart';

// Data - Datasources
export 'data/datasources/movie_local_data_source.dart';
export 'data/datasources/movie_remote_data_source.dart';

// Data - Models
export 'data/models/movie_detail_model.dart';
export 'data/models/movie_model.dart';
export 'data/models/movie_response.dart';
export 'data/models/movie_table.dart';

// Data - Repositories
export 'data/repositories/movie_repository_impl.dart';

// Presentation - Bloc
export 'presentation/bloc/movie_detail_bloc.dart';
export 'presentation/bloc/movie_detail_event.dart';
export 'presentation/bloc/movie_detail_state.dart';
export 'presentation/bloc/movie_list_bloc.dart';
export 'presentation/bloc/movie_list_event.dart';
export 'presentation/bloc/movie_list_state.dart';
export 'presentation/bloc/movie_search_bloc.dart';
export 'presentation/bloc/movie_search_event.dart';
export 'presentation/bloc/movie_search_state.dart';
export 'presentation/bloc/now_playing_movies_bloc.dart';
export 'presentation/bloc/now_playing_movies_event.dart';
export 'presentation/bloc/now_playing_movies_state.dart';
export 'presentation/bloc/popular_movies_bloc.dart';
export 'presentation/bloc/popular_movies_event.dart';
export 'presentation/bloc/popular_movies_state.dart';
export 'presentation/bloc/top_rated_movies_bloc.dart';
export 'presentation/bloc/top_rated_movies_event.dart';
export 'presentation/bloc/top_rated_movies_state.dart';
export 'presentation/bloc/watchlist_movies_bloc.dart';
export 'presentation/bloc/watchlist_movies_event.dart';
export 'presentation/bloc/watchlist_movies_state.dart';

// Presentation - Pages
export 'presentation/pages/home_movie_page.dart';
export 'presentation/pages/movie_detail_page.dart';
export 'presentation/pages/now_playing_movies_page.dart';
export 'presentation/pages/popular_movies_page.dart';
export 'presentation/pages/top_rated_movies_page.dart';
export 'presentation/pages/watchlist_movies_page.dart';

// Presentation - Widgets
export 'presentation/widgets/movie_card_list.dart';
