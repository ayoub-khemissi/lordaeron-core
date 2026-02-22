-- ============================================================================
-- Trial of the Champion (ToC5, Map 650) - Creature Text Locale
-- Translations sourced from broadcast_text_locale (official Blizzard data)
-- Locales: deDE, esES, esMX, frFR, ruRU
-- ============================================================================

DELETE FROM `creature_text_locale` WHERE `CreatureID` IN (34928, 34990, 34994, 34995, 34996, 35004, 35005, 35119, 35451);

INSERT INTO `creature_text_locale` (`CreatureID`, `GroupID`, `ID`, `Locale`, `Text`) VALUES
-- =====================
-- deDE (German)
-- =====================
-- Argent Confessor Paletress (34928)
(34928, 0, 0, 'deDE', 'Ich danke Euch, werter Herold. Ihr seid zu gütig.'),
(34928, 1, 0, 'deDE', 'Möge das Licht mir die Stärke verleihen, Euch einen würdigen Kampf zu bieten.'),
(34928, 2, 0, 'deDE', 'Nun gut, dann fangen wir an.'),
(34928, 3, 0, 'deDE', 'Nehmt Euch die Zeit, Eure vergangen Taten zu überdenken.'),
(34928, 4, 0, 'deDE', 'Selbst die dunkelste Erinnerung schwindet, wenn man sie konfrontiert.'),
(34928, 5, 0, 'deDE', 'Ruht Euch aus.'),
(34928, 5, 1, 'deDE', 'Seid ganz entspannt.'),
(34928, 6, 0, 'deDE', 'Gute Arbeit.'),
-- King Varian Wrynn (34990)
(34990, 0, 0, 'deDE', 'Steht nicht einfach nur da! Tötet ihn!'),
(34990, 1, 0, 'deDE', 'Ihr habt Euch gut geschlagen.'),
-- Thrall (34994)
(34994, 0, 0, 'deDE', 'Gut gemacht, Horde!'),
-- Garrosh Hellscream (34995)
(34995, 0, 0, 'deDE', 'Reißt ihn in Stücke!'),
-- Highlord Tirion Fordring (34996)
(34996, 0, 0, 'deDE', 'Willkommen, Champions. Heute werdet Ihr Euch unter den Augen Eurer Anführer und Angehöriger Eures Volks als würdige Kämpfer beweisen können.'),
(34996, 1, 0, 'deDE', 'Ihr werdet Euch zuerst drei der Großchampions des Turniers stellen! Diese grimmigen Kämpfer haben alle anderen geschlagen, um ihre Fähigkeiten in der Tjost zu perfektionieren.'),
(34996, 2, 0, 'deDE', 'Fangt an!'),
(34996, 3, 0, 'deDE', 'Gut gekämpft! Eure nächste Herausforderung kommt aus den eigenen Reihen des Kreuzzugs. Ihr werdet Euch gegen ihre eindrucksvolle Tapferkeit beweisen müssen.'),
(34996, 4, 0, 'deDE', 'Ihr mögt beginnen!'),
(34996, 5, 0, 'deDE', 'Gut gemacht. Ihr habt Euch heute bewiesen...'),
(34996, 6, 0, 'deDE', 'Was soll das bedeuten?'),
(34996, 7, 0, 'deDE', 'Meine Glückwünsche, Champions. In Prüfungen sowohl geplant als auch unerwartet habt Ihr triumphiert.'),
(34996, 8, 0, 'deDE', 'Geht jetzt und erholt Euch; Ihr habt es Euch verdient.'),
-- Jaeren Sunsworn (35004) - Horde herald
(35004, 0, 0, 'deDE', 'Der Silberbund schätzt sich glücklich, seine Kämpfer für dieses Ereignis präsentieren zu dürfen, Hochlord.'),
(35004, 1, 0, 'deDE', 'Stolz und stark steht er da, Marschall Jacob Alerius, der Großchampion von Sturmwind! Applaus, Applaus, Applaus!'),
(35004, 2, 0, 'deDE', 'Hier kommt der kleine, aber tödliche Ambrose Bolzenfunk, Großchampion von Gnomeregan!'),
(35004, 3, 0, 'deDE', 'Und hier schreitet er durch die Tore, Kolosos, der gewaltige Großchampion der Exodar!'),
(35004, 4, 0, 'deDE', 'Und nun betritt die Arena die geschickte Schildwache Jaelyne Abendlied, Großchampion von Darnassus!'),
(35004, 5, 0, 'deDE', 'Die Macht der Zwerge wird heute repräsentiert von Lana Starkhammer, Großchampion von Eisenschmiede!'),
(35004, 6, 0, 'deDE', 'Nun betritt die Arena ein Paladin, der sich sowohl auf dem Schlachtfeld als auch im Turnierring zuhause fühlt, der Großchampion des Argentumkreuzzugs, Eadric der Reine!'),
(35004, 7, 0, 'deDE', 'Die nächste Kämpferin ist allen überlegen in ihrer Leidenschaft, das Licht hochzuhalten. Hier ist sie, die Argentumbeichtpatin Blondlocke!'),
(35004, 8, 0, 'deDE', 'Was ist das, dort, in der Nähe der Sparren?'),
-- Arelas Brightstar (35005) - Alliance herald
(35005, 0, 0, 'deDE', 'Die Sonnenhäscher präsentieren voller Stolz ihre Vertreter in diesem kämpferischen Auswahlverfahren.'),
(35005, 1, 0, 'deDE', 'Wir stellen vor: der wilde Großchampion von Orgrimmar, Mokra der Schädelberster!'),
(35005, 2, 0, 'deDE', 'Es tritt aus dem Tor Eressa Morgensänger, erfahrene Magierin und Großchampion von Silbermond!'),
(35005, 3, 0, 'deDE', 'Hier ist er, aufrecht im Sattel seines Kodos, der ehrwürdige Runok Wildmähne, Großchampion von Donnerfels!'),
(35005, 4, 0, 'deDE', 'Und nun betritt die Arena der geschmeidige und gefährliche Zul''tore, Großchampion von Sen''jin!'),
(35005, 5, 0, 'deDE', 'Und hier ist er, das Beispiel der Zähigkeit der Verlassenen, hier ist der Großchampion von Unterstadt, Todespirscher Visceri!'),
(35005, 6, 0, 'deDE', 'Nun betritt die Arena ein Paladin, der sich sowohl auf dem Schlachtfeld als auch im Turnierring zuhause fühlt, der Großchampion des Argentumkreuzzugs, Eadric der Reine!'),
(35005, 7, 0, 'deDE', 'Die nächste Kämpferin ist allen überlegen in ihrer Leidenschaft, das Licht hochzuhalten. Hier ist sie, die Argentumbeichtpatin Blondlocke!'),
(35005, 8, 0, 'deDE', 'Was ist das, dort, in der Nähe der Sparren?'),
-- Eadric the Pure (35119)
(35119, 0, 0, 'deDE', 'Seid Ihr für die Herausforderung bereit? Ich werde mich nicht zurückhalten.'),
(35119, 1, 0, 'deDE', 'Seid bereit!'),
(35119, 2, 0, 'deDE', '%s beginnt, Licht auszustrahlen! Schützt Eure Augen!'),
(35119, 3, 0, 'deDE', '%s zielt mit dem ''Hammer der Rechtschaffenen'' auf $n!'),
(35119, 4, 0, 'deDE', 'Hammer der Rechtschaffenen!'),
(35119, 5, 0, 'deDE', 'Hah! Ihr! Ihr braucht mehr Übung.'),
(35119, 5, 1, 'deDE', 'Nein! Nein und noch mal, nein! Nicht gut genug.'),
(35119, 6, 0, 'deDE', 'Ich ergebe mich! Exzellente Arbeit. Darf ich jetzt wegrennen?'),
-- The Black Knight (35451)
(35451, 0, 0, 'deDE', 'Du hast meinen Auftritt versaut, du Ratte.'),
(35451, 1, 0, 'deDE', 'Habt ihr wirklich geglaubt, ein Agent des Lichkönigs könnte auf dem Boden eures erbärmlichen kleinen Turniers geschlagen werden?'),
(35451, 2, 0, 'deDE', 'Ich komme, um meinen Auftrag zu beenden.'),
(35451, 3, 0, 'deDE', 'Diese Farce endet hier!'),
(35451, 4, 0, 'deDE', 'Mein verrottetes Fleisch war sowieso nur im Weg!'),
(35451, 5, 0, 'deDE', 'Ich brauche keine Knochen, um euch zu bezwingen!'),
(35451, 6, 0, 'deDE', 'Fleischverschwendung.'),
(35451, 6, 1, 'deDE', 'Jämmerlich.'),
(35451, 7, 0, 'deDE', 'Nein! Ich darf nicht... wieder... versagen...'),

-- =====================
-- esES (Spanish - Spain)
-- =====================
-- Argent Confessor Paletress (34928)
(34928, 0, 0, 'esES', 'Gracias, buen heraldo. Tus palabras son muy amables.'),
(34928, 1, 0, 'esES', 'Que la Luz me dé fuerzas para ser un reto digno.'),
(34928, 2, 0, 'esES', 'Bien, empecemos.'),
(34928, 3, 0, 'esES', 'Aprovecha este tiempo para pensar en tus hazañas.'),
(34928, 4, 0, 'esES', '¡Incluso el recuerdo más oscuro se desvanece al afrontarlo!'),
(34928, 5, 0, 'esES', 'Descansa.'),
(34928, 5, 1, 'esES', 'Ve en paz.'),
(34928, 6, 0, 'esES', 'Excelente.'),
-- King Varian Wrynn (34990)
(34990, 0, 0, 'esES', 'No os quedéis ahí. ¡Matadlo!'),
(34990, 1, 0, 'esES', 'Habéis luchado bien.'),
-- Thrall (34994)
(34994, 0, 0, 'esES', '¡Bien hecho, Horda!'),
-- Garrosh Hellscream (34995)
(34995, 0, 0, 'esES', '¡Hacedlo pedazos!'),
-- Highlord Tirion Fordring (34996)
(34996, 0, 0, 'esES', 'Bienvenidos, campeones. Hoy, ante los ojos de vuestros líderes y coetáneos, demostraréis ser dignos luchadores.'),
(34996, 1, 0, 'esES', '¡Primero os enfrentaréis a tres de los Grandes Campeones del torneo! Estos fieros contrincantes han derrotado a todos los demás para alcanzar la cima de la habilidad en las justas.'),
(34996, 2, 0, 'esES', '¡Comenzad!'),
(34996, 3, 0, 'esES', '¡Bien luchado! Vuestro próximo reto llega de entre las filas de la propia Cruzada. Se os pondrá a prueba contra su considerable destreza.'),
(34996, 4, 0, 'esES', '¡Podéis comenzar!'),
(34996, 5, 0, 'esES', 'Bien hecho. Hoy has demostrado algo...'),
(34996, 6, 0, 'esES', '¿Qué significa esto?'),
(34996, 7, 0, 'esES', 'Mi enhorabuena, campeones. Habéis triunfado a los largo de estas pruebas, tanto planeadas como inesperadas.'),
(34996, 8, 0, 'esES', 'Id y descansad; os lo habéis ganado.'),
-- Jaeren Sunsworn (35004) - Horde herald
(35004, 0, 0, 'esES', 'El Pacto de Plata está encantado de presentar a sus luchadores para este evento, Alto Señor.'),
(35004, 1, 0, 'esES', 'Fuerte y orgulloso, ¡aclamad al mariscal Jacob Alerius, el Gran Campeón de Ventormenta!'),
(35004, 2, 0, 'esES', 'Aquí llega el pequeño pero mortal Ambrose Chisparrayo, Gran Campeón de Gnomeregan.'),
(35004, 3, 0, 'esES', 'Colosos, el enorme Gran Campeón de El Exodar, está saliendo por la puerta.'),
(35004, 4, 0, 'esES', 'Está entrando en la arena la Gran Campeona de Darnassus, la hábil centinela Jaelyne Unicanto.'),
(35004, 5, 0, 'esES', 'Hoy el poder de los enanos está representado por la Gran Campeona de Forjaz, Lana Martillotenaz.'),
(35004, 6, 0, 'esES', 'Entrando en la arena, tenemos a un paladín que no es un extraño para los campos de batalla, ni los Campos del Torneo. ¡El gran campeón de la Cruzada Argenta, Eadric el Puro!'),
(35004, 7, 0, 'esES', 'La siguiente combatiente no tiene rival alguno en su pasión al apoyar a la Luz. ¡Os entrego a la confesora Argenta Cabelloclaro!'),
(35004, 8, 0, 'esES', '¿Qué es eso que hay cerca de las vigas?'),
-- Arelas Brightstar (35005) - Alliance herald
(35005, 0, 0, 'esES', 'Los Atracasol están orgullosos de presentar a sus representantes en estas pruebas de combate.'),
(35005, 1, 0, 'esES', 'Presentamos al fiero Gran Campeón de Orgrimmar, ¡Mokra el Trituracráneos!'),
(35005, 2, 0, 'esES', 'Saliendo por la puerta vemos a Eressea Cantoalba, habilidosa maga y Gran Campeona de Lunargenta.'),
(35005, 3, 0, 'esES', 'Erguido en la silla de su kodo, vemos al venerable Runok Ferocrín, Gran Campeón de Cima del Trueno.'),
(35005, 4, 0, 'esES', '¡Zul''tore, el Gran Campeón de Sen''jin, está entrando en la arena!'),
(35005, 5, 0, 'esES', 'Aquí tenemos al Gran Campeón de Entrañas, el Mortacechador Visceri, representando la tenacidad de los Renegados.'),
(35005, 6, 0, 'esES', 'Entrando en la arena, tenemos a un paladín que no es un extraño para los campos de batalla, ni los Campos del Torneo. ¡El gran campeón de la Cruzada Argenta, Eadric el Puro!'),
(35005, 7, 0, 'esES', 'La siguiente combatiente no tiene rival alguno en su pasión al apoyar a la Luz. ¡Os entrego a la confesora Argenta Cabelloclaro!'),
(35005, 8, 0, 'esES', '¿Qué es eso que hay cerca de las vigas?'),
-- Eadric the Pure (35119)
(35119, 0, 0, 'esES', '¿Aceptáis el reto? No hay vuelta atrás.'),
(35119, 1, 0, 'esES', '¡Preparaos!'),
(35119, 2, 0, 'esES', '¡%s comienza a irradiar luz! ¡Tápate los ojos!'),
(35119, 3, 0, 'esES', '¡%s selecciona a $n como objetivo para el Martillo del honrado!'),
(35119, 4, 0, 'esES', '¡Martillo del honrado!'),
(35119, 5, 0, 'esES', '¡Tú! Tienes que practicar más.'),
(35119, 5, 1, 'esES', '¡No, no y otra vez no! No es suficiente.'),
(35119, 6, 0, 'esES', '¡Me rindo! Lo admito. Un trabajo excelente. ¿Puedo escaparme ya?'),
-- The Black Knight (35451)
(35451, 0, 0, 'esES', 'Has estropeado mi gran entrada, rata.'),
(35451, 1, 0, 'esES', '¿Realmente pensabas que derrotarías a un agente del Rey Exánime en los campos de tu patético torneo?'),
(35451, 2, 0, 'esES', 'He venido a terminar mi cometido.'),
(35451, 3, 0, 'esES', '¡Esta farsa acaba aquí!'),
(35451, 4, 0, 'esES', '¡Me estorbaba esa carne putrefacta!'),
(35451, 5, 0, 'esES', '¡No necesito huesos para vencerte!'),
(35451, 6, 0, 'esES', 'Una pérdida de carne.'),
(35451, 6, 1, 'esES', 'Patético.'),
(35451, 7, 0, 'esES', '¡No! No debo fallar... otra vez...'),

-- =====================
-- esMX (Spanish - Latin America)
-- =====================
-- Argent Confessor Paletress (34928)
(34928, 0, 0, 'esMX', 'Gracias, buen heraldo. Tus palabras son muy amables.'),
(34928, 1, 0, 'esMX', 'Que la Luz me de la fuerza para brindar un reto digno.'),
(34928, 2, 0, 'esMX', 'Bien, comencemos.'),
(34928, 3, 0, 'esMX', 'Aprovecha este momento para pensar en tus acciones pasadas.'),
(34928, 4, 0, 'esMX', '¡Hasta el recuerdo más oscuro se desvanece al enfrentarlo!'),
(34928, 5, 0, 'esMX', 'Descansa.'),
(34928, 5, 1, 'esMX', 'Tranquilo.'),
(34928, 6, 0, 'esMX', 'Excelente.'),
-- King Varian Wrynn (34990)
(34990, 0, 0, 'esMX', 'No se queden ahí. ¡Mátenlo!'),
(34990, 1, 0, 'esMX', 'Han luchado bien.'),
-- Thrall (34994)
(34994, 0, 0, 'esMX', '¡Bien hecho, Horda!'),
-- Garrosh Hellscream (34995)
(34995, 0, 0, 'esMX', '¡Hacedlo pedazos!'),
-- Highlord Tirion Fordring (34996)
(34996, 0, 0, 'esMX', 'Bienvenidos, campeones. Hoy, ante los ojos de sus líderes y coetáneos, demostrarán ser dignos luchadores.'),
(34996, 1, 0, 'esMX', '¡Primero se enfrentarán a tres de los Grandes Campeones del torneo! Estos fieros contrincantes han derrotado a todos los demás para alcanzar la cima de la habilidad en las justas.'),
(34996, 2, 0, 'esMX', '¡Comenzad!'),
(34996, 3, 0, 'esMX', '¡Bien luchado! Su próximo reto llega de entre las filas de la propia Cruzada. Se les pondrá a prueba contra su considerable destreza.'),
(34996, 4, 0, 'esMX', '¡Pueden comenzar!'),
(34996, 5, 0, 'esMX', 'Bien hecho. Hoy has demostrado algo...'),
(34996, 6, 0, 'esMX', '¿Qué significa esto?'),
(34996, 7, 0, 'esMX', 'Mis felicitaciones, campeones. Han triunfado a los largo de estas pruebas, tanto planeadas como inesperadas.'),
(34996, 8, 0, 'esMX', 'Vayan y descansen; se lo han ganado.'),
-- Jaeren Sunsworn (35004) - Horde herald
(35004, 0, 0, 'esMX', 'El Pacto de Plata está encantado de presentar a sus luchadores para este evento, Alto Señor.'),
(35004, 1, 0, 'esMX', 'Fuerte y orgulloso, ¡aclamad al mariscal Jacob Alerius, el Gran Campeón de Ventormenta!'),
(35004, 2, 0, 'esMX', 'Aquí llega el pequeño pero mortal Ambrose Chisparrayo, Gran Campeón de Gnomeregan.'),
(35004, 3, 0, 'esMX', 'Colosos, el enorme Gran Campeón de El Exodar, está saliendo por la puerta.'),
(35004, 4, 0, 'esMX', 'Está entrando en la arena la Gran Campeona de Darnassus, la hábil centinela Jaelyne Unicanto.'),
(35004, 5, 0, 'esMX', 'Hoy el poder de los enanos está representado por la Gran Campeona de Forjaz, Lana Martillotenaz.'),
(35004, 6, 0, 'esMX', 'Entrando en la arena, tenemos a un paladín que no es un extraño para los campos de batalla, ni los Campos del Torneo. ¡El gran campeón de la Cruzada Argenta, Eadric el Puro!'),
(35004, 7, 0, 'esMX', 'La siguiente combatiente no tiene rival alguno en su pasión al apoyar a la Luz. ¡Les entrego a la confesora Argenta Cabelloclaro!'),
(35004, 8, 0, 'esMX', '¿Qué es eso que hay cerca de las vigas?'),
-- Arelas Brightstar (35005) - Alliance herald
(35005, 0, 0, 'esMX', 'Los Atracasol están orgullosos de presentar a sus representantes en estas pruebas de combate.'),
(35005, 1, 0, 'esMX', 'Presentamos al fiero Gran Campeón de Orgrimmar, ¡Mokra el Trituracráneos!'),
(35005, 2, 0, 'esMX', 'Saliendo por la puerta vemos a Eressea Cantoalba, habilidosa maga y Gran Campeona de Lunargenta.'),
(35005, 3, 0, 'esMX', 'Erguido en la silla de su kodo, vemos al venerable Runok Ferocrín, Gran Campeón de Cima del Trueno.'),
(35005, 4, 0, 'esMX', '¡Zul''tore, el Gran Campeón de Sen''jin, está entrando en la arena!'),
(35005, 5, 0, 'esMX', 'Aquí tenemos al Gran Campeón de Entrañas, el Mortacechador Visceri, representando la tenacidad de los Renegados.'),
(35005, 6, 0, 'esMX', 'Entrando en la arena, tenemos a un paladín que no es un extraño para los campos de batalla, ni los Campos del Torneo. ¡El gran campeón de la Cruzada Argenta, Eadric el Puro!'),
(35005, 7, 0, 'esMX', 'La siguiente combatiente no tiene rival alguno en su pasión al apoyar a la Luz. ¡Les entrego a la confesora Argenta Cabelloclaro!'),
(35005, 8, 0, 'esMX', '¿Qué es eso que hay cerca de las vigas?'),
-- Eadric the Pure (35119)
(35119, 0, 0, 'esMX', '¿Están a la altura del desafío? No me contendré.'),
(35119, 1, 0, 'esMX', '¡Prepárense!'),
(35119, 2, 0, 'esMX', '¡%s comienza a irradiar luz! ¡Tápate los ojos!'),
(35119, 3, 0, 'esMX', '¡%s selecciona a $n como objetivo para el Martillo de la justicia!'),
(35119, 4, 0, 'esMX', '¡El Martillo de la Justicia!'),
(35119, 5, 0, 'esMX', '¡Ustedes! Necesitan más práctica.'),
(35119, 5, 1, 'esMX', '¡No! ¡No! ¡Y lo repito: no! No alcanzó.'),
(35119, 6, 0, 'esMX', '¡Me rindo! Abandono. Excelente trabajo. ¿Ya me puedo ir corriendo?'),
-- The Black Knight (35451)
(35451, 0, 0, 'esMX', 'Arruinaste mi entrada triunfal, rata.'),
(35451, 1, 0, 'esMX', '¿Realmente pensaron que un agente del Rey Exánime podía llegar a perder en este torneíto patético?'),
(35451, 2, 0, 'esMX', 'He venido a terminar mi tarea.'),
(35451, 3, 0, 'esMX', '¡Esta farsa se termina ahora!'),
(35451, 4, 0, 'esMX', '¡Mi piel putrefacta me estorbaba!'),
(35451, 5, 0, 'esMX', '¡No necesito huesos para ganarte!'),
(35451, 6, 0, 'esMX', 'Qué desperdicio de carne.'),
(35451, 6, 1, 'esMX', 'Patético.'),
(35451, 7, 0, 'esMX', '¡No! No debo fallar... de nuevo...'),

-- =====================
-- frFR (French)
-- =====================
-- Argent Confessor Paletress (34928)
(34928, 0, 0, 'frFR', 'Merci, mon bon héraut. Vous êtes trop gentil.'),
(34928, 1, 0, 'frFR', 'Puisse la Lumière me donner la force de présenter un défi à la hauteur.'),
(34928, 2, 0, 'frFR', 'Bien, commençons.'),
(34928, 3, 0, 'frFR', 'Prenez le temps de revenir sur vos actes passés.'),
(34928, 4, 0, 'frFR', 'Même le plus noir souvenir s''estompe quand on le regarde en face.'),
(34928, 5, 0, 'frFR', 'Trouvez le repos.'),
(34928, 5, 1, 'frFR', 'Soyez apaisés.'),
(34928, 6, 0, 'frFR', 'Très bon travail.'),
-- King Varian Wrynn (34990)
(34990, 0, 0, 'frFR', 'Ne restez pas plantés là, tuez-le !'),
(34990, 1, 0, 'frFR', 'Vous avez bien combattu.'),
-- Thrall (34994)
(34994, 0, 0, 'frFR', 'Bien joué, Horde !'),
-- Garrosh Hellscream (34995)
(34995, 0, 0, 'frFR', 'Mettez-le en pièces !'),
-- Highlord Tirion Fordring (34996)
(34996, 0, 0, 'frFR', 'Bienvenue, champions. Aujourd''hui, devant vos rois et pairs, vous allez faire montre de votre valeur.'),
(34996, 1, 0, 'frFR', 'Vous allez commencer par affronter trois des grands champions du tournoi ! Ces féroces combattants ont triomphé de tous pour atteindre le plus haut niveau de la joute.'),
(34996, 2, 0, 'frFR', 'Qu''ils commencent !'),
(34996, 3, 0, 'frFR', 'Joli combat ! Votre prochain défi vient directement des rangs de la Croisade. L''épreuve sera de vous mesurer à l''incroyable virtuosité de ses cavaliers.'),
(34996, 4, 0, 'frFR', 'Vous pouvez commencer !'),
(34996, 5, 0, 'frFR', 'Bien joué. Aujourd''hui, vous avez fait la preuv-'),
(34996, 6, 0, 'frFR', 'Qu''est-ce que tout cela signifie ?'),
(34996, 7, 0, 'frFR', 'Mes félicitations, champions. Dans l''épreuve prévue comme dans l''imprévue, vous avez triomphé.'),
(34996, 8, 0, 'frFR', 'Maintenant, allez vous reposer. Vous l''avez bien mérité.'),
-- Jaeren Sunsworn (35004) - Horde herald
(35004, 0, 0, 'frFR', 'Le Concordat argenté est heureux de vous présenter ses compétiteurs pour l''évènement, généralissime.'),
(35004, 1, 0, 'frFR', 'Fier et puissant ! Acclamez le maréchal Jacob Alerius, grand champion de Hurlevent !'),
(35004, 2, 0, 'frFR', 'Voici le petit mais costaud Ambrose Étinceboulon, grand champion de Gnomeregan !'),
(35004, 3, 0, 'frFR', 'Le voilà qui passe la porte, c''est Colossos, l''imposant grand champion de l''Exodar !'),
(35004, 4, 0, 'frFR', 'Et voici maintenant qui pénètre dans l''arène la grande championne de Darnassus, la talentueuse sentinelle Jaelyne Chant-du-soir !'),
(35004, 5, 0, 'frFR', 'Toute la force naine est aujourd''hui représentée par la grande championne de Forgefer, Lana Rudemartel !'),
(35004, 6, 0, 'frFR', 'Voici qu''entre dans l''arène un paladin qui connaît aussi bien les champs de bataille que les lices du tournoi, le grand champion de la Croisade d''argent, Eadric le Pur !'),
(35004, 7, 0, 'frFR', 'La prochaine combattante ne connaît pas de pareille dans sa passion et sa défense de la Lumière. Voici le confesseur d''argent Paletress !'),
(35004, 8, 0, 'frFR', 'Qu''est-ce que c''est, là-haut, sur cette poutre ?'),
-- Arelas Brightstar (35005) - Alliance herald
(35005, 0, 0, 'frFR', 'Les Saccage-soleil sont fiers d''annoncer leurs représentants pour ce jugement par l''épée.'),
(35005, 1, 0, 'frFR', 'Je vous présente le féroce grand champion d''Orgrimmar, Mokra le Brise-tête !'),
(35005, 2, 0, 'frFR', 'Et la voici qui passe la porte, Eressea Chantelaube, talentueuse mage et grande championne de Lune-d''Argent !'),
(35005, 3, 0, 'frFR', 'Monté haut sur la selle de son kodo, voici le vénérable Runok Crin-sauvage, grand champion des Pitons-du-Tonnerre !'),
(35005, 4, 0, 'frFR', 'Le voici qui pénètre dans l''arène, c''est le fin et redoutable Zul''tore, grand champion de Sen''jin !'),
(35005, 5, 0, 'frFR', 'Il incarne la ténacité des Réprouvés, c''est le grand champion de Fossoyeuse, le nécrotraqueur Viscéri !'),
(35005, 6, 0, 'frFR', 'Voici qu''entre dans l''arène un paladin qui connaît aussi bien les champs de bataille que les lices du tournoi, le grand champion de la Croisade d''argent, Eadric le Pur !'),
(35005, 7, 0, 'frFR', 'La prochaine combattante ne connaît pas de pareille dans sa passion et sa défense de la Lumière. Voici le confesseur d''argent Paletress !'),
(35005, 8, 0, 'frFR', 'Qu''est-ce que c''est, là-haut, sur cette poutre ?'),
-- Eadric the Pure (35119)
(35119, 0, 0, 'frFR', 'Serez-vous à la hauteur du défi ? Je ne vais pas retenir mes coups.'),
(35119, 1, 0, 'frFR', 'Préparez-vous !'),
(35119, 2, 0, 'frFR', '%s commence à émettre de la lumière. Protégez vos yeux !'),
(35119, 3, 0, 'frFR', '%s cible $n avec son Marteau du vertueux !'),
(35119, 4, 0, 'frFR', 'Marteau du vertueux !'),
(35119, 5, 0, 'frFR', 'Vous ! Il faut vous entraîner plus.'),
(35119, 5, 1, 'frFR', 'Nenni ! Je le dis et le répète, nenni ! Pas à la hauteur.'),
(35119, 6, 0, 'frFR', 'Grâce ! Je me rends. Excellent travail. Puis-je me débiner, maintenant ?'),
-- The Black Knight (35451)
(35451, 0, 0, 'frFR', 'Tu as gâché mon entrée, rat.'),
(35451, 1, 0, 'frFR', 'Vous pensiez vraiment qu''un agent du roi-liche serait vaincu sur la piste de votre pitoyable petit tournoi ?'),
(35451, 2, 0, 'frFR', 'Je suis venu finir mon travail.'),
(35451, 3, 0, 'frFR', 'Finissons-en avec cette farce !'),
(35451, 4, 0, 'frFR', 'Cette chair pourrie ne faisait que me ralentir !'),
(35451, 5, 0, 'frFR', 'Pas besoin de mes os pour vous vaincre !'),
(35451, 6, 0, 'frFR', 'Quel gâchis de chair.'),
(35451, 6, 1, 'frFR', 'Pathétique.'),
(35451, 7, 0, 'frFR', 'Non ! Pas encore... un échec...'),

-- =====================
-- ruRU (Russian)
-- =====================
-- Argent Confessor Paletress (34928)
(34928, 0, 0, 'ruRU', 'Благодарю вас, любезный герольд. Вы слишком добры ко мне.'),
(34928, 1, 0, 'ruRU', 'Да придаст мне Свет силы, чтобы стать достойным противником!'),
(34928, 2, 0, 'ruRU', 'Что ж, начнём.'),
(34928, 3, 0, 'ruRU', 'А теперь подумайте о своих прежних прегрешениях.'),
(34928, 4, 0, 'ruRU', 'Даже самые тягостные воспоминания отступят, если смело взглянуть им в лицо!'),
(34928, 5, 0, 'ruRU', 'Отдыхай.'),
(34928, 5, 1, 'ruRU', 'Покойся с миром.'),
(34928, 6, 0, 'ruRU', 'Великолепная работа.'),
-- King Varian Wrynn (34990)
(34990, 0, 0, 'ruRU', 'Да не стойте вы! Убить его!'),
(34990, 1, 0, 'ruRU', 'Вы сражались достойно.'),
-- Thrall (34994)
(34994, 0, 0, 'ruRU', 'Так держать, Орда!'),
-- Garrosh Hellscream (34995)
(34995, 0, 0, 'ruRU', 'Разорвите его!'),
-- Highlord Tirion Fordring (34996)
(34996, 0, 0, 'ruRU', 'Добро пожаловать, герои. Сегодня вы продемонстрируете свою силу и стойкость перед вашими предводителями и другими участниками турнира.'),
(34996, 1, 0, 'ruRU', 'Сначала вам предстоит сразиться с тремя абсолютными чемпионами турнира! Эти беспощадные бойцы многих смели на пути к вершине славы.'),
(34996, 2, 0, 'ruRU', 'Начинайте!'),
(34996, 3, 0, 'ruRU', 'Вы отлично сражались! Следующим испытанием станет битва с одним из членов Авангарда. Вы проверите свои силы в схватке с достойным соперником.'),
(34996, 4, 0, 'ruRU', 'Вы можете начинать!'),
(34996, 5, 0, 'ruRU', 'Великолепно. Сегодня вы в честной борьбе заслужили...'),
(34996, 6, 0, 'ruRU', 'Что все это значит?'),
(34996, 7, 0, 'ruRU', 'Мои поздравления, чемпионы. Вы прошли все испытания – как запланированные, так и нет.'),
(34996, 8, 0, 'ruRU', 'Теперь вы можете отдыхать, вы это заслужили.'),
-- Jaeren Sunsworn (35004) - Horde herald
(35004, 0, 0, 'ruRU', 'Серебряный союз с гордостью представляет своих бойцов, верховный лорд.'),
(35004, 1, 0, 'ruRU', 'Гордые и сильные, поприветствуйте маршала Якоба Алерия, абсолютного чемпиона Штормграда!'),
(35004, 2, 0, 'ruRU', 'Поприветствуем невысокого, но оттого не менее грозного Амброза Искрокрута, абсолютного чемпиона Гномрегана!'),
(35004, 3, 0, 'ruRU', 'Из ворот выходит величественный Колосус, абсолютный чемпион Экзодара!'),
(35004, 4, 0, 'ruRU', 'Следующим на арену вступает абсолютный чемпион Дарнаса, талантливая Джейлин Закатная Песня!'),
(35004, 5, 0, 'ruRU', 'Вся мощь дворфов сегодня воплотилась в абсолютном чемпионе Стальгорна, Лане Твердомолот!'),
(35004, 6, 0, 'ruRU', 'На арену вступает паладин, чьей силе нет равных на всем ристалище. Приветствуйте абсолютного чемпиона Серебряного Авангарда Эдрика Чистого!'),
(35004, 7, 0, 'ruRU', 'Следующему претенденту нет равных в деле служения Свету. Представляю вам Исповедницу Серебряного Авангарда Пейлтресс!'),
(35004, 8, 0, 'ruRU', 'Что это там, под стропилами?'),
-- Arelas Brightstar (35005) - Alliance herald
(35005, 0, 0, 'ruRU', 'Похитители Солнца с гордостью представляют своих бойцов.'),
(35005, 1, 0, 'ruRU', 'Представляем вам абсолютного чемпиона Оргриммара, яростного Мокру Дробителя Черепов!'),
(35005, 2, 0, 'ruRU', 'Из ворот появляется Эрессея Певица Рассвета, непобедимый паладин и абсолютный чемпион Луносвета!'),
(35005, 3, 0, 'ruRU', 'Оседлав своего кодо, возвышается перед нами непобедимый Рунок Буйногривый, абсолютный чемпион Громового Утеса!'),
(35005, 4, 0, 'ruRU', 'На арену ступает непреклонный и смертоносный Зул''тор, абсолютный чемпион Сен''джина!'),
(35005, 5, 0, 'ruRU', 'На арену выходит абсолютный чемпион Подгорода, воплощение стойкости Отрекшихся – ловчий смерти Визери!'),
(35005, 6, 0, 'ruRU', 'На арену вступает паладин, чьей силе нет равных на всем ристалище. Приветствуйте абсолютного чемпиона Серебряного Авангарда Эдрика Чистого!'),
(35005, 7, 0, 'ruRU', 'Следующему претенденту нет равных в деле служения Свету. Представляю вам Исповедницу Серебряного Авангарда Пейлтресс!'),
(35005, 8, 0, 'ruRU', 'Что это там, под стропилами?'),
-- Eadric the Pure (35119)
(35119, 0, 0, 'ruRU', 'Желаете помериться силами? Я не отступлю!'),
(35119, 1, 0, 'ruRU', 'Готовьтесь!'),
(35119, 2, 0, 'ruRU', '%s начинает излучать свет! Закройте глаза!'),
(35119, 3, 0, 'ruRU', '%s метит прямо в $n Молотом праведника!'),
(35119, 4, 0, 'ruRU', 'Молот праведника!'),
(35119, 5, 0, 'ruRU', 'Эй, ты! Тебе необходимо больше тренироваться.'),
(35119, 5, 1, 'ruRU', 'Нет же, нет! И снова нет! Ты в плохой форме.'),
(35119, 6, 0, 'ruRU', 'Я сдаюсь! Я побежден. Отличная работа. Можно теперь убегать?'),
-- The Black Knight (35451)
(35451, 0, 0, 'ruRU', 'Ты испортил мой торжественный выход, гнусная крыса.'),
(35451, 1, 0, 'ruRU', 'Ты и правда считаешь, что участники вашего жалкого турнирчика смогут одолеть посланника Короля-лича?'),
(35451, 2, 0, 'ruRU', 'Я доведу начатое до конца.'),
(35451, 3, 0, 'ruRU', 'Пора заканчивать этот фарс!'),
(35451, 4, 0, 'ruRU', 'Моя дряхлая плоть лишь мешала в бою!'),
(35451, 5, 0, 'ruRU', 'Мне и кости не нужны, чтобы одолеть вас!'),
(35451, 6, 0, 'ruRU', 'Бренная плоть.'),
(35451, 6, 1, 'ruRU', 'Смехотворно.'),
(35451, 7, 0, 'ruRU', 'Нет! Я не могу... снова... проиграть.');
