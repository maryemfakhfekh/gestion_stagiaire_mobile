class ApiEndpoints {
  // Base
  static const String baseUrl = "http://10.0.2.2:8085/api";

  // Auth
  static const String login = "/auth/login";
  static const String register = "/auth/register";

  // Références
  static const String filieres = "/references/filieres";
  static const String cycles = "/references/cycles";

  // Sujets
  static const String subjects = "/sujets";
  static const String subjectsDisponibles = "/sujets/disponibles";
  static const String addSubject = "/sujets/add";

  // Stagiaires
  static const String interns = "/stagiaires";
  static const String internProfile = "/stagiaires/mon-dossier";
  static const String hasDossier = "/stagiaires/has-dossier";
  static const String postuler = "/candidatures/postuler";

  // Tâches stagiaire
  static const String mesTaches = "/taches/mes-taches";
  static String tacheStatut(int id) => "/taches/$id/statut";

  // Rapport stagiaire
  static const String deposerRapport = "/rapports/deposer";
  static const String monRapport = "/rapports/mon-rapport";

  // Encadrant
  static const String encadrantStagiaires = "/stagiaires/mes-stagiaires";
  static const String encadrantDashboard = "/stagiaires";
  static const String encadrantTaches = "/taches";
  static String encadrantTachesByStagiaire(int stagiaireId) =>
      "/taches/stagiaire/$stagiaireId";
  static String encadrantTacheById(int tacheId) => "/taches/$tacheId";
  static String encadrantTacheCommentaires(int tacheId) =>
      "/taches/$tacheId/commentaires";
  static String encadrantEvaluations = "/evaluations";
  static String encadrantEvaluationByStagiaire(int stagiaireId) =>
      "/evaluations/stagiaire/$stagiaireId";
  static String creerTachePourStagiaire(int stagiaireId) =>
      "/taches/stagiaire/$stagiaireId";
}