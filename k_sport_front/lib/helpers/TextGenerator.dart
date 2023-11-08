import 'dart:math';

class TextGenerator {
  static String randomMotivationalText() {
    final List<String> motivationalTexts = [
      "Croyez en vous !",
      "Continuez à avancer !",
      "N'abandonnez jamais vos rêves !",
      "Vous pouvez le faire !",
      "Faites d'aujourd'hui votre journée !",
      "Soyez le changement que vous voulez voir dans le monde.",
      "Chaque pas est un pas vers le succès.",
      "Peu importe la lenteur, tant qu'on ne s'arrête pas.",
      "La persévérance est la clé du succès.",
      "La motivation vient de l'action.",
      "Dépassez vos limites chaque jour.",
      "Saisissez chaque opportunité.",
      "Rêvez grand, travaillez dur, restez concentré.",
      "L'effort constant crée le succès.",
      "Votre seule limite est vous-même.",
    ];

    final randomIndex = Random().nextInt(motivationalTexts.length);
    return motivationalTexts[randomIndex];
  }

  static String randomGreeting() {
    final List<String> morningGreetings = [
      "Bonjour",
      "Bonne matinée",
      "Réveillez-vous et brillez",
      "Un nouveau jour vous attend",
    ];

    final List<String> afternoonGreetings = [
      "Bonne après-midi",
      "C'est un bel après-midi",
      "Profitez de votre journée",
      "Passez un merveilleux après-midi",
    ];

    final List<String> eveningGreetings = [
      "Bonne soirée",
      "Quelle belle soirée",
      "Détendez-vous, la journée est finie",
      "Profitez de votre soirée",
    ];

    final hour = DateTime.now().hour;
    Random random = Random();
    if (hour < 12) {
      return morningGreetings[random.nextInt(morningGreetings.length)];
    } else if (hour < 18) {
      return afternoonGreetings[random.nextInt(afternoonGreetings.length)];
    } else {
      return eveningGreetings[random.nextInt(eveningGreetings.length)];
    }
  }
}
