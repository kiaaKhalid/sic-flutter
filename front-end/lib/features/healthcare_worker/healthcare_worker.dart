/// Healthcare Worker Feature - Export centralisé
/// 
/// Ce fichier regroupe tous les exports principaux de la feature healthcare_worker
/// pour faciliter les imports dans d'autres parties de l'application.
/// 
/// Utilisation:
/// ```dart
/// import 'package:travel_auth_ui/features/healthcare_worker/healthcare_worker.dart';
/// 
/// // Au lieu de:
/// // import 'package:travel_auth_ui/features/healthcare_worker/domain/models/patient.dart';
/// // import 'package:travel_auth_ui/features/healthcare_worker/domain/models/alert.dart';
/// // etc.
/// ```

// ==================== Domain Models ====================
export 'domain/models/patient.dart';
export 'domain/models/alert.dart';
export 'domain/models/health_data.dart';

// ==================== Screens ====================
export 'presentation/screens/dashboard/healthcare_dashboard_screen.dart';
export 'presentation/screens/auth/healthcare_login_screen.dart';
// Note: patient_detail_screen nécessite Provider - utiliser avec précaution

// ==================== Widgets ====================
export 'presentation/widgets/delete_button.dart';
export 'presentation/widgets/kpi_card.dart';
export 'presentation/widgets/patient_list_item.dart';
export 'presentation/widgets/forms/add_patient_dialog.dart';
export 'presentation/widgets/charts/health_chart.dart';

// ==================== Providers ====================
export 'presentation/providers/healthcare_provider.dart';
