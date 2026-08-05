// DOMAIN
export 'domain/entities/search_params.dart';
export 'domain/entities/search_result_entity.dart';

export 'domain/repositories/search_repository.dart';

export 'domain/usecases/search_usecase.dart';
export 'domain/usecases/get_recent_searches_usecase.dart';
export 'domain/usecases/save_recent_search_usecase.dart';
export 'domain/usecases/clear_recent_searches_usecase.dart';

// DATA
export 'data/models/search_result_model.dart';

export 'data/datasources/search_remote_data_source.dart';

export 'data/repositories/search_repository_impl.dart';

// PRESENTATION
export 'presentation/controllers/search_controller.dart';

export 'presentation/pages/search_screen.dart';

export 'presentation/widgets/app_search_bar.dart';
export 'presentation/widgets/recent_search_widget.dart';
export 'presentation/widgets/search_empty_widget.dart';
export 'presentation/widgets/search_error_widget.dart';
export 'presentation/widgets/search_loading_widget.dart';
export 'presentation/widgets/search_result_list.dart';
export 'presentation/widgets/search_result_tile.dart';
