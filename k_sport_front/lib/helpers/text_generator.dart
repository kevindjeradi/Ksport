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
      "Chaque jour est une nouvelle chance de réussir.",
      "Votre potentiel est infini.",
      "Osez rêver et agir pour réaliser ces rêves.",
      "Chaque obstacle est une étape vers le succès.",
      "Le courage ne cesse jamais de grandir.",
      "Créez votre propre chemin.",
      "Chaque moment est une opportunité de briller.",
      "La détermination mène à la réussite.",
      "Osez être différent, osez réussir.",
      "Construisez votre avenir dès aujourd'hui."
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
      "Un merveilleux matin s'annonce!",
      "Saluez ce beau matin avec un sourire.",
      "Que votre matinée soit aussi lumineuse que votre sourire.",
      "Démarrez la journée avec positivité.",
      "Un nouveau jour, de nouvelles opportunités.",
      "Que cette matinée vous apporte de la joie.",
      "Commencez la journée avec de l'énergie.",
      "Que chaque matin soit le début de quelque chose de beau."
    ];

    final List<String> afternoonGreetings = [
      "Bonne après-midi",
      "C'est un bel après-midi",
      "Profitez de votre journée",
      "Passez un merveilleux après-midi",
      "Que cet après-midi soit rempli de surprises agréables.",
      "Profitez de chaque instant de votre après-midi.",
      "Un après-midi radieux pour une personne radieuse.",
      "Que votre après-midi soit aussi productif que plaisant.",
      "Un merveilleux après-midi vous attend.",
      "L'après-midi est le moment idéal pour se revigorer.",
      "Continuez votre journée avec enthousiasme.",
      "Que la paix accompagne votre après-midi."
    ];

    final List<String> eveningGreetings = [
      "Bonne soirée",
      "Quelle belle soirée",
      "Détendez-vous, la journée est finie",
      "Profitez de votre soirée",
      "Que votre soirée soit relaxante et paisible.",
      "Une belle soirée pour une fin de journée parfaite.",
      "Profitez de la tranquillité de cette soirée.",
      "Que chaque soirée soit un moment de détente.",
      "Fermez la journée sur une note positive.",
      "Une soirée douce pour un repos mérité.",
      "Laissez les étoiles illuminer votre soirée.",
      "Que cette soirée soit aussi spéciale que vous."
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
